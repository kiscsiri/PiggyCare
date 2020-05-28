import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/helpers/pagination.helper.dart';
import 'package:piggybanx/models/post/user.post.dart';
import 'package:piggybanx/services/analytics.service.dart';

class UserPostService {
  static Future<UserPost> createUserPiggyPost(UserPost post) async {
    var user = await post.user.get();
    var isAutoPostEnabled = user.data['isAutoPostEnabled'] as bool;
    if (isAutoPostEnabled != null && isAutoPostEnabled) {
      await Firestore.instance.collection('userPosts').add(post.toJson());
      await AnalyticsService.logPostCreated();
    }
    return post;
  }

  static Future<List<DocumentSnapshot>> getUserPosts(
      PaginationHelper paginationHelper) async {
    var query = await Firestore.instance
        .collection('userPosts')
        .orderBy('postedDate', descending: true)
        .startAfter([
      paginationHelper.lastPostDate?.toDate() ?? Timestamp.now()
    ]).getDocuments();

    return query.documents;
  }

  static Future likePost(String postId, String userDocumentId) async {
    var post =
        await Firestore.instance.collection('userPosts').document(postId).get();

    var postDto = UserPost.fromMap(post, post.documentID);

    postDto.likes += 1;
    postDto.likedUserIds.add(userDocumentId);

    await Firestore.instance
        .collection('userPosts')
        .document(post.documentID)
        .updateData(postDto.toJson());

    await AnalyticsService.logPostLiked();
  }

  static Future removeLikeFromPost(String postId, String userDocumentId) async {
    var post =
        await Firestore.instance.collection('userPosts').document(postId).get();

    var postDto = UserPost.fromMap(post, post.documentID);

    postDto.likes -= 1;
    postDto.likedUserIds.removeWhere((d) => d == userDocumentId);

    await Firestore.instance
        .collection('userPosts')
        .document(post.documentID)
        .updateData(postDto.toJson());
    AnalyticsService.logDislike();
  }
}

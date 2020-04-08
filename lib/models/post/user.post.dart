import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.post.g.dart';

class UserPost {
  String id;
  String text;
  int likes;
  Timestamp postedDate;
  DocumentReference user;
  DocumentSnapshot documentSnapshot;
  List<String> likedUserIds;

  factory UserPost.fromMap(DocumentSnapshot snapshot, String documentId) =>
      $UserPostFromJson(snapshot, documentId);

  Map<String, dynamic> toJson() => $UserPostToJson(this);

  UserPost(
      {this.postedDate,
      this.id,
      this.text,
      this.likes,
      this.user,
      this.documentSnapshot,
      List<String> likedUserIds})
      : likedUserIds = likedUserIds ?? List<String>();
}

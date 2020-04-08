import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/models/post/user.post.dart';

UserPost $UserPostFromJson(DocumentSnapshot json, String documentId) {
  return UserPost(
    postedDate:
        json['postedDate'] != null ? json['postedDate'] as Timestamp : null,
    text: json['text'] as String,
    likes: json['likes'] as int,
    user: json['user'] as DocumentReference,
    id: documentId,
    documentSnapshot: json,
    likedUserIds:
        (json['likedUserIds'] as List)?.map<String>((e) => e)?.toList(),
  );
}

Map<String, dynamic> $UserPostToJson(UserPost instance) => <String, dynamic>{
      'text': instance.text,
      'likes': instance.likes,
      'user': instance.user,
      'likedUserIds': instance.likedUserIds,
      'id': instance.id ?? "0",
      'postedDate': instance.postedDate
    };

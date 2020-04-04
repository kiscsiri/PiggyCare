import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggycare/models/post/user.post.dart';

UserPost $UserPostFromJson(DocumentSnapshot json) {
  return UserPost(
    postedDate: json['postedDate'] != null
        ? DateTime.parse(json['postedDate'] as String)
        : null,
    text: json['text'] as String,
    likes: json['likes'] as int,
    user: json['user'] as DocumentReference,
    id: json['id'] as String,
  );
}

Map<String, dynamic> $UserPostToJson(UserPost instance) => <String, dynamic>{
      'text': instance.text,
      'likes': instance.likes,
      'user': instance.user,
      'id': instance.id ?? "0",
      'postedDate': instance.postedDate.toIso8601String()
    };

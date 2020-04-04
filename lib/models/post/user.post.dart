import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.post.g.dart';

class UserPost {
  final String id;
  final String text;
  final int likes;
  final DateTime postedDate;
  final DocumentReference user;

  factory UserPost.fromMap(DocumentSnapshot snapshot) =>
      $UserPostFromJson(snapshot);

  Map<String, dynamic> toJson() => $UserPostToJson(this);

  UserPost({this.postedDate, this.id, this.text, this.likes, this.user});
}

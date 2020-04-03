import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/widgets/piggy.post.dart';

class UserPostService {
  static Future createUserPost() async {}

  static Future<List<PostDto>> getUserPosts() async {
    Firestore.instance.collection('userPost').getDocuments();
  }
}

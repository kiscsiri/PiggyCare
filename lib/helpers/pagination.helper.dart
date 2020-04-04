import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationHelper {
  final int currentSize;
  final int fetchNumber;
  final String startAtParameter;
  final DocumentSnapshot lastDocument;

  PaginationHelper(this.currentSize, this.fetchNumber, this.startAtParameter,
      this.lastDocument);
}

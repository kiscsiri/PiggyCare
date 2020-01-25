class UserRequest {
  String id;
  String fromId;
  String toId;
  bool isPending;

  UserRequest({this.id, this.fromId, this.toId, this.isPending});

  UserRequest userRequestFromJson(Map json, String objectId) {
    return UserRequest(
        id: objectId,
        fromId: json['fromId'] as String,
        toId: json['toId'] as String,
        isPending: json['isPending'] as bool);
  }

  Map<String, dynamic> userRequestToJson() => <String, dynamic>{
      'fromId': this.fromId,
      'toId': this.toId,
      'isPending': this.isPending,
    };
}

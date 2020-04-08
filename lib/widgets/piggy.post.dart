import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/helpers/month.helper.dart';
import 'package:piggybanx/models/user/user.export.dart';

typedef Future<void> OnLike(postId, index);

class PiggyPost extends StatefulWidget {
  const PiggyPost(
      {Key key, @required this.post, this.likedByUser, this.onClick})
      : super(key: key);
  final PostDto post;
  final bool likedByUser;
  final OnLike onClick;

  @override
  _PiggyPostState createState() => _PiggyPostState();
}

class _PiggyPostState extends State<PiggyPost> {
  Future _likePost() async {
    await widget.onClick(widget.post.postId, widget.post.index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.2,
        height: MediaQuery.of(context).size.height * 0.215,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                      width: MediaQuery.of(context).size.height * 0.11,
                      height: MediaQuery.of(context).size.height * 0.11,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: (widget.post.user.pictureUrl?.isNotEmpty ??
                                      false)
                                  ? NetworkImage(widget.post.user.pictureUrl)
                                  : AssetImage("assets/images/business.png")))),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 9.0),
                        child: GestureDetector(
                          onTap: () async => await _likePost(),
                          child: widget.likedByUser
                              ? Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  FontAwesomeIcons.heart,
                                ),
                        ),
                      ),
                      Text(widget.post.likesCount.toString())
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.post.user.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      widget.post.text,
                      textAlign: TextAlign.left,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      (getMonthNameByIndex(
                                  widget.post.postedDate.toDate().month) +
                              " " +
                              widget.post.postedDate.toDate().day.toString()) +
                          ".",
                      style: TextStyle(color: Colors.grey)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        color: Colors.blue,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(
                10.0,
                10.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostDto {
  String postId;
  int index;
  String text;
  Timestamp postedDate;
  int likesCount;
  UserData user;
  List<String> likedByUserIds;
  DocumentSnapshot documentSnapshot;

  PostDto(
      {this.postedDate,
      this.postId,
      this.index,
      this.likesCount,
      this.text,
      this.user,
      this.likedByUserIds,
      this.documentSnapshot});
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PiggyPost extends StatefulWidget {
  const PiggyPost({Key key, @required this.post}) : super(key: key);
  final PostDto post;

  @override
  _PiggyPostState createState() => _PiggyPostState();
}

class _PiggyPostState extends State<PiggyPost> {
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
                              image: (widget.post.imageUrl?.isNotEmpty ?? false)
                                  ? NetworkImage(widget.post.imageUrl)
                                  : AssetImage(
                                      "assets/images/adult_profile_4K.png")))),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 9.0),
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Theme.of(context).primaryColor,
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
                    widget.post.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Text(widget.post.text),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      (widget.post.postedDate.year.toString() +
                          "." +
                          widget.post.postedDate.month.toString() +
                          "." +
                          widget.post.postedDate.day.toString()),
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
  String imageUrl;
  String text;
  DateTime postedDate;
  String name;
  int likesCount;

  PostDto(
      this.postedDate, this.name, this.likesCount, this.imageUrl, this.text);
}

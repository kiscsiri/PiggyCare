import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/helpers/pagination.helper.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/post/user.post.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/widgets/piggy.post.dart';
import 'package:piggybanx/services/user.social.post.service.dart';

class PiggySocial extends StatefulWidget {
  @override
  _PiggySocialState createState() => _PiggySocialState();
}

class _PiggySocialState extends State<PiggySocial> {
  bool isLoading = false;
  List<PostDto> items = List<PostDto>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future _likePost(String postId, int index) async {
    var store = StoreProvider.of<AppState>(context);
    var documentId = store.state.user.documentId;
    setState(() {
      var item = items.singleWhere(
          (element) => element.postId == postId && element.index == index);
      item.likedByUserIds.add(documentId);
      item.likesCount++;
    });
    await UserPostService.likePost(postId, documentId);
  }

  Future _dislikePost(String postId, index) async {
    var store = StoreProvider.of<AppState>(context);
    var documentId = store.state.user.documentId;
    setState(() {
      var item = items.singleWhere(
          (element) => element.postId == postId && element.index == index);
      item.likedByUserIds.removeWhere((element) => element == documentId);
      item.likesCount--;
    });
    await UserPostService.removeLikeFromPost(
        postId, store.state.user.documentId);
  }

  Future _loadData() async {
    int i = items.length;
    PaginationHelper paginationData;
    if (isLoading) {
      paginationData = PaginationHelper(items.length, 5, "postedDate",
          items.length != 0 ? items.last.postedDate : Timestamp.now());
    } else {
      setState(() {
        items.clear();
        paginationData =
            PaginationHelper(items.length, 5, "postedDate", Timestamp.now());
      });
    }

    var posts = (await UserPostService.getUserPosts(paginationData))
        .map((e) => UserPost.fromMap(e, e.documentID));

    var mappedPosts = await Future.wait(posts.map((e) async {
      var userSnapshot = await e.user.get();
      return PostDto(
          postId: e.id,
          index: i++,
          likedByUserIds: e.likedUserIds,
          text: e.text,
          likesCount: e.likes,
          documentSnapshot: e.documentSnapshot,
          user: UserData.fromFirebaseDocumentSnapshot(
              userSnapshot.data, e.user.documentID),
          postedDate: Timestamp.now());
    }).toList());
    setState(() {
      isLoading = false;
      if (items != null) {
        items.addAll(mappedPosts);
      }
    });
  }

  @override
  void initState() {
    var i = 0;
    (UserPostService.getUserPosts(PaginationHelper(items.length, 5,
            "postedDate", items.length != 0 ? items.last.postedDate : null)))
        .then((value) => value.map((e) => UserPost.fromMap(e, e.documentID)))
        .then((value) async {
      var mappedPosts = await Future.wait(value.map((e) async {
        var userSnapshot = await e.user.get();
        return PostDto(
            text: e.text,
            likedByUserIds: e.likedUserIds,
            postId: e.id,
            index: i++,
            likesCount: e.likes,
            documentSnapshot: userSnapshot,
            user: UserData.fromFirebaseDocumentSnapshot(
                userSnapshot.data, e.user.documentID),
            postedDate: e.postedDate);
      }));
      setState(() {
        isLoading = false;
        if (items != null) {
          items.addAll(mappedPosts);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return Column(children: [
      // Container(
      //   height: MediaQuery.of(context).size.height * 0.08,
      //   width: MediaQuery.of(context).size.width,
      //   color: Theme.of(context).primaryColor,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       TopNavigationBarItem(icon: Icons.home),
      //       TopNavigationBarItem(icon: Icons.image),
      //       TopNavigationBarItem(icon: Icons.videocam),
      //       TopNavigationBarItem(icon: Icons.chat_bubble)
      //     ],
      //   ),
      // ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (isLoading ? 0.7 : 0.8),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              setState(() {
                isLoading = true;
              });
              _loadData();
            }
          },
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => _loadData(),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var isSelected = items[index].likedByUserIds?.any(
                        (element) => element == store.state.user.documentId) ??
                    false;
                return PiggyPost(
                  likedByUser: isSelected,
                  onClick: (postId, index) => isSelected
                      ? _dislikePost(postId, index)
                      : _likePost(postId, index),
                  post: items[index],
                );
              },
            ),
          ),
        ),
      ),
      Container(
        height: isLoading ? 50.0 : 0,
        color: Colors.transparent,
        child: Center(
          child: new CircularProgressIndicator(),
        ),
      ),
    ]);
  }
}

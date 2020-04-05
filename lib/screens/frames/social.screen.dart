// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:piggycare/helpers/pagination.helper.dart';
// import 'package:piggycare/models/post/user.post.dart';
// import 'package:piggycare/models/user/user.export.dart';
// import 'package:piggycare/widgets/piggy.post.dart';
// import 'package:piggycare/widgets/top.navigation.item.dart';
// import 'package:piggycare/services/user.social.post.service.dart';

// class PiggySocial extends StatefulWidget {
//   @override
//   _PiggySocialState createState() => _PiggySocialState();
// }

// class _PiggySocialState extends State<PiggySocial> {
//   bool isLoading = false;
//   List<PostDto> items = List<PostDto>();

//   Future _loadData(ScrollNotification scrollInfo) async {
//     var posts = (await UserPostService.ge(PaginationHelper(
//             items.length,
//             5,
//             "postedDate",
//             items.length != 0 ? items.last.documentSnapshot : null)))
//         .map((e) => UserPost.fromMap(e));

//     var mappedPosts = await Future.wait(posts.map((e) async {
//       var userSnapshot = await e.user.get();
//       return PostDto(
//           text: e.text,
//           likesCount: e.likes,
//           documentSnapshot: userSnapshot,
//           user: UserData.fromFirebaseDocumentSnapshot(
//               userSnapshot.data, e.user.documentID),
//           postedDate: DateTime.now());
//     }).toList());
//     setState(() {
//       isLoading = false;
//       if (items != null) {
//         items.addAll(mappedPosts);
//       }
//     });
//   }

//   @override
//   void initState() {
//     (UserPostService.getUserPosts(PaginationHelper(
//             items.length,
//             5,
//             "postedDate",
//             items.length != 0 ? items.last.documentSnapshot : null)))
//         .then((value) => value.map((e) => UserPost.fromMap(e)))
//         .then((value) async {
//       var mappedPosts = await Future.wait(value.map((e) async {
//         var userSnapshot = await e.user.get();
//         return PostDto(
//             text: e.text,
//             likesCount: e.likes,
//             documentSnapshot: userSnapshot,
//             user: UserData.fromFirebaseDocumentSnapshot(
//                 userSnapshot.data, e.user.documentID),
//             postedDate: DateTime.now());
//       }));
//       setState(() {
//         isLoading = false;
//         if (items != null) {
//           items.addAll(mappedPosts);
//         }
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Container(
//         height: MediaQuery.of(context).size.height * 0.08,
//         width: MediaQuery.of(context).size.width,
//         color: Theme.of(context).primaryColor,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             TopNavigationBarItem(icon: Icons.home),
//             TopNavigationBarItem(icon: Icons.image),
//             TopNavigationBarItem(icon: Icons.videocam),
//             TopNavigationBarItem(icon: Icons.chat_bubble)
//           ],
//         ),
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.87,
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (ScrollNotification scrollInfo) {
//             if (!isLoading &&
//                 scrollInfo.metrics.pixels ==
//                     scrollInfo.metrics.maxScrollExtent) {
//               setState(() {
//                 isLoading = true;
//               });
//               _loadData(scrollInfo);
//             }
//           },
//           child: ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               return PiggyPost(post: items[index]);
//             },
//           ),
//         ),
//       ),
//       Container(
//         height: isLoading ? 50.0 : 0,
//         color: Colors.transparent,
//         child: Center(
//           child: new CircularProgressIndicator(),
//         ),
//       ),
//     ]);
//   }
// }

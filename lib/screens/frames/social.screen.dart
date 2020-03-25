import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piggybanx/widgets/piggy.post.dart';
import 'package:piggybanx/widgets/top.navigation.item.dart';

class PiggySocial extends StatefulWidget {
  @override
  _PiggySocialState createState() => _PiggySocialState();
}

class _PiggySocialState extends State<PiggySocial> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TopNavigationBarItem(icon: Icons.home),
            TopNavigationBarItem(icon: Icons.image),
            TopNavigationBarItem(icon: Icons.videocam),
            TopNavigationBarItem(icon: Icons.chat_bubble)
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ListView(
          children: <Widget>[
            PiggyPost(
                post: PostDto(
                    DateTime.now(),
                    "Szilágyi Ádám",
                    23,
                    "https://scontent-vie1-1.xx.fbcdn.net/v/t1.0-9/78481302_2754955497859238_5017358384047849472_o.jpg?_nc_cat=100&_nc_sid=09cbfe&_nc_oc=AQmF_DalJXrzl0K5jpRJ6ACZEOX4PXRFmYQXDSLmJl019RP3v0E887EQ8qFB_IFayHWwjy69MOgxywdKQELddtY5&_nc_ht=scontent-vie1-1.xx&oh=93e48ee85818052f0ae9237cfacc8c36&oe=5E9CA849",
                    "Új gyűjtésbe kezdett")),
            PiggyPost(
                post: PostDto(
                    DateTime.now(),
                    "Kovács János",
                    23,
                    "https://scontent-vie1-1.xx.fbcdn.net/v/t1.0-9/38085697_1768580729845318_3982390768881893376_o.jpg?_nc_cat=111&_nc_sid=174925&_nc_oc=AQmYaGILAf7VyLdNHIZV4W_U0sxpCOvVU7h5uZImZMxKeLguZvPqsAuMxD1MmmKCqPSq_RsaNZ7jq6t7256mDZzC&_nc_ht=scontent-vie1-1.xx&oh=f5c58518d99ae96d6074c52796060514&oe=5E9F4B21",
                    "Új gyűjtésbe kezdett")),
            PiggyPost(
                post: PostDto(
                    DateTime.now(),
                    "Szlivia Anikó",
                    23,
                    "https://scontent-vie1-1.xx.fbcdn.net/v/t1.0-9/60305684_10212968722632432_1650346487772610560_n.jpg?_nc_cat=107&_nc_sid=174925&_nc_oc=AQkPBQfz2OFzk-zKOUX9NAJJ3x7Sq3vCbtZ9PXZwjcBFqCFgGsE6JlC5DCkXyJchOPX2O0eRuzDNNODYWDd4PrdZ&_nc_ht=scontent-vie1-1.xx&oh=126b348eaf8bd5fed9d0be83b9261d5f&oe=5E9E1D5A",
                    "Új gyűjtésbe kezdett")),
            PiggyPost(
                post: PostDto(
                    DateTime.now(),
                    "Szabó Dániel",
                    23,
                    "https://scontent-vie1-1.xx.fbcdn.net/v/t1.0-9/83301146_2611808252383609_4906132663955357696_n.jpg?_nc_cat=109&_nc_sid=09cbfe&_nc_oc=AQmamz5lDKGG4u4IaKMN6xSD1CC4LOHGA1iiIcR5tKcbkTzkHKCvPHpjdtJH_w07QqSfvrRddmfjO2uRA4cF8LMA&_nc_ht=scontent-vie1-1.xx&oh=53be35ebe3631a5d4a20aeeec13c48e8&oe=5E9FFA7F",
                    "Új gyűjtésbe kezdett")),
            PiggyPost(
                post: PostDto(
                    DateTime.now(),
                    "Vesztergom Balázs",
                    23,
                    "https://scontent-vie1-1.xx.fbcdn.net/v/t31.0-8/13925851_10154366275081462_6082813286334876832_o.jpg?_nc_cat=109&_nc_sid=09cbfe&_nc_oc=AQlqHrtUWjVYSU86VTU6MkyE_WeqM9XH85Kg0qf6ukKNM6vjGgw7POWEtn4cyYy0JxN9i30zPK_pjp7OKWm3ULn3&_nc_ht=scontent-vie1-1.xx&oh=a385c9171cbbe3a3b985a05ff65f5c54&oe=5E9FBA20",
                    "Új gyűjtésbe kezdett"))
          ],
        ),
      )
    ]);
  }
}

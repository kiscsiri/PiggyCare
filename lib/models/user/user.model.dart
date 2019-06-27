import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/Enums/period.dart';

class UserData {
  String id;
  int saving;
  Period period;
  int feedPerPeriod;
  String item;
  int targetPrice;
  PiggyLevel piggyLevel;
  int currentSaving;
  int currentFeedTime;
  String phoneNumber;
  DateTime lastFeed;
  DateTime created;
  double money;

  Duration get timeUntilNextFeed {
    if (this.lastFeed == null) {
      return Duration(days: -1);
    }
    switch (period) {
      case Period.daily:
        return DateTime.now().difference(lastFeed.add(Duration(days: 1)));
        break;
      case Period.monthly:
        return DateTime.now().difference(lastFeed.add(Duration(days: 30)));
        break;
      case Period.weely:
        return DateTime.now().difference(lastFeed.add(Duration(days: 7)));
        break;
      case Period.demo:
        return DateTime.now().difference(lastFeed.add(Duration(days: -7)));
        break;
      default:
        return Duration(seconds: 1);
        break;
    }
  }

  factory UserData.fromFirebaseUser(FirebaseUser user) {
    return UserData(id: user.uid);
  }

  factory UserData.fromFirebaseDocumentSnapshot(DocumentSnapshot user) {
    return new UserData(
        id: user['uid'],
        phoneNumber: user['phoneNumber'],
        feedPerPeriod: user['feedPerPeriod'],
        lastFeed: user['lastFeed'].toDate(),
        item: user['item'],
        targetPrice: user['targetPrice'],
        money: user['money'],
        currentSaving: user['currentSaving'],
        piggyLevel: PiggyLevel.values[user['piggyLevel'] - 1],
        currentFeedTime: user['currentFeedTime'],
        created: user['created'].toDate(),
        saving: user['saving'],
        period: Period.values[user['period']]);
  }

  factory UserData.constructInitial(id, phoneNumber) {
    return new UserData(
            id: id,
            phoneNumber: phoneNumber,
            feedPerPeriod: 5,
            lastFeed: DateTime(1995),
            money: 100000,
            currentFeedTime: 0,
            currentSaving: 0,
            piggyLevel: PiggyLevel.Baby,
            created: DateTime.now(),
            saving: 0,
            period: Period.daily
    );
  }

  Map<String, dynamic> toJson() {
    return new Map.from({
      "uid": this.id,
      "saving": this.saving,
      "feedPerPeriod": this.feedPerPeriod,
      "phoneNumber": this.phoneNumber,
      "item": this.item,
      "targetPrice": this.targetPrice,
      "money": this.money,
      "period": this.period.index,
      "lastFeed": this.lastFeed,
      "created": this.created,
      "currentSaving": this.currentSaving,
      "piggyLevel" : this.piggyLevel,
      "currentFeedTime": this.currentFeedTime
    });
  }

  UserData(
      {this.id,
      this.saving,
      this.feedPerPeriod,
      this.period,
      this.item,
      this.targetPrice,
      this.currentSaving,
      this.piggyLevel,
      this.currentFeedTime,
      this.money,
      this.lastFeed,
      this.phoneNumber,
      this.created});

}

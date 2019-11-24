import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/registration/registration.model.dart';

class UserData {
  String id;
  int saving;
  UserType
      userType; // itt ez lehet nem kell, hanem az objektum típusára szűrűnk majd
  Period period;
  int feedPerPeriod;
  List<Item> items;
  PiggyLevel piggyLevel;
  int currentFeedTime;
  String phoneNumber;
  DateTime lastFeed;
  DateTime created;
  double money;
  bool isDemoOver;

  Duration get timeUntilNextFeed {
    if (this.lastFeed == null) {
      return Duration(days: -1);
    }
    switch (period) {
      case Period.daily:
        return DateTime.now().difference(lastFeed.add(Duration(hours: 12)));
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

  UserData.fromUserData(UserData another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    lastFeed = another.lastFeed;
    items = another.items;
    money = another.money;
    currentFeedTime = another.currentFeedTime;
    piggyLevel = another.piggyLevel;
    period = another.period;
    phoneNumber = another.phoneNumber;
    saving = another.saving;
    isDemoOver = another.isDemoOver;
    created = another.created;
  }

  factory UserData.fromFirebaseDocumentSnapshot(DocumentSnapshot user) {
    return new UserData(
        id: user['uid'],
        userType: user['userType'],
        phoneNumber: user['phoneNumber'],
        feedPerPeriod: user['feedPerPeriod'],
        lastFeed: user['lastFeed'].toDate(),
        money: user['money'],
        piggyLevel: PiggyLevel.values[user['piggyLevel']],
        currentFeedTime: user['currentFeedTime'],
        created: user['created'].toDate(),
        saving: user['saving'],
        isDemoOver: user['isDemoOver'],
        period: Period.values[user['period']]);
  }

  factory UserData.fromMap(Map user) {
    return new UserData(
        id: user['uid'],
        userType: user['userType'],
        phoneNumber: user['phoneNumber'],
        feedPerPeriod: user['feedPerPeriod'],
        lastFeed: user['lastFeed'].toDate(),
        money: user['money'],
        piggyLevel: PiggyLevel.values[user['piggyLevel']],
        currentFeedTime: user['currentFeedTime'],
        created: user['created'].toDate(),
        saving: user['saving'],
        isDemoOver: user['isDemoOver'],
        period: Period.values[user['period']]);
  }

  factory UserData.constructInitial(
      id, phoneNumber, RegistrationData register) {
    return new UserData(
        id: id,
        userType: register.userType,
        phoneNumber: phoneNumber,
        feedPerPeriod: register.schedule.savingPerPeriod,
        lastFeed: DateTime(1995),
        money: 100000,
        currentFeedTime: 0,
        items: [
          Item(
              currentSaving: 0,
              item: register.item,
              targetPrice: register.targetPrice)
        ],
        piggyLevel: PiggyLevel.Baby,
        created: DateTime.now(),
        saving: 0,
        isDemoOver: false,
        period: register.schedule.period);
  }

  Map<String, dynamic> toJson() {
    return new Map.from({
      "uid": this.id,
      "saving": this.saving,
      "userType": this.userType,
      "feedPerPeriod": this.feedPerPeriod,
      "phoneNumber": this.phoneNumber,
      "money": this.money,
      "period": this.period.index,
      "lastFeed": this.lastFeed,
      "created": this.created,
      "isDemoOver": this.isDemoOver,
      "userType": this.userType.index,
      "piggyLevel": this.piggyLevel.index,
      "currentFeedTime": this.currentFeedTime
    });
  }

  UserData(
      {this.id,
      this.saving,
      this.userType,
      this.feedPerPeriod,
      this.period,
      this.items,
      this.piggyLevel,
      this.currentFeedTime,
      this.money,
      this.lastFeed,
      this.isDemoOver,
      this.phoneNumber,
      this.created});
}

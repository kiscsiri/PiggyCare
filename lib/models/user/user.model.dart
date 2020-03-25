import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable(nullable: false)
class UserData {
  String id;
  String documentId;
  int saving;
  UserType userType = UserType.individual;
  Period period;
  int feedPerPeriod;
  PiggyLevel piggyLevel;
  int currentFeedTime;
  String phoneNumber;
  DateTime lastFeed;
  DateTime created;
  double money;
  bool isDemoOver;
  int numberOfCoins;
  String email;
  String name;
  String pictureUrl;
  String parentId;
  bool wantToSeeInfoAgain;
  List<Piggy> piggies;
  List<Chore> chores;
  List<UserData> children;

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

  bool get hasAnyCoinsLeft {
    return numberOfCoins > 0 || timeUntilNextFeed < Duration(days: 0);
  }

  factory UserData.fromJson(Map<String, dynamic> json, String documentId) =>
      _$UserDataFromJson(json, documentId);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromFirebaseUser(FirebaseUser user) {
    return UserData(id: user.uid);
  }

  UserData.fromUserData(UserData another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    documentId = another.documentId;
    lastFeed = another.lastFeed;
    money = another.money;
    userType = another.userType;
    currentFeedTime = another.currentFeedTime;
    piggyLevel = another.piggyLevel;
    period = another.period;
    numberOfCoins = another.numberOfCoins;
    phoneNumber = another.phoneNumber;
    saving = another.saving;
    isDemoOver = another.isDemoOver;
    created = another.created;
    wantToSeeInfoAgain = another.wantToSeeInfoAgain;
    pictureUrl = another.pictureUrl;
    email = another.email;
    name = another.name;
    parentId = another.parentId;
    chores = another.chores;
    piggies = another.piggies;
    children = another.children;
  }

  factory UserData.fromFirebaseDocumentSnapshot(
          Map<String, dynamic> user, String documentId) =>
      _$UserDataFromJson(user, documentId);

  factory UserData.fromMap(Map user, String documentId) =>
      _$UserDataFromJson(user, documentId);

  factory UserData.constructInitial(RegistrationData register) {
    return new UserData(
        id: register.uid,
        userType: register.userType,
        phoneNumber: "phoneNumber",
        feedPerPeriod:
            (register.schedule != null) ? register.schedule.savingPerPeriod : 1,
        lastFeed: DateTime(1995),
        money: 100000,
        currentFeedTime: 0,
        piggies: [
          if (register.schedule != null)
            Piggy(
                piggyLevel: PiggyLevel.Child,
                doubleUp: false,
                isFeedAvailable: false,
                money: 0,
                userId: register.uid,
                currentSaving: 0,
                item: register.item,
                targetPrice: register.targetPrice)
        ],
        piggyLevel: PiggyLevel.Baby,
        created: DateTime.now(),
        saving: 0,
        wantToSeeInfoAgain: false,
        numberOfCoins: 0,
        email: register.email,
        name: register.username,
        pictureUrl: register.pictureUrl,
        isDemoOver: false,
        period: (register.schedule != null)
            ? register.schedule.period
            : Period.daily);
  }

  UserData(
      {this.id,
      this.documentId,
      this.saving,
      this.userType = UserType.individual,
      this.feedPerPeriod,
      this.period = Period.daily,
      List<Piggy> piggies,
      List<Chore> chores,
      List<UserData> children,
      this.piggyLevel,
      this.currentFeedTime,
      this.money,
      this.numberOfCoins,
      this.lastFeed,
      this.parentId,
      this.isDemoOver,
      this.phoneNumber,
      this.wantToSeeInfoAgain = true,
      this.created,
      this.email,
      this.name,
      this.pictureUrl})
      : piggies = piggies ?? List<Piggy>(),
        children = children ?? List<UserData>(),
        chores = chores ?? List<Chore>();
}

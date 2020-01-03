import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable(nullable: false)
class UserData {
  String id;
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
  String email;
  String name;
  String pictureUrl;
  List<Piggy> piggies;

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

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromFirebaseUser(FirebaseUser user) {
    return UserData(id: user.uid);
  }

  UserData.fromUserData(UserData another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    lastFeed = another.lastFeed;
    money = another.money;
    userType = another.userType;
    currentFeedTime = another.currentFeedTime;
    piggyLevel = another.piggyLevel;
    period = another.period;
    phoneNumber = another.phoneNumber;
    saving = another.saving;
    isDemoOver = another.isDemoOver;
    created = another.created;
    pictureUrl = another.pictureUrl;
    email = another.email;
    name = another.name;
    piggies = another.piggies;
  }

  factory UserData.fromFirebaseDocumentSnapshot(Map<String, dynamic> user) =>
      _$UserDataFromJson(user);

  factory UserData.fromMap(Map user) => _$UserDataFromJson(user);

  factory UserData.constructInitial(RegistrationData register) {
    return new UserData(
        id: register.uid,
        userType: register.userType,
        phoneNumber: "phoneNumber",
        feedPerPeriod:
            (register.schedule != null) ? register.schedule.savingPerPeriod : 2,
        lastFeed: DateTime(1995),
        money: 100000,
        currentFeedTime: 0,
        piggies: [
          if (register.schedule != null)
            Piggy(
                piggyLevel: PiggyLevel.Child,
                currentFeedAmount: 2,
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
      this.saving,
      this.userType = UserType.individual,
      this.feedPerPeriod,
      this.period = Period.daily,
      List<Piggy> piggies,
      this.piggyLevel,
      this.currentFeedTime,
      this.money,
      this.lastFeed,
      this.isDemoOver,
      this.phoneNumber,
      this.created,
      this.email,
      this.name,
      this.pictureUrl})
      : piggies = piggies ?? List<Piggy>();
}

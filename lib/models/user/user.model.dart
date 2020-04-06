import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggycare/Enums/userType.dart';
import 'package:piggycare/enums/level.dart';
import 'package:piggycare/enums/period.dart';
import 'package:piggycare/models/chore/chore.export.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';
import 'package:piggycare/models/registration/registration.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable(nullable: false)
class UserData {
  String id;
  String documentId;
  int saving;
  UserType userType = UserType.donator;
  Period period;
  int feedPerPeriod;
  PiggyLevel piggyLevel;
  int currentFeedTime;
  DateTime lastFeed;
  DateTime created;
  double money;
  String email;
  String name;
  String pictureUrl;
  String companyName;
  String taxNumber;
  double companyLocationLong;
  double companyLocationLat;

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
    saving = another.saving;
    created = another.created;
    pictureUrl = another.pictureUrl;
    email = another.email;
    name = another.name;
    piggies = another.piggies;
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
        email: register.email,
        name: register.username,
        pictureUrl: register.pictureUrl,
        period: (register.schedule != null)
            ? register.schedule.period
            : Period.daily);
  }

  UserData(
      {this.id,
      this.documentId,
      this.saving,
      this.userType = UserType.donator,
      this.feedPerPeriod,
      this.period = Period.daily,
      List<Piggy> piggies,
      List<Chore> chores,
      List<UserData> children,
      this.piggyLevel,
      this.currentFeedTime,
      this.money,
      this.lastFeed,
      this.created,
      this.email,
      this.name,
      this.pictureUrl})
      : piggies = piggies ?? List<Piggy>();
}

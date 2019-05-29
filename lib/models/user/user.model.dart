import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/Enums/period.dart';

class UserData {
  String id;
  double saving;
  Period period;
  int feedPerPeriod;
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

  Map<String, dynamic> toJson() {
    return new Map.from({
      "uid": this.id,
      "saving": this.saving,
      "feedPerPeriod": this.feedPerPeriod,
      "phoneNumber": this.phoneNumber,
      "money": this.money,
      "period": this.period.index,
      "lastFeed": this.lastFeed,
      "created": this.created
    });
  }

  UserData(
      {this.id,
      this.saving,
      this.feedPerPeriod,
      this.period,
      this.money,
      this.lastFeed,
      this.phoneNumber,
      this.created});
}

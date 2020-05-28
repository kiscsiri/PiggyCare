import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  static Future logLogout() async {
    await _analytics.logLogin(loginMethod: 'logout');
  }

  static Future logLoginEmail() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  static Future logLoginoAuth() async {
    await _analytics.logLogin(loginMethod: 'oauth');
  }

  static Future logSignUpOAuth() async {
    await _analytics.logSignUp(signUpMethod: 'oauth');
  }

  static Future logSignUpEmail() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  static Future logPiggyCreated() async {
    try {
      await _analytics.logEvent(
        name: 'piggy_created',
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future logTaszkCreated() async {
    await _analytics.logEvent(
      name: 'taszk_created',
    );
  }

  static Future logTaskCompleted() async {
    await _analytics.logEvent(
      name: 'taszk_created',
    );
  }

  static Future logPostCreated() async {
    await _analytics.logEvent(
      name: 'post_created',
    );
  }

  static Future logDislike() async {
    await _analytics.logEvent(
      name: 'dislike_post',
    );
  }

  static Future logPostLiked() async {
    await _analytics.logEvent(
      name: 'like_post',
    );
  }

  static Future logFeed() async {
    await _analytics.logEvent(
      name: 'feed_happened',
    );
  }
}

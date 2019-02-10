//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <cloud_firestore/CloudFirestorePlugin.h>
#import <firebase_auth/FirebaseAuthPlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>
#import <firebase_messaging/FirebaseMessagingPlugin.h>
#import <flutter_webview_plugin/FlutterWebviewPlugin.h>
#import <flutter_youtube/FlutterYoutubePlugin.h>
#import <google_sign_in/GoogleSignInPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseMessagingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];
  [FlutterWebviewPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterWebviewPlugin"]];
  [FlutterYoutubePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterYoutubePlugin"]];
  [FLTGoogleSignInPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleSignInPlugin"]];
}

@end

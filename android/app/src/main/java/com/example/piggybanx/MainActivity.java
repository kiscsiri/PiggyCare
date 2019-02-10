package com.example.piggybanx;

import android.os.Bundle;

import com.google.firebase.FirebaseApp;
import com.google.firebase.firestore.FirebaseFirestore;

import javax.xml.transform.Result;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.example.piggybanx/firestore";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}

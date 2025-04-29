import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }

  static const FirebaseOptions android = FirebaseOptions
    (apiKey: "AIzaSyAbMn_yagwGaP6sIW-bwF5_VLbYl-sJyNQ",
      appId: "1:26449328744:android:f2904576e9df24efb0d9dd",
      messagingSenderId: "26449328744",
      storageBucket: "meetup-a53a9.firebasestorage.app",
      projectId: "meetup-a53a9");

  static const FirebaseOptions ios = FirebaseOptions
    (
    apiKey: "AIzaSyBuwW5GubntMwxyS7F5aBxMbFXRnEMUMAg",
    appId: "1:26449328744:ios:b93d1c6aba32fbcfb0d9dd",
    messagingSenderId: "26449328744",
    storageBucket: "meetup-a53a9.firebasestorage.app",
    iosBundleId: "com.app.meetUp",
    projectId: "meetup-a53a9",);
}

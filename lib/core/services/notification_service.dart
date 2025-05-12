import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService().setupFlutterNotifications();
  await NotificationService().showNotification(message);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Get FCM token
    final token = await _messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (kDebugMode) {
      print('Permission status: ${settings.authorizationStatus}');
    }
  }

  Future<void> setupFlutterNotifications() async {
    // android setup
    const channel = AndroidNotificationChannel(
      'mera_bazaar_offers',
      'Offers',
      description: 'This channel is used for offers notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // ios setup
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mera_bazaar_offers',
            'Offers',
            channelDescription:
                'This channel is used for offers notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a background message: ${message.data}');
    }
  }

  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
    String userFcmToken,
    String msg,
    String name,
  ) async {
    try {
      final body = {
        // 'to': userFcmToken,
        // 'notification': {'title': 'Test Notification', 'body': msg},
        "message": {
          "token": userFcmToken,
          "notification": {"title": name, "body": msg},
        },
      };


      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'meetup-a53a9';

      // get firebase admin token
      final bearerToken = await _getAccessToken();

      // handle null token
      if (bearerToken == null) return;

      var response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Notification sent successfully!');
        }
      } else {
        if (kDebugMode) {
          print(
            '❌ Failed to send notification: ${response.statusCode} ${response.body}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error sending push notification: $e');
      }
    }
  }

  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "meetup-a53a9",
          "private_key_id": "67b03ebd128ea8314e95decf117c0f3a8f692b6a",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXaXfHtKGmJxkm\ncrqx21FlxeWBIRtw3YEEF+LCdjtAfQVjQG5btSAx7mYKGuZ6B9N8CUbFDrfnOVa5\nHl10Eo9EVKakQnf4iuCkQkLhaIBHqhN0K+Hr/xu+Im7kD5xBHfToUcxCm1bwJDW9\njbeP3SYWy7pmfbxozbIsXsvKvIwvX+G8Ncx6XZgRb2Yz1WIVTW1xE1U66D3ojAeY\nXAsqNN8uBNcEy0IFMQiGYJK6/8Qt4tQkAq0f8PG2PSmVWyN+yaFbX+frDcoigg6f\nWIYBSHEPtKKaPAH9pdsZlJCVKONo8bdDs5aIyRlz/jxZESy6Tbtrtry//8ZxK2Tp\n0po5FGnjAgMBAAECggEACCEUkQv4LY/l+W0gfjjO4VV1n13dLoRU2HRYIlOvcW23\nO9YqP9GHV+k7ctdMwKzzCOm8BHl6d8mQh+sngufxDDgQthaPN7CRI8dn0bQ0tBso\nm8yh7IYiXRwMl68Jco+Q+GYxB/Isb4yqJR/azhPq5xrY7xkP0chjKTGyCO9NmFrm\nTCZxEYSY97xIVGAVXTWb7K0orwE6HjcQKiQ2WNxdA6K+Q9K6pqfMgRa8hhWatQPj\nQ5lcsOjiDRPbeM58gpJOpgEoP/VajV+wiaKGWiQtTIDl/gxSJB/A9seiyJrw2bcY\nhHMQW9aERS8FiTlcOrY0RjJQ4FbvYkeEsZ7rY5WA1QKBgQDG+mF8Zuri1BhJ6gg6\ngLpvGf/CxIP0B2Pf23AxF/kNXrui8K6jm5PchpN+rhQgE3WnIqWNyp1Q5uW4Ji3K\nqykrnrS4XnG7ai3Xs9e1LAkHMPY6CY14W/xa50bsuRJ7P8Dy54xhsBTw5hMaw1hZ\nFm+2NsdMO8olQNNs/3rdxhyntwKBgQDCzX/j7ESFD870Xtl+xZuoQUkNYY3JXIgQ\n3hX9B7CLNgy5mbzelgDoZZwfE1bwajTHzw9Taq90FCNuCguKG+bXAktJPofIsoBX\nhZrU+SEq0yqh3nswlT6DSpX9mfkVonZB5rRdn2MF7dXlieQlQDEuQiZBXr0WyD+O\nRmKzYA3XNQKBgQC2kV2JK1UxMrHmf9l09FAbSJunNXBtI6q75zgVk41sexNm+bcD\nXuhYWxJSFZ9ZnwFAjUWhx9p4NKNqR32Ui1+HKmNfFyj7cP0HAXhWP0U5V+9UaRdo\n692r+rDU2yrd8y0yssnXiBxuvGujDsGtXCy7358Vj3Z2n/hd9jvh6Li6GQKBgQCX\n6GyMrlgYc2VthvGQPETQBmkTODm7Bp9MmAMJmA+B35o4ubxgzxTSJTqDuS8Yt5mF\nHuDSqeU8Xd/rFYY+Itf2XuGaslpslVYj6hn9bnEA1j7uj3H9RsTC2UzxwDpPNquF\nZITOZVZw7zDXmJoCunYfnpH6dAh8VZfKOPUK8CKa6QKBgBCAthRIKoiWkBUky/Pg\n8ei7FuDuK/TJlbV0XbxNH1tefeWH1XbQ8T1nZj6pSx8ajuc5JE23JaSQHRBPdsLA\no2+mbYMFKC60Mg8DNJ8hSQoOty91ZzT24OYfYuixSK3yVqpK1ZEOqO9GGn1PxMbD\nfv6rw0ewCo9xHM/h1YsKP7tU\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@meetup-a53a9.iam.gserviceaccount.com",
          "client_id": "116586137829172876505",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40meetup-a53a9.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com",
        }),
        [fMessagingScope],
      );

      return client.credentials.accessToken.data;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return null;
    }
  }
}

//5A:4B:08:34:1D:E1:55:B8:89:71:23:CF:51:DF:C4:4E:7F:EF:DC:51

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController<String>.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static disposed() {
    _messageStream.close();
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No Title');
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No Title');
  }

  static Future<void> _onMessageOpenedAppHandler(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No Title');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    /**
     * Handlers
     */
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  }
}

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationsService {
  void sendPushMessage(String token, String body, String title, unreadMsgCount,
      image, chatRoomId) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAq6Hb1PY:APA91bG_txnLhVvQqrEqaLYXgxWEzUW4CWuZWG_SyyNcWZWzsCRJCwVBn7xhCxbIP8Zm62Q-vfZOLuBe7S-i9iSNuDpdphZIuwelc5sW7SIT-BubVF2L9S18k3C7m3skv4FDsXDpzGxU'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'chatroomid': chatRoomId
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "wbrs",
              'badge': unreadMsgCount,
              'sound': "default",
              'image': image
            },
            "to": token
          }));
    } catch (e) {
      print(e);
    }
  }
}

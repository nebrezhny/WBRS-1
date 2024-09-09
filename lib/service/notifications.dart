// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationsService {
  void sendPushMessage(
      String token, Map body, String title, unreadMsgCount, chatRoomId) async {
    print(1);
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
              'chatId': chatRoomId,
              'isChat': body['isChat'],
              'chatWith': body['chatWith'],
              'photoUrl': body['photoUrl'],
              'id': body['id'],
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body['message'],
              "android_channel_id": "wbrs",
              'badge': unreadMsgCount,
              'sound': "default",
            },
            "to": token
          }));
    } catch (e) {
      print(e);
    }
  }

  void sendPushMessageGroup(
      String token, Map body, String title, unreadMsgCount, groupRoomId) async {
    print(1);
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
              'groupId': groupRoomId,
              'isChat': body['isChat'],
              'groupName': body['groupName'],
              'users': body['users'],
              'isUserJoin': body['isUserJoin'],
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body['message'],
              "android_channel_id": "wbrs",
              'badge': unreadMsgCount,
              'sound': "default",
            },
            "to": token
          }));
    } catch (e) {}
  }
}

// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import "package:flutter/services.dart" as s;

class NotificationsService {
  void sendPushMessage(
      String token, Map body, String title, unreadMsgCount, chatRoomId) async {
    try {
      var resp = await getAccessToken();
      var res = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/chatapp-4e347/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $resp'
          },
          body: jsonEncode(<String, dynamic>{
            'message': <String, dynamic>{
              'token': token,
              //'key = AAAAq6Hb1PY:APA91bG_txnLhVvQqrEqaLYXgxWEzUW4CWuZWG_SyyNcWZWzsCRJCwVBn7xhCxbIP8Zm62Q-vfZOLuBe7S-i9iSNuDpdphZIuwelc5sW7SIT-BubVF2L9S18k3C7m3skv4FDsXDpzGxU',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'chatId': chatRoomId,
                'chatWith': body['chatWith'],
                'photoUrl': body['photoUrl'],
                'id': body['id'],
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body['message'],
                //"android_channel_id": "wbrs",
                //'badge': unreadMsgCount,
                //'sound': "default",
              },
            }
          }));

      if (res.statusCode == 200) {
        print('Уведомление успешно отправлено');
      } else {
        print('Ошибка при отправке уведомления: ${res.statusCode}');
        print(res.body);
      }
    } catch (e) {
      print(e);
    }
  }

  void sendPushMessageGroup(
      String token, Map body, String title, unreadMsgCount, groupRoomId) async {
    try {
      var resp = await getAccessToken();
      var res = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/chatapp-4e347/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $resp'
          },
          body: jsonEncode(<String, dynamic>{
            'message': <String, dynamic>{
              'token': token,
              //'key = AAAAq6Hb1PY:APA91bG_txnLhVvQqrEqaLYXgxWEzUW4CWuZWG_SyyNcWZWzsCRJCwVBn7xhCxbIP8Zm62Q-vfZOLuBe7S-i9iSNuDpdphZIuwelc5sW7SIT-BubVF2L9S18k3C7m3skv4FDsXDpzGxU',
              // 'data': <String, dynamic>{
              //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              //   'status': 'done',
              //   'body': body,
              //   'title': title,
              //   'groupId': groupRoomId,
              //   'groupName': body['groupName'],
              //   'users': body['users'],
              //   'isUserJoin': body['isUserJoin'],
              // },
              "notification": <String, dynamic>{
                "title": title,
                "body": body['message'],
                //"android_channel_id": "wbrs",
                //'badge': unreadMsgCount,
                //'sound': "default",
              },
            }
          }));
      if (res.statusCode == 200) {
        print('Уведомление успешно отправлено');
      } else {
        print('Ошибка при отправке уведомления: ${res.statusCode}');
        print(res.body);
      }
    } catch (e) {}
  }
}

const List<String> _scopes = [
  'https://www.googleapis.com/auth/firebase.messaging',
];

Future getAccessToken() async {
  final serviceAccountJson =
      json.decode(await s.rootBundle.loadString("assets/credentials.json"));
  final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
  final client = await clientViaServiceAccount(credentials, _scopes);

  return client.credentials.accessToken.data;
}

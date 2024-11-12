// ignore_for_file: use_build_context_synchronously, unnecessary_string_escapes

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/pages/about_meet.dart';
import 'package:wbrs/app/pages/chatscreen.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/app/widgets/chat_room_list.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wbrs/app/widgets/widgets.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  Stream? chatRoomsStream;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getChatRooms() async {
    chatRoomsStream = await DatabaseService().getChatRooms();
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    initInfo();
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'online': true});
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'lastOnlineTS': DateTime.now()});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initInfo() {
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('wbrs', 'wbrs',
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: true);

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);

      try {
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,
            platformChannelSpecifics,
            payload: message.notification!.body);
      } on Exception catch (e) {
        showSnackbar(context, Colors.red, e);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map body = jsonDecode(message.data['payload']);
      if (body['isChat'] == true) {
        nextScreenReplace(
            context,
            ChatScreen(
              chatWithUsername: body['chatWith'],
              photoUrl: body['photoUrl'],
              id: body['id'],
              chatId: body['chatId'],
            ));
      } else {
        body['users'] =
            body['users'].toString().replaceAll('[', '').replaceAll(']', '');
        List users = body['users'].toString().split(',');
        nextScreenReplace(
            context,
            AboutMeet(
              id: body['groupId'],
              users: users,
              name: body['groupName'],
              is_user_join: body['isUserJoin'].toString() == 'true',
            ));
      }
    });
  }

  void saveUserToken(String token) {
    firebaseFirestore
        .collection('TOKENS')
        .doc(firebaseAuth.currentUser?.uid)
        .set({'token': token});
  }

  void requestPermission() async {
    try {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
      } else {}
    } on Exception catch (e) {
      showSnackbar(context, Colors.red, e);
      firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'token': e});
    }
  }

  String? mtoken;
  void getToken() async {
    await firebaseMessaging.getToken().then((token) {
      mtoken = token;
    });

    saveUserToken(mtoken!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            bottomNavigationBar: const MyBottomNavigationBar(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: const Text(
                "Чаты",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
            ),
            drawer: const MyDrawer(),
            body: SizedBox(
              height: 10000,
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('chats')
                      .where(Filter.or(
                        Filter('user1',
                            isEqualTo: firebaseAuth.currentUser!.uid),
                        Filter('user2',
                            isEqualTo: firebaseAuth.currentUser!.uid),
                      ))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (!snapshot.hasData) {
                        return const Text(
                          "Нет чатов",
                          textAlign: TextAlign.center,
                        );
                      } else {
                        List sortedList = snapshot.data!.docs;
                        sortedList.sort((a, b) {
                          return b
                              .get('lastMessageSendTs')
                              .compareTo(a.get('lastMessageSendTs'));
                        });
                        if (firebaseAuth.currentUser != null) {
                          return ListView.builder(
                              itemCount: sortedList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15),
                                  child:
                                      SizedBox(
                                          height: 100,
                                          child: ChatRoomList(snapshot: sortedList[index])),
                                );
                              });
                        } else {
                          return const Text('none');
                        }
                      }
                    }
                  }),
            )),
      ],
    );
  }
}

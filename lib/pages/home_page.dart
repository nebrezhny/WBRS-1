// ignore_for_file: unnecessary_string_escapes, non_constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/helper/helper_function.dart';
import 'package:messenger/pages/chatscreen.dart';
import 'package:messenger/pages/profiles_list.dart';
import 'package:messenger/service/auth_service.dart';
import 'package:messenger/service/database_service.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/widgets/widgets.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? chats;
  String id = "";
  String photoUrl = "";

  var currentUser;

  bool isSearching = false;
  Stream? usersStream, chatRoomsStream;
  late String myName, myProfilePic, myUserName, myEmail;
  TextEditingController searchUsernameEditingController =
      TextEditingController();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getMyInfoFromSharedPreference() async {
    myName = HelperFunctions().getDisplayName().toString();
    myProfilePic = HelperFunctions().getUserProfileUrl().toString();
    myUserName = HelperFunctions().getUserName().toString();
    myEmail = HelperFunctions().getUserEmail().toString();
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseService().getChatRooms();
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseService()
        .getUserByUserName(searchUsernameEditingController.text);

    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  chatRoomsList(
      AsyncSnapshot<QuerySnapshot> snapshot, String MyUID, String MyNickname) {
    List chats = [];

    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      if (snapshot.data!.docs[i].get("user1") == MyUID ||
          snapshot.data!.docs[i].get("user2") == MyUID) {
        chats.add(snapshot.data!.docs[i]);
      }
    }
    String nick;

    if (chats.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              subtitle: chats[index]["lastMessage"] != ""
                  ? Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${chats[index]["lastMessageSendByID"] == MyUID ? "Вы" : chats[index]["lastMessageSendBy"]}: ${chats[index].get("lastMessage")}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          chats[index]["lastMessageSendByID"] != MyUID
                              ? chats[index]['unreadMessage'] != null
                                  ? chats[index]['unreadMessage'] != 0
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 10,
                                          child: Text(
                                            chats[index]['unreadMessage']
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: 'Roboto'),
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox()
                              : const SizedBox(),
                        ],
                      ),
                    )
                  : const Text(
                      "нет сообщений",
                      style: TextStyle(color: Colors.white),
                    ),
              title: chats[index].get("user1") == MyUID
                  ? Text(
                      chats[index].get("user2Nickname"),
                      style: const TextStyle(color: Colors.white),
                    )
                  : Text(
                      chats[index].get("user1Nickname"),
                      style: const TextStyle(color: Colors.white),
                    ),
              onTap: () async {
                if (chats[index].get("user1") == MyUID) {
                  nick = chats[index].get("user2Nickname");
                  id = chats[index]['user2'];

                  photoUrl = chats[index]['user2_image'];
                } else {
                  nick = chats[index].get("user1Nickname");
                  id = chats[index]['user1'];
                  photoUrl = chats[index]['user1_image'];
                }

                setState(() {
                  nextScreen(
                      context,
                      ChatScreen(
                          chatWithUsername: nick,
                          name: MyNickname,
                          photoUrl: photoUrl,
                          id: id,
                          chatId: chats[index].id));
                });
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: chats[index].get("user1") == MyUID
                    ? chats[index].get("user2_image") != ""
                        ? Image.network(
                            chats[index].get("user2_image"),
                            width: 60,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.person, size: 40))
                    : chats[index].get("user1_image") != ""
                        ? Image.network(
                            chats[index].get("user1_image"),
                            width: 60,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.person, size: 40)),
              ),
              tileColor: Colors.white24,
              contentPadding: const EdgeInsets.all(10.0),
            ),
          );
        },
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height - 160,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text(
                  'Нет чатов. ',
                  style: TextStyle(color: Colors.white),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () async {
                      selectedIndex = 2;
                      var x = await getUserGroup();
                      nextScreen(
                          context,
                          ProfilesList(
                            group: x,
                          ));
                    },
                    child: const Text(
                      'Начать общаться',
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        chats = snapshot;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    currentUser = FirebaseAuth.instance.currentUser;

    initInfo();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } on Exception catch (e) {
        e.hashCode;
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('wbrs', 'wbrs', 'wbrs',
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: false);

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  void saveUserToken(String token) {
    FirebaseFirestore.instance
        .collection('TOKENS')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'token': token});
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
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
  }

  String? mtoken;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
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
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy('lastMessage')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "Нет чатов",
                        textAlign: TextAlign.center,
                      );
                    } else {
                      if (currentUser != null) {
                        return chatRoomsList(
                            snapshot, currentUser.uid, currentUser.displayName);
                      } else {
                        return const Text('none');
                      }
                    }
                  }),
            )),
      ],
    );
  }
}

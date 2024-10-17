import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/about_meet.dart';
import 'package:wbrs/pages/chatscreen.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/widgets/chat_room_list.dart';
import 'package:wbrs/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wbrs/widgets/widgets.dart';
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
  String group = "";

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
    await DatabaseService(uid: firebaseAuth.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        chats = snapshot;
      });
    });
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    currentUser = firebaseAuth.currentUser;
    initInfo();
    super.initState();
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

      print(message.data);

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
      Map body = message.data;
      if (body['isChat'] == 'true') {
        nextScreen(
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
        print(users);
        nextScreen(
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
                        Filter('user1', isEqualTo: currentUser!.uid),
                        Filter('user2', isEqualTo: currentUser!.uid),
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
                        List sorted_list = snapshot.data!.docs;
                        sorted_list.sort((a, b) {
                          return b
                              .get('lastMessageSendTs')
                              .compareTo(a.get('lastMessageSendTs'));
                        });
                        if (currentUser != null) {
                          return ListView.builder(
                              itemCount: sorted_list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: ChatRoomList(
                                      snapshot: sorted_list[index]),
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

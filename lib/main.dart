import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/auth/login_page.dart';
import 'package:wbrs/pages/home_page.dart';
import 'package:wbrs/pages/profile_page.dart';
import 'package:wbrs/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wbrs/widgets/check_internet.dart';
import 'package:wbrs/widgets/splash.dart';
import 'package:wbrs/widgets/widgets.dart';
import 'package:wbrs/pages/test/red_group.dart';

import 'firebase_options.dart';
import 'helper/global.dart';
import 'pages/about_meet.dart';
import 'pages/chatscreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/launcher_icon");
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  bool _isRegistrationEnd = false;
  bool _loading = true;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ignore: prefer_typing_uninitialized_variables
  var doc;
  startMigrations() async {
    //addUnVisibleField();
  }

  initFunction() async {
    await checkInternet();
    selectedIndex = 1;
    await getUserLoggedInStatus();
    if (_isSignedIn) {
      getUserInfo();
      getUserRegistrationStatus();
    }
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission();
    }
  }

  String? mtoken;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });

    print(mtoken);

    saveUserToken(mtoken!);
  }

  void saveUserToken(String token) {
    FirebaseFirestore.instance
        .collection('TOKENS')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'token': token});
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  initNotify() {
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
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message);
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
            payload: message.notification?.body);
      } on Exception catch (e) {
        showSnackbar(context, Colors.red, e);
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'chatWithId': '',
      },
    );
  }

  getUserInfo() async {
    doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      GlobalBalance = doc.get('balance');
    });
    getToken();
    initNotify();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      nextScreen(context, const CheckInternetPage());
      return false;
    }
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  getUserRegistrationStatus() async {
    var collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    _isRegistrationEnd = await collection.get('isRegistrationEnd');

    if (_isRegistrationEnd != false) {
      setState(() {
        _isRegistrationEnd = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tema = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Times New Roman',
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: tema),
      debugShowCheckedModeBanner: false,
      routes: {
        'profile': (context) {
          return ProfilePage(
            group: getUserGroup(),
            email: FirebaseAuth.instance.currentUser!.email.toString(),
            userName: FirebaseAuth.instance.currentUser!.displayName.toString(),
            about: doc.get('about'),
            age: doc.get('age').toString(),
            rost: doc.get('rost'),
            hobbi: doc.get('hobbi'),
            city: doc.get('city'),
            deti: doc.get('deti'),
            pol: doc.get('pol'),
          );
        }
      },
      home: _isSignedIn
          ? _loading
              ? const SplashScreen()
              : _isRegistrationEnd
                  ? const HomePage()
                  : const FirstGroupRed()
          : const LoginPage(),
    );
  }
}

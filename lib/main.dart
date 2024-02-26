// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messenger/helper/helper_function.dart';
import 'package:messenger/pages/auth/login_page.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/pages/profile_page.dart';
import 'package:messenger/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:messenger/widgets/check_internet.dart';
import 'package:messenger/widgets/widgets.dart';

import 'helper/global.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  bool _isRegistrationEnd = false;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? mtoken = " ";

  var doc;

  @override
  void initState() {
    getUserInfo();
    checkInternet();
    super.initState();
    selectedIndex = 1;
    getUserLoggedInStatus();
    if (_isSignedIn) {
      getUserRegistrationStatus();
    }

    if (Platform.isIOS) {
      firebaseMessaging.requestPermission();
    }
  }

  getUserInfo() async {
    doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        print(result);
        return true;
      }
    } on SocketException catch (_) {
      nextScreen(context, const CheckInternetPage());
      print('not connected');
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

  getUserRegistrationStatus() {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    collection
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              setState(() {
                _isRegistrationEnd = result.data()['isRegistrationEnd'];
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tema = GoogleFonts.robotoTextTheme(Theme.of(context).textTheme);
    //getToken();
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
          ? _isRegistrationEnd
              ? const HomePage()
              : const HomePage()
          : const LoginPage(),
    );
  }

  getImagesUserStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('images')
        .snapshots();
  }

  void loadFCM() async {
    if (!kIsWeb) {
      var channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications',
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }
}

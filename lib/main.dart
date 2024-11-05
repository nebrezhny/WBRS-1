// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/auth/login_page.dart';
import 'package:wbrs/app/pages/home_page.dart';
import 'package:wbrs/app/pages/profile_page.dart';
import 'package:wbrs/features/auth/bloc/bloc.dart';
import 'package:wbrs/features/auth/bloc/state.dart';
import 'package:wbrs/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wbrs/app/widgets/check_internet.dart';
import 'package:wbrs/app/widgets/splash.dart';
import 'package:wbrs/app/widgets/widgets.dart';
import 'package:wbrs/app/pages/test/red_group.dart';

import 'features/auth/screen.dart';
import 'firebase_options.dart';
import 'app/helper/global.dart';

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      updateUserStatus(false);
    } else {
      updateUserStatus(true);
    }
  }

  createUsers() {
    List groups = [
      'сине-белая',
      'коричнево-красная',
      'красно-синяя',
      'бело-синяя',
      'сине-коричневая'
    ];
    for (int i = 1; i < 10; i++) {
      firebaseFirestore.collection('users').add({
        'about': 'TEST',
        'age': randomBetween(18, 35),
        'balance': 0,
        'chatWithId': '',
        'chats': [],
        'city': 'TEST',
        'deti': false,
        'email': 'testing$i@t.ru',
        'fullName': 'TEST',
        'hobbi': 'TEST',
        'images': [],
        'isRegistrationEnd': true,
        'isUnVisible': true,
        'lastOnlineTs': DateTime.now(),
        'online': false,
        'pol': 'ж',
        'presentedGifts': [],
        'profilePic': '',
        'rost': randomBetween(150, 190).toString(),
        'группа': groups[randomBetween(0, 4)],
        'testing': true,
        'uid': 'testing$i'
      });
    }
  }

  initFunction() async {
    //createUsers();
    //await checkInternet();
    updateUserStatus(true);
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

    saveUserToken(mtoken!);
  }

  void saveUserToken(String token) {
    firebaseFirestore
        .collection('TOKENS')
        .doc(firebaseAuth.currentUser?.uid)
        .set({'token': token});
  }

  @override
  void initState() {
    super.initState();
    initFunction();
    WidgetsBinding.instance.addObserver(this);
  }

  initNotify() {
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
            payload: message.notification?.body);
      } on Exception catch (e) {
        showSnackbar(context, Colors.red, e);
      }
    });
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update(
      {
        'chatWithId': '',
      },
    );
  }

  updateUserStatus(value) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'online': value});
    if (!value) {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'lastOnlineTS': DateTime.now()});
    }
  }

  getUserInfo() async {
    doc = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
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
      nextScreenReplace(context, const CheckInternetPage());
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
    var collection = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
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
            email: firebaseAuth.currentUser!.email.toString(),
            userName: firebaseAuth.currentUser!.displayName.toString(),
            about: doc.get('about'),
            age: doc.get('age').toString(),
            rost: doc.get('rost'),
            hobbi: doc.get('hobbi'),
            city: doc.get('city'),
            deti: doc.get('deti'),
            pol: doc.get('pol'),
          );
        },
        'login': (context) {
          return const AuthScreen();
        }
      },
      home: MultiBlocProvider(providers: [
        BlocProvider(create: (_) => AuthBloc(FirebaseAuth.instance))
      ], child: const AuthScreen()),
    );
    // home:
    // _isSignedIn
    //     ? _loading
    //         ? const SplashScreen()
    //         : _isRegistrationEnd
    //             ? const HomePage()
    //             : const FirstGroupRed()
    //     : const LoginPage(),
  }
}

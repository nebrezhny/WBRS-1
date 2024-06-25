import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userIdKey = "USERKEY";
  static String photoUrl = "PHOTOURL";
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}

Route createRoute(Widget Function() createPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => createPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

getUserGroup() async {
  var doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  return doc.get('группа');
}

userImageWithCircle(userPhotoUrl, group, [width, height]) {
  return Container(
    width: width ?? 100,
    height: height ?? 100,
    padding: EdgeInsets.all(9),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(getUserGroupCircle(group)),
        fit: BoxFit.cover,
      )
    ),
    child:       userPhotoUrl != ''
        ? CircleAvatar(
      backgroundImage: NetworkImage(userPhotoUrl),
    )
        : const CircleAvatar(
      radius: 39,
      backgroundImage: AssetImage("assets/profile.png"),
    ),
  );
  return Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
        radius: 44,
        backgroundImage: AssetImage(getUserGroupCircle(group)),
        backgroundColor: Colors.transparent,
      ),
      userPhotoUrl != ''
          ? CircleAvatar(
              radius: 37,
              backgroundImage: NetworkImage(userPhotoUrl),
            )
          : const CircleAvatar(
              radius: 39,
              backgroundImage: AssetImage("assets/profile.png"),
            ),
    ],
  );
}

String getUserGroupCircle(group) {
  switch (group) {
    case "коричнево-красная":
      return "assets/circles/корк.png";
    case "красно-коричневая":
      return "assets/circles/ккор.png";
    case "красно-синяя":
      return "assets/circles/кс.png";
    case "коричнево-синяя":
      return "assets/circles/корс.png";
    case "коричнево-белая":
      return "assets/circles/корб.png";
    case "красно-белая":
      return "assets/circles/кб.png";
    case "сине-коричневая":
      return "assets/circles/скор.png";
    case "сине-красная":
      return "assets/circles/ск.png";
    case "сине-белая":
      return "assets/circles/сб.png";
    case "бело-коричневая":
      return "assets/circles/бкор.png";
    case "бело-красная":
      return "assets/circles/бк.png";
    case "бело-синяя":
      return "assets/circles/бс.png";
    case "белая":
      return "assets/circles/б.png";
    case "коричневая":
      return "assets/circles/кор.png";
    case "красная":
      return "assets/circles/к.png";
    case "синяя":
      return "assets/circles/с.png";

    default:
      return "assets/circles/с.png";
  }
}

List<Widget> getLikeGroup(myGroup) {
  List spisok = [];
  if (myGroup == "коричнево-красная" ||
      myGroup == "коричнево-синяя" ||
      myGroup == "коричнево-белая") {
    spisok = ["Все белые", "Красно-белая", "Сине-белая", "Коричнево-белая"];
  } else if (myGroup == "красно-коричневая" ||
      myGroup == "красно-синяя" ||
      myGroup == "красно-белая") {
    spisok = [
      "Все синие",
      "Коричнево-синяя",
      "Коричнево-белая",
    ];
  } else if (myGroup == "сине-коричневая" ||
      myGroup == "сине-красная" ||
      myGroup == "сине-белая") {
    spisok = [
      "Красно-синяя",
      "Сине-красная",
      "Красно-белая",
    ];
  } else if (myGroup == "бело-коричневая" ||
      myGroup == "бело-синяя" ||
      myGroup == "бело-красная") {
    spisok = ["Все коричневые", "Сине-белая"];
  } else if (myGroup == "Сине-белая") {
    spisok = [
      "Все коричневые",
      "Бело-коричневая",
      "Красно-коричневая",
    ];
  }

  List<Widget> spisokOfWidgets = [];

  for (int i = 0; i < spisok.length; i++) {
    spisokOfWidgets.add(Text(
      spisok[i],
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ));
  }
  if (spisok.length != 0) {
    return spisokOfWidgets;
  } else {
    return [
      Text(
        myGroup,
      )
    ];
  }
}

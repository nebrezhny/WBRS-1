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

List<Widget> getLikeGroup(myGroup) {
  List spisok = [];
  if (myGroup == "коричнево-красная" ||
      myGroup == "коричнево-синяя" ||
      myGroup == "коричнево-белая") {
    spisok = [
      "красно-синяя",
      "сине-коричневая",
      "сине-красная",
      "сине-белая",
      "бело-синяя"
    ];
  } else if (myGroup == "красно-коричневая" ||
      myGroup == "красно-синяя" ||
      myGroup == "красно-белая") {
    spisok = [
      "красно-синяя",
      "коричнево-синяя",
      "бело-коричневая",
      "бело-красная",
      "коричнево-белая",
      "коричнево-красная",
      "бело-синяя"
    ];
  } else if (myGroup == "сине-коричневая" ||
      myGroup == "сине-красная" ||
      myGroup == "сине-белая") {
    spisok = [
      "коричнево-синяя",
      "коричнево-красная",
      "коричнево-белая",
      "бело-синяя"
    ];
  } else if (myGroup == "бело-коричневая" ||
      myGroup == "бело-синяя" ||
      myGroup == "бело-красная") {
    spisok = ["красно-синяя", "бело-красная", "красно-белая"];
  } else if (myGroup == "бело-синяя") {
    spisok = [
      "коричнево-красная",
      "сине-коричневая",
      "коричнево-белая",
      "красно-синяя",
      "красно-коричневая",
      "красно-белая"
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

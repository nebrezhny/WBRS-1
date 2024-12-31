import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

String? GlobalAbout,
    GlobalAge = '',
    GlobalPol,
    GlobalCity,
    GlobalRost,
    GlobalHobbi;
int GlobalBalance = 0;
// ignore: non_constant_identifier_names
bool GlobalDeti = false;

//красная,зелёная,белая,оранжевая

String Group = '';
int BrownGroup = 0, WhiteGroup = 0, RedGroup = 0, BlueGroup = 0;
bool testIsComlpete = false;

int CountImages = 0;
List Images = [];

int selectedIndex = 1;

//Filter data
String FiltrPol = "";
int ageStart = 18, ageEnd = 100;
TextEditingController filterCity = TextEditingController();
String meetCity = '';
bool filterByGroup = false;

bool imageStream = true;

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

List<Map<dynamic, dynamic>> usersFromStream = [];
DateTime lastUpdate = DateTime(2000);

Color grey = const Color.fromRGBO(82, 82, 82, 0.7);
Color darkGrey = const Color.fromRGBO(120, 120, 120, 0.8);
Color orange90 = const Color.fromRGBO(255, 173, 50, 0.9);
Color white70 = const Color.fromRGBO(255, 255, 255, 0.9);

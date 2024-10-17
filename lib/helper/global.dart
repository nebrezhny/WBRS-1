// ignore: non_constant_identifier_names

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

String? somebodyUid,
    somebodyFullname,
    somebodyImageUrl,
    GlobalAbout,
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
TextEditingController filtrCity = TextEditingController();
bool filterByGroup = false;

late List user_info;

bool imageStream = true;

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// ignore: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String? somebodyUid,
    somebodyFullname,
    somebodyImageUrl,
    GlobalAbout,
    GlobalAge = '',
    GlobalPol,
    GlobalCity,
    GlobalRost,
    GlobalHobbi;
// ignore: non_constant_identifier_names
bool GlobalDeti = false;

//красная,зелёная,белая,оранжевая

String? Group;
int RedGroup = 0, WhiteGroup = 0, GreenGroup = 0, OrangeGroup = 0;
bool testIsComlpete = false;

int CountImages = 0;
List Images = [];

int selectedIndex = 1;

//Filter data
String FiltrPol = "";
RangeValues currentValues = const RangeValues(18, 22);

late List user_info;

getWidthOfScreen(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
}

getHeightOfScreen(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
}

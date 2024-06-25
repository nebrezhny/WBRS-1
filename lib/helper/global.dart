// ignore: non_constant_identifier_names

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

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
RangeValues currentValues = const RangeValues(18, 100);
TextEditingController filtrCity = TextEditingController();

late List user_info;

bool imageStream = true;

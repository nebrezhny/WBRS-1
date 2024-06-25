// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:wbrs/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
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
        const Scaffold(
          body: Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.orangeAccent,
          )),
          backgroundColor: Colors.transparent,
        )
      ],
    );
  }
}

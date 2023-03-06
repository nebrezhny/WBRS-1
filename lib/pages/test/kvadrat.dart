// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';

class Kvadrat extends StatefulWidget {
  const Kvadrat({Key? key}) : super(key: key);

  @override
  State<Kvadrat> createState() => _KvadratState();
}

class _KvadratState extends State<Kvadrat> {
  Alignment align = Alignment.center;
  bool all_buttons = true;
  bool left_button = true;
  bool right_button = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: 500,
        height: 1000,
        child: Center(
          child: Column(
            children: [
              AnimatedContainer(
                color: Colors.white,
                alignment: align,
                height: 100,
                width: MediaQuery.of(context).size.width,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(seconds: 1),
                child: Container(
                  color: Colors.green,
                  width: 100,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: all_buttons
                        ? left_button
                            ? () {
                                MoveLeft();
                                all_buttons = false;
                                Timer(const Duration(seconds: 1), () {
                                  setState(() {
                                    all_buttons = true;
                                  });
                                });
                                left_button = false;
                                right_button = true;
                              }
                            : null
                        : null,
                    style: const ButtonStyle(),
                    child: const Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                      onPressed: all_buttons
                          ? right_button
                              ? () {
                                  MoveRight();
                                  all_buttons = false;
                                  Timer(const Duration(seconds: 1), () {
                                    setState(() {
                                      all_buttons = true;
                                    });
                                  });
                                  right_button = false;
                                  left_button = true;
                                }
                              : null
                          : null,
                      child: const Icon(Icons.arrow_forward_outlined)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void MoveLeft() {
    setState(() {
      align = Alignment.topLeft;
    });
  }

  void MoveRight() {
    setState(() {
      align = Alignment.topRight;
    });
  }
}

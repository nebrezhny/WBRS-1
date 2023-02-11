import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:path_provider/path_provider.dart';

class Politica extends StatefulWidget {
  const Politica({super.key});

  @override
  State<Politica> createState() => _PoliticaState();
}

class _PoliticaState extends State<Politica> {
  String _text = '';

  @override
  void initState() {
    _read();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.green,
            )
          ]),
          child: Image.asset(
            "assets/fon.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        Scaffold(
          appBar: AppBar(title: const Text("Политика конфиденциальности")),
          backgroundColor: Colors.transparent,
          body: Container(
              child: Text(
            File("my_file.txt").readAsStringSync(),
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ],
    );
  }

  Future<void> _read() async {
    String text = '';
    try {
      //final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File("my_file.txt");
      text = await file.readAsString();
    } catch (e) {
      print(e);
    }
    setState(() {
      _text = text;
    });
  }
}

// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:wbrs/app/pages/policy/confidecialnost.dart';
import 'package:wbrs/app/pages/policy/soglashenie.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class About_App extends StatelessWidget {
  const About_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Image.asset(
            "assets/fon.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 22),
              title: const Text("О приложении"),
              backgroundColor: Colors.transparent,
            ),
            drawer: const MyDrawer(),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, const Politica());
                    },
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(15)),
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.transparent)),
                    child: const Text(
                      'Политика конфиденциальности и обработки персональных данных',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, const Rules(  ));
                    },
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(15)),
                        backgroundColor:
                        WidgetStatePropertyAll(Colors.transparent)),
                    child: const Text(
                      'Правила использования приложения',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Версия приложения',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '1.0',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        //nextScreenReplace(context, const ComplaintForm());
                      },
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            'Обратная связь',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

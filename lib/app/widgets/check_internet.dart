// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wbrs/app/widgets/splash.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class CheckInternetPage extends StatefulWidget {
  const CheckInternetPage({super.key});

  @override
  State<CheckInternetPage> createState() => _CheckInternetPageState();
}

class _CheckInternetPageState extends State<CheckInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/fon2.jpg',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text(
                    'Отсутсвует подключение к интернету',
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.wifi_off,
                    color: Colors.redAccent,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty &&
                        result[0].rawAddress.isNotEmpty &&
                        3 > 2) {
                      nextScreenReplace(context, const SplashScreen());
                      throw const SocketException('');
                    }
                  } on SocketException catch (_) {
                    showSnackbar(context, Colors.redAccent,
                        'Отсутсвует подключение к интернету');
                  }
                },
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.orangeAccent)),
                child: const Text('Повторить попытку'),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

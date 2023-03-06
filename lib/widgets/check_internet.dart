import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/widgets/widgets.dart';

class CheckInternetPage extends StatefulWidget {
  const CheckInternetPage({super.key});

  @override
  State<CheckInternetPage> createState() => _CheckInternetPageState();
}

class _CheckInternetPageState extends State<CheckInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
          child: Column(
        children: [
          Row(
            children: const [
              Text('Отсутсвует подключение к интернету'),
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
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
              } on SocketException catch (_) {
                showSnackbar(context, Colors.redAccent,
                    'Отсутсвует подключение к интернету');
              }
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.orangeAccent)),
            child: const Text('Повторить попытку'),
          ),
        ],
      )),
    );
  }
}

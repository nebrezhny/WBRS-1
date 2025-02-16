import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  String text = '';

  Uri emailLaunch = Uri(
    scheme: 'mailto',
    path: 'myemail@email.com',
  );

  @override
  void initState() {
    getText();
    super.initState();
  }

  void getText() async {
    text = await loadAsset();
    setState(() {});
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/agreement.txt');
  }

  @override
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
            'assets/fon.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        Scaffold(
            appBar: AppBar(
              title: const Text(
                'Пользовательское соглашени',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1,
                        fontFamily: 'Colibri'),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

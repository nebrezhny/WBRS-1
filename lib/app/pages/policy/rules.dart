import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widgets.dart';

class Rule extends StatefulWidget {
  const Rule({super.key});

  @override
  State<Rule> createState() => _RuleState();
}

class _RuleState extends State<Rule> {
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
    return await rootBundle.loadString('assets/rules.txt');
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
                'Правила использования приложения',
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
                  const Text(
                    'LRS version 1.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        try {
                          launchUrl(Uri.parse('mailto:supp.lrs@ya.ru'));
                        } on Exception catch (e) {
                          showSnackbar(context, Colors.red, e);
                        }
                      },
                      child: const Text(
                        'supp.lrs@ya.ru',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                  const Text(
                    'Здесь благодаря алгоритму и психологии вы легко найдете близкого человека для создания долгих, крепких отношений, дружбы, семьи',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Правила использования приложения',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
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

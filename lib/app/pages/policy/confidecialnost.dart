import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Politica extends StatefulWidget {
  const Politica({super.key});

  @override
  State<Politica> createState() => _PoliticaState();
}

class _PoliticaState extends State<Politica> {
  String text = '';

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
    return await rootBundle.loadString('assets/policy.txt');
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
                'Политика в отношении обработки персональных данных',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Политика в отношении обработки персональных данных',
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

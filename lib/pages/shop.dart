import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:messenger/widgets/bottom_nav_bar.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';
import 'package:tinkoff_acquiring_flutter/tinkoff_acquiring_flutter.dart';

class Podarok {
  String img;
  String name;
  int price;

  Podarok({required this.name, required this.price, required this.img});
}

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TinkoffAcquiring acquiring = TinkoffAcquiring(
      TinkoffAcquiringConfig.credential(
          terminalKey: terminalKey, isDebugMode: true));

  static const String terminalKey = 'TestSDK';
  static const String password = '12345678';
  static const String publicKey =
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5Yg3RyEkszggDVMDHCAGzJm0mYpYT53BpasrsKdby8iaWJVACj8ueR0Wj3Tu2BY64HdIoZFvG0v7UqSFztE/zUvnznbXVYguaUcnRdwao9gLUQO2I/097SHF9r++BYI0t6EtbbcWbfi755A1EWfu9tdZYXTrwkqgU9ok2UIZCPZ4evVDEzDCKH6ArphVc4+iKFrzdwbFBmPmwi5Xd6CB9Na2kRoPYBHePGzGgYmtKgKMNs+6rdv5v9VB3k7CS/lSIH4p74/OPRjyryo6Q7NbL+evz0+s60Qz5gbBRGfqCA57lUiB3hfXQZq5/q1YkABOHf9cR6Ov5nTRSOnjORgPjwIDAQAB';

  static const String customerKey = 'madbrains-user-key';
  static const int amount = 1400;

  ValueNotifier<bool> threeDs = ValueNotifier<bool>(false);
  ValueNotifier<bool> threeDsV2 = ValueNotifier<bool>(false);
  ValueNotifier<String?> status = ValueNotifier<String?>('');
  ValueNotifier<String?> cardType = ValueNotifier<String?>('');

  @override
  Widget build(BuildContext context) {
    final podarki = <Podarok>[
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(
          name: 'name',
          price: 100,
          img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg')
    ];

    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text("Магазин"),
          ),
          drawer: const MyDrawer(),
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: podarki.length,
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        kartochkaTovara(podarki[index].name, podarki[index].img,
                            podarki[index].price),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  kartochkaTovara(String name, String url, int price) {
    return ListTile(
      leading: Image.network(url),
      title: Text(name),
      subtitle: Text(price.toString()),
      trailing: ElevatedButton(
        onPressed: () {},
        child: const Text("Купить"),
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orangeAccent)),
      ),
      tileColor: Colors.white,
    );
  }
}

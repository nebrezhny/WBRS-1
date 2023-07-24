import 'package:flutter/material.dart';
import 'package:messenger/widgets/bottom_nav_bar.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';

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

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  TabController? _controller;
  final TinkoffAcquiring acquiring = TinkoffAcquiring(
      TinkoffAcquiringConfig.credential(
          terminalKey: terminalKey, isDebugMode: true));

  static const String terminalKey = 'TestSDK';

  ValueNotifier<bool> threeDs = ValueNotifier<bool>(false);
  ValueNotifier<bool> threeDsV2 = ValueNotifier<bool>(false);
  ValueNotifier<String?> status = ValueNotifier<String?>('');
  ValueNotifier<String?> cardType = ValueNotifier<String?>('');

  final List<Tab> topTabs = <Tab>[
    new Tab(text: 'Магазин'),
    new Tab(text: 'История покупок'),
  ];

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final podarki = <Podarok>[
      Podarok(name: 'name', price: 100, img: "assets/gifts/1.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/2.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/3.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/4.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/5.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/6.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/7.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/8.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/9.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/10.jpg"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/11.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/12.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/13.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/14.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/15.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/16.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/17.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/18.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/19.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/20.jpg"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/21.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/22.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/23.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/24.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/25.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/26.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/27.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/28.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/29.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/30.jpg"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/31.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/32.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/33.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/34.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/35.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/36.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/37.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/38.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/39.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/40.jpg"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/41.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/42.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/43.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/44.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/45.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/46.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/47.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/48.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/49.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/50.jpg"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/51.jpg"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/52.jpg"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/53.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/54.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/55.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/56.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/57.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/58.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/59.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/60.jpg"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/61.jpg"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/62.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/63.jpg"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/64.jpg"),
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
              bottom: TabBar(
                controller: _controller,
                tabs: topTabs,
              ),
            ),
            drawer: const MyDrawer(),
            bottomNavigationBar: const MyBottomNavigationBar(),
            body: TabBarView(controller: _controller, children: [
              first(),
              Center(
                child: Text(
                  'Пока нет заказов.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ])),
      ],
    );
  }

  kartochkaTovara(String name, String url, int price) {
    return ListTile(
      leading: SizedBox(
        width: 80,
        height: 80,
        child: Image.asset(
          url,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name),
      subtitle: Text(price.toString() + " серебра"),
      trailing: ElevatedButton(
        onPressed: () {},
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orangeAccent)),
        child: const Text("Купить"),
      ),
      tileColor: Colors.white,
    );
  }

  first() {
    final podarki = <Podarok>[
      Podarok(name: 'name', price: 12, img: "assets/gifts/1.jpg"),
      Podarok(name: 'name', price: 12, img: "assets/gifts/2.jpg"),
      Podarok(name: 'name', price: 12, img: "assets/gifts/3.jpg"),
    ];
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Услуги",
              style: TextStyle(color: Colors.white, fontSize: 21),
            ),
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.orangeAccent)),
              child: const Text("Пополнить баланс (от 100 руб.)"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.orangeAccent)),
              child: const Text("Отключить рекламу"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.orangeAccent)),
              child: const Text("Режим невидимки"),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Подарки",
              style: TextStyle(color: Colors.white, fontSize: 21),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
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
            const SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}

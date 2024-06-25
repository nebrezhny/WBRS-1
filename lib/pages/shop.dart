import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wbrs/pages/chatscreen.dart';
import 'package:wbrs/pages/home_page.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/widgets/bottom_nav_bar.dart';
import 'package:wbrs/widgets/drawer.dart';
import 'package:wbrs/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

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

  static const String terminalKey = 'TestSDK';

  ValueNotifier<bool> threeDs = ValueNotifier<bool>(false);
  ValueNotifier<bool> threeDsV2 = ValueNotifier<bool>(false);
  ValueNotifier<String?> status = ValueNotifier<String?>('');
  ValueNotifier<String?> cardType = ValueNotifier<String?>('');

  final List<Tab> topTabs = <Tab>[
    const Tab(text: 'Магазин'),
    const Tab(text: 'Подарки'),
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
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white)),
            backgroundColor: Colors.transparent,
            drawer: const MyDrawer(),
            bottomNavigationBar: const MyBottomNavigationBar(),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Colors.transparent,
                    pinned: false,
                    title: const Text(
                      'Магазин',
                      style: TextStyle(color: Colors.white),
                    ),
                    centerTitle: true,
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white,
                      controller: _controller,
                      tabs: topTabs,
                      isScrollable: true,
                    ),
                  )
                ];
              },
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return TabBarView(controller: _controller, children: [
                      first(context),
                      second(snapshot.data, context)
                    ]);
                  }),
            )),
      ],
    );
  }

  kartochkaTovara(
      String name, String url, int price, bool sold, BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListTile(
        minLeadingWidth: 100,
        leading: SizedBox(
          width: 90,
          height: 80,
          child: Image.asset(
            url,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(name),
        subtitle: sold
            ? Text(
                "Количество: " + price.toString(),
                overflow: TextOverflow.visible,
                softWrap: false,
              )
            : Text(price.toString() + " серебра"),
        trailing: ElevatedButton(
          onPressed: () async {
            if (!sold) {
              var coll = FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid);
              var data = await coll.get();

              var initGifts = data.data()!['gifts'];

              initGifts ??= [];

              initGifts.add(url);
              coll.update({'gifts': initGifts});
            } else {
              var snap = await FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('lastMessage')
                  .get();

              var chats = [];
              for (var chat in snap.docs) {
                if (chat.data()['user1'] ==
                        FirebaseAuth.instance.currentUser!.uid ||
                    chat.data()['user2'] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  chats.add(chat);
                }
              }

              Map<int, dynamic> chatRoomInfoMap = {};
              int count = 0;
              for (var chat in chats) {
                if (chat.data()['user1'] ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  chatRoomInfoMap.addAll({
                    count: {
                      "chatId": chat.data()['chatId'],
                      "id": chat.data()['user2'],
                      "nickname": chat.data()['user2Nickname'],
                      "image": chat.data()['user2_image']
                    },
                  });
                  count++;
                } else {
                  chatRoomInfoMap.addAll({
                    count: {
                      "chatId": chat.data()['chatId'],
                      "id": chat.data()['user1'],
                      "nickname": chat.data()['user1Nickname'],
                      "image": chat.data()['user1_image']
                    },
                  });
                  count++;
                }
              }

              if (mounted) {
                List<bool> isSelected =
                    List.filled(chatRoomInfoMap.length, false);
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                        return Container(
                            height: 450,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.arrow_back_ios_new_rounded)),
                                ),
                                Container(
                                  height: 300,
                                  child: GridView.builder(
                                      itemCount: chatRoomInfoMap.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelected[index] =
                                                  !isSelected[index];
                                              for (int i = 0;
                                                  i < isSelected.length;
                                                  i++) {
                                                if (i != index) {
                                                  isSelected[i] = false;
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 160,
                                            width: 120,
                                            margin: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: isSelected[index]
                                                      ? BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.blue,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                100),
                                                          ))
                                                      : null,
                                                  child: CircleAvatar(
                                                    radius: 27,
                                                    backgroundImage:
                                                        chatRoomInfoMap[index]
                                                                    ['image'] ==
                                                                ""
                                                            ? const NetworkImage(
                                                                "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                                              )
                                                            : NetworkImage(
                                                                chatRoomInfoMap[
                                                                        index]
                                                                    ['image']),
                                                  ),
                                                ),
                                                Text(
                                                  chatRoomInfoMap[index]
                                                      ['nickname'],
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                isSelected.contains(true)
                                    ? Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              textStyle: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                              minimumSize: const Size(200, 50),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                            ),
                                            onPressed: () async {
                                              int selectedNumber = 0;
                                              for (int i = 0;
                                                  i < isSelected.length;
                                                  i++) {
                                                if (isSelected[i]) {
                                                  selectedNumber = i;
                                                }
                                              }
                                              QuerySnapshot querySnap =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('fullName',
                                                          isEqualTo:
                                                              chatRoomInfoMap[
                                                                      selectedNumber]
                                                                  ['nickname'])
                                                      .get();

                                              String chatId = chatRoomInfoMap[
                                                  selectedNumber]['chatId'];
                                              String chatWith = querySnap
                                                  .docs[0]['chatWithId'];
                                              bool isUserInChat = chatWith ==
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid;

                                              Map<String, dynamic>
                                                  messageInfoMap = {
                                                "message": chatRoomInfoMap[
                                                    selectedNumber]['image'],
                                                "sendBy": FirebaseAuth.instance
                                                    .currentUser!.displayName,
                                                "sendByID": FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                "ts": DateTime.now(),
                                                "imgUrl": FirebaseAuth.instance
                                                    .currentUser!.photoURL,
                                                "isRead":
                                                    isUserInChat ? true : false
                                              };

                                              DatabaseService().addMessage(
                                                  chatId,
                                                  randomAlphaNumeric(12),
                                                  messageInfoMap);
                                              nextScreen(
                                                  context,
                                                  ChatScreen(
                                                      chatWithUsername:
                                                          chatRoomInfoMap[
                                                                  selectedNumber]
                                                              ['nickname'],
                                                      photoUrl: chatRoomInfoMap[
                                                              selectedNumber]
                                                          ['image'],
                                                      id: FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      chatId: chatId));
                                            },
                                            child: const Text("Подарить")),
                                      )
                                    : Container()
                              ],
                            ));
                      });
                    });
              }
            }
          },
          style: const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
              backgroundColor: MaterialStatePropertyAll(Colors.orangeAccent)),
          child: sold ? const Text("Подарить") : const Text("Купить"),
        ),
        tileColor: Colors.white,
      ),
    );
  }

  first(context) {
    final podarki = <Podarok>[
      Podarok(name: 'name', price: 100, img: "assets/gifts/1.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/2.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/3.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/4.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/5.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/6.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/7.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/8.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/9.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/10.png"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/11.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/12.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/13.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/14.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/15.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/16.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/17.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/18.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/19.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/20.png"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/21.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/22.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/23.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/24.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/25.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/26.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/27.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/28.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/29.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/30.png"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/31.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/32.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/33.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/34.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/35.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/36.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/37.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/38.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/39.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/40.png"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/41.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/42.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/43.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/44.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/45.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/46.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/47.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/48.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/49.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/50.png"),
      Podarok(name: 'name', price: 100, img: "assets/gifts/51.png"),
      Podarok(name: 'name', price: 200, img: "assets/gifts/52.png"),
      Podarok(name: 'name', price: 300, img: "assets/gifts/53.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/54.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/55.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/56.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/57.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/58.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/59.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/60.png"),
      Podarok(name: 'name', price: 400, img: "assets/gifts/61.png"),
      Podarok(name: 'name', price: 500, img: "assets/gifts/62.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/63.png"),
      Podarok(name: 'name', price: 600, img: "assets/gifts/64.png"),
    ];
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
              height: podarki.length * 90,
              width: double.infinity,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: podarki.length,
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        kartochkaTovara(podarki[index].name, podarki[index].img,
                            podarki[index].price, false, context),
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

  second(data, context) {
    if (data != null) {
      List initGifts = data.data()!['gifts'];
      List filteredGifts = [];
      Map<String, int> countGifts = {};

      if (initGifts.isNotEmpty) {
        for (int i = 0; i < initGifts.length; i++) {
          if (initGifts[i] != null) {
            if (filteredGifts.any((element) => element == initGifts[i])) {
              countGifts.update(initGifts[i], (value) => value + 1);
            } else {
              filteredGifts.add(initGifts[i]);
              countGifts.addAll({initGifts[i]: 1});
            }
          }
        }
      }

      initGifts = initGifts.toSet().toList();

      return initGifts.isEmpty
          ? const Center(
              child: Text(
              "У вас нет подарков",
              style: TextStyle(color: Colors.white),
            ))
          : SizedBox(
              height: (MediaQuery.of(context).size.height * 1) - 100,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: initGifts.length,
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        kartochkaTovara("", initGifts[index],
                            countGifts[initGifts[index]]!, true, context),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }));
    } else {
      return const Center(
          child: Text(
        "У вас нет подарков",
        style: TextStyle(color: Colors.white),
      ));
    }
  }
}

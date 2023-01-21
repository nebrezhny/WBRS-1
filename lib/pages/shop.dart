import 'package:flutter/material.dart';
import 'package:messenger/widgets/drawer.dart';


class Podarok{
  String img;
  String name;
  int price;


  Podarok ({
    required this.name,
    required this.price,
    required this.img
  });
}



class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {

    final podarki=<Podarok>[
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg'),
      Podarok(name: 'name', price: 100, img: 'https://bumper-stickers.ru/43054-thickbox_default/podarok.jpg')
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

          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Подарки",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index){
                                return Padding(
                                  padding: const EdgeInsets.all( 8.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: GestureDetector(
                                      onTap: (){},
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              SizedBox(
                                                height: 140,
                                                  child: Image.network(podarki[index].img,fit: BoxFit.cover,)),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(podarki[index].name,),
                                                    Row(
                                                      children: [
                                                        Text("Стоимость: ${podarki[index].price.toString()} "),
                                                        const Icon(Icons.monetization_on_outlined),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: podarki.length,

                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}

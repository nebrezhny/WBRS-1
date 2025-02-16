import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullscreenSliderDemo extends StatelessWidget {
  final int initialPage;
  final List imgList;
  const FullscreenSliderDemo(
      {super.key, required this.initialPage, required this.imgList});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/fon.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return CarouselSlider(
                options: CarouselOptions(
                  height: height,
                  aspectRatio: 1 / 1,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: initialPage,
                  enableInfiniteScroll: false,
                  // autoPlay: false,
                ),
                items: imgList.map((item) {
                  return Center(
                      child: InteractiveViewer(
                    maxScale: 4.0,
                    minScale: 0.5,
                    child: CachedNetworkImage(
                      key: ValueKey(item),
                      imageUrl: item,
                    ),
                  ));
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

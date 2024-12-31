import 'package:flutter/material.dart';
import 'package:wbrs/app/widgets/bottom_nav_bar.dart';

class DeletedProfile extends StatelessWidget {
  const DeletedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          scale: 0.6,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: const Center(
            child: Text("Профиль был удален", style: TextStyle(color: Colors.white),),
          ),
        ),
      ],
    );
  }
}

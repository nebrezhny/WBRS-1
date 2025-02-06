import 'package:flutter/material.dart';
import 'package:wbrs/app/pages/admin/meets.dart';
import 'package:wbrs/app/pages/admin/users.dart';
import 'package:wbrs/app/widgets/bottom_nav_bar.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: []),
          child: Image.asset(
            "assets/fon.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: MyDrawer(),

          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: adminPanelPage(context),
        ),
      ],
    );
  }

  Widget adminPanelPage(context) {
    return Column(
      children: [
        ListTile(
          onTap: ()=> nextScreen(context, const Users()),
          title: const Text('Пользователи', style: TextStyle(color: Colors.white),),
          leading: const Icon(Icons.account_circle, color: Colors.white,),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
        ),
        ListTile(
          onTap: ()=> nextScreen(context, const Meets()),
          title: const Text('Встречи', style: TextStyle(color: Colors.white),),
          leading: const Icon(Icons.account_circle, color: Colors.white,),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
        )
      ],
    );
  }
}

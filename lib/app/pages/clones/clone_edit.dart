import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/widgets/bottom_nav_bar.dart';
import 'package:wbrs/app/widgets/drawer.dart';

class CloneEdit extends StatefulWidget {
  final Map cloneInfo;
  const CloneEdit({super.key, required this.cloneInfo});

  @override
  State<CloneEdit> createState() => _CloneEditState();
}

class _CloneEditState extends State<CloneEdit> {
  @override
  Widget build(BuildContext context) {
    TextEditingController name =
            TextEditingController(text: widget.cloneInfo['fullName']),
        about = TextEditingController(text: widget.cloneInfo['about']),
        hobbi = TextEditingController(text: widget.cloneInfo['hobbi']);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            textInput(name),
            textInput(about),
            textInput(hobbi),
            TextButton(
                onPressed: () {
                  firebaseFirestore
                      .collection('users')
                      .doc(widget.cloneInfo['id'])
                      .update({
                    'fullName': name.text,
                    'about': about.text,
                    'hobbi': hobbi.text
                  });
                  Navigator.pop(context);
                },
                child: Text('Сохранить'))
          ],
        ),
      ),
    );
  }

  textInput(ctrl) {
    return TextField(
      controller: ctrl,
    );
  }
}

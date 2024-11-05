import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wbrs/app/helper/global.dart';

addUnVisibleField() async {
  CollectionReference coll = firebaseFirestore.collection('users');
  QuerySnapshot data = await coll.get();
  for (int i = 0; i < data.docs.length; i++) {
    coll.doc(data.docs[i].id).update({"isUnVisible": false});
  }
}

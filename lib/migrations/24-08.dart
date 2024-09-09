import 'package:cloud_firestore/cloud_firestore.dart';

addUnVisibleField()async {
  CollectionReference coll = FirebaseFirestore.instance.collection('users');
 QuerySnapshot data = await coll.get();
 for(int i=0; i<data.docs.length; i++){

   coll.doc(data.docs[i].id).update({
     "isUnVisible":false
   });
 }
}
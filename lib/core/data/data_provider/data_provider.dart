import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataProvider {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future readData(String col) async {
    QuerySnapshot querySnapshot = await db.collection(col).get();
    List<Map> data = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      data.add(querySnapshot.docs[i].data() as Map);
    }
    return data;
  }

  Future addDoc(String col, Map<String, dynamic> data) async {
    await db.collection(col).add(data);
  }

  Future updateDoc(String col, String id, Map<String, dynamic> data) async {
    await db.collection(col).doc(id).update(data);
  }

  Future removeDoc(String col, String id) async {
    await db.collection(col).doc(id).delete();
  }

  Map getCurrentUser() {
    return auth.currentUser as Map;
  }
}

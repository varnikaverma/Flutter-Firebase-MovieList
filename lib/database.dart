import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference moviecollection =
      FirebaseFirestore.instance.collection('movielist');
  Future updateUserData(String name, String cat, String dir, String act) async {
    return await moviecollection.doc(uid).set({
      'name': name,
      'cat': cat,
      'dir': dir,
      'act': act,
    });
  }

  Stream<QuerySnapshot> get movies {
    return moviecollection.snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore? firestore;
  initialize() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List<dynamic>?> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore!.collection('countries').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map data = {
            "id": doc.id,
            "name": doc['name'],
            "code": doc['code'],
            "phone": doc['phone'],
            "timestamp": doc['timestamp'],
          };
          docs.add(data);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

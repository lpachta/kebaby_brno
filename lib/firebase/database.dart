import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';

class KebabDatabase {
  final _db = FirebaseFirestore.instance;
  final COLLECTION_NAME = "kebaby";

  void add(KebabEntry data) async {
    //await _db.collection(COLLECTION_NAME).add(data.toJson());
    _db
        .collection(COLLECTION_NAME)
        .doc()
        .set(data.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  get snapshots {
    return _db.collection(COLLECTION_NAME).snapshots();
  }
}

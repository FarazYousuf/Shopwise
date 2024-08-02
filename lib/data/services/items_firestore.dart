import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save an item to Firestore
  Future<void> addItem(String itemName) async {
    try {
      await _db.collection('items').add({'name': itemName});
    } catch (e) {
      print(e);
    }
  }

  // Get a stream of items from Firestore
  Stream<List<String>> getItems() {
    return _db
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['name'] as String)
            .toList());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  DocumentReference postPath;
  Favorite({required this.postPath});

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Favorite(postPath: data['postPath']);
  }
}

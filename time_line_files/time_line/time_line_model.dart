import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/favorite.dart';
import '../../domain/post.dart';

class TimeLineModel extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  List<Post> posts = [];

  Future<void> fetchPosts(List<Favorite> favorites) async {
    Stream<QuerySnapshot> postsQuerySnapshot =
        FirebaseFirestore.instance.collectionGroup('posts').snapshots();

    postsQuerySnapshot.listen(
      (postSnapshot) {
        posts = postSnapshot.docs.map((DocumentSnapshot doc) {
          return Post.fromFireStore(doc);
        }).toList();
        for (var post in posts) {
          for (var favorite in favorites) {
            if (post.ref == favorite.postPath) {
              post.isFavorite = true;
              break;
            }
          }
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchFavorite() async {
    if (user == null) {
      return;
    }

    Stream<QuerySnapshot> favoritesQuerySnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .snapshots();

    favoritesQuerySnapshot.listen((favoritesSnapshot) {
      final favoriteList = favoritesSnapshot.docs
          .map((DocumentSnapshot snapshot) => Favorite.fromFirestore(snapshot))
          .toList();
      fetchPosts(favoriteList);
      notifyListeners();
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../domain/favorite.dart';
import '../domain/post.dart';
import '../domain/profile.dart';

class FavoriteModel extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  List<Post> posts = [];
  List<Profile> profiles = [];

  Future<void> fetchPosts(List<Favorite> favorites) async {
    Stream<QuerySnapshot> postsQuerySnapshot =
        FirebaseFirestore.instance.collectionGroup('posts').snapshots();

    postsQuerySnapshot.listen((postSnapshot) {
      final allPosts = postSnapshot.docs.map((DocumentSnapshot doc) {
        return Post.fromFireStore(doc);
      }).toList();
      final favoritesRef = favorites.map((e) => e.postPath).toList();

      final favoritePosts = allPosts
          .where((element) => favoritesRef.contains(element.ref))
          .toList();
      for (var favoritePost in favoritePosts) {
        favoritePost.isFavorite = true;
      }
      posts = favoritePosts;
      notifyListeners();
    });
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
      final favoriteList =
          favoritesSnapshot.docs.map((e) => Favorite.fromFirestore(e)).toList();
      fetchPosts(favoriteList);
      notifyListeners();
    });
  }
}

//favoritesコレクションをlisten
//postコレクションをlisten

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../domain/favorite.dart';
import '../domain/post.dart';
import '../domain/profile.dart';

class AccountModel extends ChangeNotifier {
  Profile? profile;
  List<Post> posts = [];
  List<Profile> profiles = [];

  User? user = FirebaseAuth.instance.currentUser;
  String? name;

  Future<void> confirmSignOut(BuildContext context) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('本当にサインアウトしますか？'),
              actions: [
                CupertinoButton(
                    child: const Text('戻る'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    }),
              ],
            ));
    notifyListeners();
  }

  Future fetchProfile() async {
    Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('profiles')
        .limit(1)
        .snapshots();

    userStream.listen((snapshot) {
      profile = Profile.fromFirestore(snapshot.docs[0]);
      notifyListeners();
    });
  }

  Future<void> fetchPosts(List<Favorite> favorites) async {
    Stream<QuerySnapshot> postsQuerySnapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('profiles')
        .doc(user!.uid)
        .collection('posts')
        .snapshots();

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

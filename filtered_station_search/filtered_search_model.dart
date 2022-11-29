import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/favorite.dart';
import '../domain/post.dart';

class FilteredSearchModel with ChangeNotifier {
  final trackLineController = TextEditingController();

  int? trackLineItemIndex;
  User? user = FirebaseAuth.instance.currentUser;
  List<Post> posts = [];
  List<Post> filteredPosts = [];
  List<Map<String, dynamic>> trackLineList = [];

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

  ///jsonからMap型のListに
  Future<void> trackLineConvertJson() async {
    String trackLineData =
        await rootBundle.loadString('assets/N02-20_Station.geojson');
    final jsonResponse = json.decode(trackLineData);

    for (int i = 0; i < 10260; i++) {
      trackLineList.add(jsonResponse['features'][i]['properties']['N02_003']);
    }
  }

  void notApplicableStationBar(BuildContext context) {
    const stationSnackBar = SnackBar(
        backgroundColor: Colors.orange, content: Text('該当する投稿が見つかりません'));

    ScaffoldMessenger.of(context).showSnackBar(stationSnackBar);
  }

  void filterPosts(BuildContext context) {
    filteredPosts = posts
        .where((e) => e.nearestStationInfo1 != null
            ? e.nearestStationInfo1!['station'] == trackLineController.text
            : false)
        .toList();

    if (filteredPosts.isEmpty) {
      notApplicableStationBar(context);
    }

    notifyListeners();
  }
}

//  List<Post> filteredPosts = [];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/favorite.dart';
import '../domain/post.dart';

class FilteredAreaModel with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  final searchAreaPrefController = TextEditingController();
  final searchAreaCityController = TextEditingController();

  List<Post> filteredAreaPosts = [];
  List<Post> posts = [];

  ///postsにデータベースから入れる
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

  ///CSVをList<List<dynamic>に変換するメソッド
  Future<List<List<dynamic>>> getAddressData() async {
    String csv = await rootBundle.loadString('assets/unique_zenkoku.csv');
    return const CsvToListConverter().convert(csv);
  }

  ///都道府県を選択する
  Future<void> selectPref(BuildContext context) async {
    final addressData = await getAddressData();
    final prefArray = addressData.map((e) => e[1]).toSet().toList();

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('戻る')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('決定'))
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (int index) {
                        searchAreaPrefController.text = prefArray[index];
                        searchAreaCityController.text = '';
                      },
                      children:
                          prefArray.map((e) => Text(e.toString())).toList()),
                ),
              ],
            ),
          );
        });
    notifyListeners();
  }

  ///市区町村を選択する
  Future<void> selectCity(BuildContext context) async {
    if (searchAreaPrefController.text == '') {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('先に都道府県を選択してください'),
              actions: [
                CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
      return;
    }

    final addressData = await getAddressData();

    final cityArray = addressData
        .where((element) => element[1] == searchAreaPrefController.text)
        .map((e) => e[2])
        .toSet()
        .toList();

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('戻る')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('決定'))
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (int index) {
                        searchAreaCityController.text = cityArray[index];
                      },
                      children:
                          cityArray.map((e) => Text(e.toString())).toList()),
                ),
              ],
            ),
          );
        });
  }

  void notApplicableStationBar(BuildContext context) {
    const stationSnackBar = SnackBar(
        backgroundColor: Colors.orange, content: Text('該当する投稿が見つかりません'));

    ScaffoldMessenger.of(context).showSnackBar(stationSnackBar);
  }

  Future<void> searchAddress(BuildContext context) async {
    filteredAreaPosts = posts
        .where((element) =>
            '${searchAreaPrefController.text}${searchAreaCityController.text}' ==
            '${element.prefecture}${element.city}')
        .toList();
    print(filteredAreaPosts);
    notifyListeners();

    if (filteredAreaPosts.isEmpty) {
      notApplicableStationBar(context);
    }
  }
}

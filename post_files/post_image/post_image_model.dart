import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main_select_page.dart';

class PostImageModel extends ChangeNotifier {
  String postId;
  PostImageModel(this.postId);
  User? user = FirebaseAuth.instance.currentUser;

  ///appBarから戻ろうとした時のDialog
  Future<void> confirmInterruptRegister(context, postId) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('登録を中止しますか？'),
            content: const Text('登録した内容は破棄されます'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('profiles')
                        .doc(user!.uid)
                        .collection('posts')
                        .doc(postId)
                        .delete();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainSelectPage()),
                        (route) => false);
                  })
            ],
          );
        });
  }

  ///前の画面に戻ろうとした時のDialog
  Future<bool> willPopCallback(BuildContext context, String postId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('登録を中止しますか？'),
            content: const Text('登録した内容は破棄されます'),
            actions: [
              CupertinoButton(
                  child: const Text('いいえ'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(
                  child: const Text('はい'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('profiles')
                        .doc(user!.uid)
                        .collection('posts')
                        .doc(postId)
                        .delete();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainSelectPage()),
                        (route) => false);
                  })
            ],
          );
        });
  }

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  List<String> exteriorPaths = <String>[];
  List<String> interiorPaths = <String>[];
  List<String> floorPlanPaths = <String>[];
  List<String> livingRoomPaths = <String>[];
  List<String> bedRoomPaths = <String>[];
  List<String> bathRoomPaths = <String>[];
  List<String> toiletPaths = <String>[];
  List<String> kitchenPaths = <String>[];
  List<String> shelvesPaths = <String>[];
  List<String> otherPaths = <String>[];

  final ImagePicker picker = ImagePicker();

  ///複数の写真を取得する関数
  Future<void> getImageFromGallery(
      {required List<String> pathList, required String text}) async {
    User? user = FirebaseAuth.instance.currentUser;
    final imageList = await picker.pickMultiImage(imageQuality: 99);
    List<dynamic> urlList = [];

    //List<XFile>の要素が選択済みかを確認
    if (imageList.isEmpty) {
      return;
    }

    //List<XFile>の要素を確認し、List<String>に変換する前にもともと入っているその要素に
    pathList.clear();

    //XFileの１つずつの要素のパスを取り出し、Listにしている
    for (var image in imageList) {
      if (pathList.length < 6) {
        pathList.add(image.path);
        notifyListeners();
      } else {
        pathList;
      }
    }
    //pathListにの要素をFile型に変換し、URLにしていく。
    for (var path in pathList) {
      final file = File(path);

      TaskSnapshot task = await FirebaseStorage.instance
          .ref(
              'users/${FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('profiles').doc(user.uid).collection('posts').doc().id}')
          .putFile(file);

      final imgURL = await task.ref.getDownloadURL();

      //URLをListに追加していく。
      urlList.add(imgURL);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('profiles')
        .doc(user.uid)
        .collection('posts')
        .doc(postId)
        .update({text: urlList});
  }

  ///pickerが走るボタン
  SizedBox pickButtonBox({
    required PostImageModel model,
    required List<String> pathList,
    required String text,
  }) {
    return SizedBox(
        height: 100,
        width: 300,
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () async {
                await getImageFromGallery(pathList: pathList, text: text);
              },
              label: const Text('写真を登録')),
        ));
  }

  ///GridViewのWidget
  GridView housePictureGridView(
      {required PostImageModel model, required List<String> pathList}) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pathList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(pathList[index])))));
        });
  }

  ///場所を表すTextのWidget
  Align placeText({String? place}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        place!,
        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> doneRegister(BuildContext context) async {
    if (exteriorPaths.isEmpty ||
        interiorPaths.isEmpty ||
        floorPlanPaths.isEmpty ||
        livingRoomPaths.isEmpty ||
        bedRoomPaths.isEmpty ||
        bathRoomPaths.isEmpty ||
        toiletPaths.isEmpty ||
        kitchenPaths.isEmpty ||
        shelvesPaths.isEmpty ||
        otherPaths.isEmpty) {
      return await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                '未入力の項目があります',
              ),
              actions: [
                CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
    startLoading();
    await Future.delayed(const Duration(seconds: 3));

    endLoading();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainSelectPage()),
        (_) => false);
  }
}

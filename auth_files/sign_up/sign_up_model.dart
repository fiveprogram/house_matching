import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main_select_page.dart';

class SignUpModel extends ChangeNotifier {
  final mailController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');

  bool isSecret = true;

  String? errorText;
  String? errorText1;

  bool isLoading = false;

  bool startLoading() {
    notifyListeners();
    return isLoading = true;
  }

  bool endLoading() {
    notifyListeners();
    return isLoading = false;
  }

  Future<void> trySignUp(BuildContext context) async {
    startLoading();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mailController.text, password: passController.text);
      User? user = userCredential.user;
      FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'email': mailController.text,
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profiles')
          .doc(user.uid)
          .set({
        'email': mailController.text,
        'name': '未登録',
        'imgURL': '',
        'uid': user.uid,
        'selfIntroduction': '未登録'
      });
      //
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .collection('profiles')
      //     .doc(user.uid)
      //     .collection('posts')
      //     .add({});

      notifyListeners();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainSelectPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorText = 'パスワードが短すぎます';
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        errorText1 = 'そのメールアドレスは既に使用されています';
        notifyListeners();
      } else if (e.code == 'invalid-email') {
        errorText1 = 'メールアドレスの形式が不適切です';
        notifyListeners();
      }
    } finally {
      endLoading();
    }
    notifyListeners();
  }
}

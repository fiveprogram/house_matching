import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final idController =
      TextEditingController(text: 'yuta.nanana.tennis@gmail.com');
  final passController = TextEditingController(text: '03Yuta16');

  bool isLoading = false;

  bool startLoading() {
    notifyListeners();
    return isLoading = true;
  }

  bool endLoading() {
    notifyListeners();
    return isLoading = false;
  }

  String? errorText;
  String? errorText1;

  Future<void> trySignIn() async {
    startLoading();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: idController.text, password: passController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorText = 'ユーザーが見つかりません';
        notifyListeners();
      } else if (e.code == 'wrong-password') {
        errorText1 = 'パスワードが違います';
        notifyListeners();
      } else if (e.code == 'user-disabled') {
        errorText1 = 'ユーザーが無効となっています';
        notifyListeners();
      }
    } finally {
      endLoading();
    }
    notifyListeners();
  }

  bool isSecret = true;
}

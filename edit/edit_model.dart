import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/profile.dart';

class EditModel extends ChangeNotifier {
  Profile profile;
  EditModel(this.profile) {
    if (profile.name != '') {
      nameController.text = profile.name!;
    }
    if (profile.selfIntroduction != '') {
      selfIntroduction.text = profile.selfIntroduction!;
    }
    mailController.text = user!.email!;

    if (profile.imgURL != '') {
      profileURL = profile.imgURL;
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final selfIntroduction = TextEditingController();

  String? profileURL;
  String? errorText;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    return notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    return notifyListeners();
  }

  ///pickImage
  final ImagePicker _picker = ImagePicker();
  File? file;
  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    file = File(image!.path);
    notifyListeners();
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    notifyListeners();
  }

  void selectPhoto(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          '写真を選択',
          style: TextStyle(fontSize: 18),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              getImageFromGallery();
              notifyListeners();
            },
            child: const Text('カメラロールから選択'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              getImageFromCamera();
              notifyListeners();
            },
            child: const Text('写真を撮る'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> sendProfile(BuildContext context) async {
    startLoading();

    try {
      if (nameController.text != '' ||
          mailController.text != '' ||
          selfIntroduction.text != '' && file == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('profiles')
            .doc(user!.uid)
            .set({
          'name': nameController.text,
          'address': mailController.text,
          'selfIntroduction': selfIntroduction.text,
          'imgURL': profileURL,
          'uid': user!.uid,
          'profileId': user!.uid
        });
      }
      if (nameController.text != '' ||
          mailController.text != '' ||
          selfIntroduction.text != '' && file != null) {
        final task = await FirebaseStorage.instance
            .ref(
                'users/${FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('profiles').doc().id}')
            .putFile(file!);
        final imgURL = await task.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('profiles')
            .doc(user!.uid)
            .set({
          'name': nameController.text,
          'email': mailController.text,
          'selfIntroduction': selfIntroduction.text,
          'imgURL': imgURL,
          'uid': user!.uid,
          'profileId': user!.uid
        });
        print(imgURL);

        notifyListeners();
      }
    } catch (e) {
      errorText = '全て空欄です';
    } finally {
      endLoading();
      Navigator.pop(context);
    }
  }
}

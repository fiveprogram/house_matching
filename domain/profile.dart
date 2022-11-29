import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? email;
  String? name;
  String? selfIntroduction;
  String? imgURL;
  String? uid;
  String? profileId;

  Profile(
      {this.email,
      this.name,
      this.selfIntroduction,
      this.imgURL,
      this.uid,
      this.profileId});
  //インスタンス生成メソッド(factoryコンストラクタ)
  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profile(
      email: data['email'],
      name: data['name'],
      selfIntroduction: data['selfIntroduction'],
      imgURL: data['imgURL'],
      uid: data['uid'],
      profileId: data['profileId'],
    );
  }
}

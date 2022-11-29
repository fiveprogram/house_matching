import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main_select_page.dart';
import '../post_image/post_image_page.dart';

class PostDetailModel with ChangeNotifier {
  final parkingController = TextEditingController(text: '4,000円');
  final amortizationMoneyController = TextEditingController(text: '60,000円');
  final contractTermController = TextEditingController(text: '2年');
  final securityDepositController = TextEditingController(text: '30,000円');
  final keyMoneyController = TextEditingController(text: '150,000円');
  final homeInsuranceController = TextEditingController(text: '要');
  final totalFloorController = TextEditingController(text: '12階建て');
  final floorController = TextEditingController(text: '３階');
  final housesController = TextEditingController(text: '40戸');
  final renewalFeeController = TextEditingController(text: '40,000円');
  final moveInDayController = TextEditingController(text: '即日');
  final appealController = TextEditingController(text: 'ペット可能');
  final nearestBuildingsController =
      TextEditingController(text: 'コンビニ 312m\nスーパー玉出240m');
  final remarkController = TextEditingController(
      text:
          '初期費用「賃貸補償要加入22,000円、定額クリーニング代70,000」、月額「保証料　月額総賃料2.2%または5.5%(ペット飼育時は月額総賃料2.2%)、サポート２４　330円（税込）'
          '2年毎に更新事務手数料11,000円。ペット飼育時は定額ルームクリー二ング代先払い。浄水器利用時別途カートリッジ代が必要（任意）');

  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  bool startLoading() {
    notifyListeners();
    return isLoading = true;
  }

  bool endLoading() {
    notifyListeners();
    return isLoading = false;
  }

  ///画面を前に戻らせないための関数
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

  final List<String> parkingPriceList = [
    '1,000円未満',
    '1,000円',
    '2,000円',
    '3,000円',
    '4,000円',
    '5,000円',
    '6,000円',
    '7,000円',
    '8,000円',
    '9,000円',
    '10,000円以上',
  ];

  final List<String> contractTermList = ['1年', '2年', '3年', '4年', '5年以上'];

  final List<String> homeInsuranceList = [
    '要',
    '不要',
  ];

  final List<String> totalFloorList = [
    '1階建て',
    '2階建て',
    '3階建て',
    '4階建て',
    '5階建て',
    '6階建て',
    '7階建て',
    '8階建て',
    '9階建て',
    '10階建て',
    '11階建て',
    '12階建て',
    '13階建て以上',
  ];

  final List<String> floorList = [
    '1階',
    '2階',
    '3階',
    '4階',
    '5階',
    '6階',
    '7階',
    '8階',
    '9階',
    '10階',
    '11階',
    '12階',
    '13階以上',
  ];

  int parkingPriceIndex = 0;
  int homeInsuranceIndex = 0;
  int contractTermIndex = 0;
  int totalFloorIndex = 0;
  int floorIndex = 0;

  Future<void> picker(
      {required BuildContext context,
      required TextEditingController pickerController,
      required List<String> pickerList,
      required int pickerIndex}) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('戻る')),
                    TextButton(
                        onPressed: () {
                          pickerController.text = pickerList[pickerIndex];
                          Navigator.pop(context);
                        },
                        child: const Text('決定')),
                    const Divider(),
                  ],
                ),
                Expanded(
                    child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    pickerIndex = index;
                    notifyListeners();
                  },
                  children: pickerList.map((e) => Text(e.toString())).toList(),
                ))
              ],
            ),
          );
        });
    notifyListeners();
  }

  Future<void> sendPostDetail(BuildContext context, String postId) async {
    User? user = FirebaseAuth.instance.currentUser;
    startLoading();

    try {
      if (securityDepositController.text.isEmpty ||
          keyMoneyController.text.isEmpty ||
          homeInsuranceController.text.isEmpty ||
          totalFloorController.text.isEmpty ||
          floorController.text.isEmpty ||
          housesController.text.isEmpty ||
          renewalFeeController.text.isEmpty ||
          moveInDayController.text.isEmpty ||
          appealController.text.isEmpty ||
          nearestBuildingsController.text.isEmpty ||
          remarkController.text.isEmpty) {
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('未入力の項目があります'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            });
      }
      if (securityDepositController.text.isNotEmpty &&
          keyMoneyController.text.isNotEmpty &&
          homeInsuranceController.text.isNotEmpty &&
          totalFloorController.text.isNotEmpty &&
          floorController.text.isNotEmpty &&
          housesController.text.isNotEmpty &&
          renewalFeeController.text.isNotEmpty &&
          moveInDayController.text.isNotEmpty &&
          appealController.text.isNotEmpty &&
          nearestBuildingsController.text.isNotEmpty &&
          remarkController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('profiles')
            .doc(user.uid)
            .collection('posts')
            .doc(postId)
            .update({
          'parking':
              parkingController.text.isNotEmpty ? parkingController.text : '_',
          'amortizationMoney': amortizationMoneyController.text.isNotEmpty
              ? amortizationMoneyController.text
              : '_',
          'contractionTerm': contractTermController.text.isNotEmpty
              ? contractTermController.text
              : '_',
          'securityDeposit': securityDepositController.text,
          'keyMoney': keyMoneyController.text,
          'homeInsurance': homeInsuranceController.text,
          'houses': housesController.text,
          'totalFloor': totalFloorController.text,
          'floor': floorController.text,
          'renewal': renewalFeeController.text,
          'moveInDay': moveInDayController.text,
          'appeal': appealController.text,
          'nearestBuildings': nearestBuildingsController.text,
          'remark': remarkController.text,
          'isFavorite': false,
          'postTime': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'postId': postId,
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostImagePage(postId: postId)));
      }
    } catch (e) {
      null;
    } finally {
      endLoading();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main_select_page.dart';
import '../post_detail/post_detail_page.dart';

class PostModel extends ChangeNotifier {
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
  Future<bool> willPopCallback(BuildContext context) async {
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
                  onPressed: () {
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

  final buildingController = TextEditingController(text: 'UR鈴の宮/３階');
  final priceController = TextEditingController(text: '6.3万円');
  final managementController = TextEditingController(text: '3,000円');
  final selectedPrefectureController = TextEditingController(text: '大阪府');
  final selectedCityController = TextEditingController(text: '大阪市福島区');
  final selectedTownController = TextEditingController(text: '玉川');
  final adressController = TextEditingController(text: '1-4');
  final floorPlanController = TextEditingController(text: '2LDK');
  final nearestStationController1 = TextEditingController(text: '高野線　千代田駅');
  final nearestStationController2 = TextEditingController();
  final nearestStationController3 = TextEditingController();
  final walkStationController1 = TextEditingController(text: '徒歩5分以内');
  final walkStationController2 = TextEditingController();
  final walkStationController3 = TextEditingController();
  final ageOfBuildingController = TextEditingController(text: '築5年以内');
  final buildingStructureController = TextEditingController(text: '鉄筋構造');
  final occupationAreaController = TextEditingController(text: '32.32㎡');
  final contactController =
      TextEditingController(text: '090-2838-6742 or yuta.na@gmail.com');
  final wayToContactController = TextEditingController(text: 'LineID');

  Future<void> confirmInterruptRegister(context) async {
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
                  onPressed: () {
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

  List<Map<String, dynamic>> nearestMapList = [];
  List<String> nearestStringList = [];

  List<String> wayToContactList = [
    'メールアドレス',
    '電話番号',
    'LineID',
    'instagramID',
    '複数指定'
  ];

  List<String> managePriceList = [
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
    '10,000円'
  ];
  List<String> priceList = [
    '2.0万円未満',
    '2.1万円',
    '2.2万円',
    '2.3万円',
    '2.4万円',
    '2.5万円',
    '2.6万円',
    '2.7万円',
    '2.8万円',
    '2.9万円',
    '3.0万円',
    '3.1万円',
    '3.2万円',
    '3.3万円',
    '3.4万円',
    '3.5万円',
    '3.6万円',
    '3.7万円',
    '3.8万円',
    '3.9万円',
    '4.0万円',
    '4.1万円',
    '4.2万円',
    '4.3万円',
    '4.4万円',
    '4.5万円',
    '4.6万円',
    '4.7万円',
    '4.8万円',
    '4.9万円',
    '5.0万円',
    '5.1万円',
    '5.2万円',
    '5.3万円',
    '5.4万円',
    '5.5万円',
    '5.6万円',
    '5.7万円',
    '5.8万円',
    '5.9万円',
    '6.0万円',
    '6.1万円',
    '6.2万円',
    '6.3万円',
    '6.4万円',
    '6.5万円',
    '6.6万円',
    '6.7万円',
    '6.8万円',
    '6.9万円',
    '7.0万円',
    '7.1万円',
    '7.2万円',
    '7.3万円',
    '7.4万円',
    '7.5万円',
    '7.6万円',
    '7.7万円',
    '7.8万円',
    '7.9万円',
    '8.0万円',
    '8.1万円',
    '8.2万円',
    '8.3万円',
    '8.4万円',
    '8.5万円',
    '8.6万円',
    '8.7万円',
    '8.8万円',
    '8.9万円',
    '9.0万円',
    '9.1万円',
    '9.2万円',
    '9.3万円',
    '9.4万円',
    '9.5万円',
    '9.6万円',
    '9.7万円',
    '9.8万円',
    '9.9万円',
    '10.0万円',
    '10.1万円',
    '10.2万円',
    '10.3万円',
    '10.4万円',
    '10.5万円',
    '10.6万円',
    '10.7万円',
    '10.8万円',
    '10.9万円',
    '11.0万円',
    '11.1万円',
    '11.2万円',
    '11.3万円',
    '11.4万円',
    '11.5万円',
    '11.6万円',
    '11.7万円',
    '11.8万円',
    '11.9万円',
    '12.0万円',
    '12.1万円',
    '12.2万円',
    '12.3万円',
    '12.4万円',
    '12.5万円',
    '12.6万円',
    '12.7万円',
    '12.8万円',
    '12.9万円',
    '13.0万円',
    '13.1万円',
    '13.2万円',
    '13.3万円',
    '13.4万円',
    '13.5万円',
    '13.6万円',
    '13.7万円',
    '13.8万円',
    '13.9万円',
    '14.0万円以上',
  ];

  List<String> floorPlanList = [
    'ワンルーム',
    '1k',
    '1DK',
    '1LDK',
    '2K',
    '2DK',
    '2LDK',
    '3K',
    '3DK',
    '3LDK',
    '4k',
    '4DK',
    '4LDK以上'
  ];
  List<String> walkTimeList = [
    '指定なし',
    '徒歩1分以内',
    '徒歩5分以内',
    '徒歩7分以内',
    '徒歩10分以内',
    '徒歩15分以内',
    '徒歩20分以内',
    '徒歩30分以内',
  ];

  List<String> ageOfBuildingList = [
    '指定なし',
    '新築',
    '築3年以内',
    '築5年以内',
    '築10年以内',
    '築15年以内',
    '築20年以内',
    '築30年以内',
  ];

  List<String> buildingStructureList = [
    '鉄筋系',
    '木造系',
    '鉄骨系',
    'ブロック・その他',
  ];

  int priceIndex = 0;
  int managePriceIndex = 0;
  int floorPlanIndex = 0;
  int walkTImeIndex = 0;
  int ageOfBuildingIndex = 0;
  int buildingStructureIndex = 0;
  int wayToContactIndex = 0;

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

  Future<List<List<dynamic>>> getAddressData() async {
    String csv = await rootBundle.loadString('assets/unique_zenkoku.csv');
    return const CsvToListConverter().convert(csv);
  }

  Future<void> prefecturePicker(BuildContext context) async {
    final addressData = await getAddressData();
    final prefArray = addressData.map((e) => e[1]).toSet().toList();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
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
                        Navigator.pop(context);
                      },
                      child: const Text('決定'))
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  onSelectedItemChanged: (item) {
                    selectedPrefectureController.text = prefArray[item];
                    selectedCityController.text = '';
                    selectedTownController.text = '';
                    notifyListeners();
                  },
                  itemExtent: 30,
                  children: prefArray.map((e) => Text(e)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> cityPicker(BuildContext context) async {
    final addressData = await getAddressData();
    final String pref = selectedPrefectureController.text;
    if (pref.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text('先に都道府県を選択して下さい'),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text('ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ));
    }
    final cityArray = addressData
        .where((element) {
          return element[1] == pref;
        })
        .map((e) => e[2])
        .toList();
    final uniqueCityArray = cityArray.toSet().toList();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
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
                        Navigator.pop(context);
                      },
                      child: const Text('決定'))
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  onSelectedItemChanged: (item) {
                    selectedCityController.text = uniqueCityArray[item];
                    selectedTownController.text = '';
                    notifyListeners();
                  },
                  itemExtent: 30,
                  children: uniqueCityArray.map((e) => Text(e)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> townPicker(BuildContext context) async {
    final addressData = await getAddressData();
    final String pref = selectedPrefectureController.text;
    final String city = selectedCityController.text;
    if (pref.isEmpty || city.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text('先に市区町村を選択して下さい'),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text('ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ));

      ///佐藤を２週間止める

    }
    final townArray = addressData
        .where((element) => element[1] == pref && element[2] == city)
        .map((e) => e[3])
        .toList();
    final uniqueCityArray = townArray.toSet().toList();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
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
                        Navigator.pop(context);
                      },
                      child: const Text('決定'))
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  onSelectedItemChanged: (item) {
                    selectedTownController.text = uniqueCityArray[item];
                    notifyListeners();
                  },
                  itemExtent: 30,
                  children: uniqueCityArray.map((e) => Text(e)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> postHome(BuildContext context) async {
    startLoading();
    try {
      if (buildingController.text.isEmpty ||
          priceController.text.isEmpty ||
          managementController.text.isEmpty ||
          selectedPrefectureController.text.isEmpty ||
          selectedCityController.text.isEmpty ||
          selectedTownController.text.isEmpty ||
          adressController.text.isEmpty ||
          floorPlanController.text.isEmpty ||
          occupationAreaController.text.isEmpty ||
          nearestStationController1.text.isEmpty ||
          walkStationController1.text.isEmpty ||
          buildingStructureController.text.isEmpty ||
          ageOfBuildingController.text.isEmpty) {
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

      if (buildingController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          managementController.text.isNotEmpty &&
          selectedPrefectureController.text.isNotEmpty &&
          selectedCityController.text.isNotEmpty &&
          selectedTownController.text.isNotEmpty &&
          adressController.text.isNotEmpty &&
          floorPlanController.text.isNotEmpty &&
          occupationAreaController.text.isNotEmpty &&
          nearestStationController1.text.isNotEmpty &&
          walkStationController1.text.isNotEmpty &&
          buildingStructureController.text.isNotEmpty &&
          ageOfBuildingController.text.isNotEmpty &&
          contactController.text.isNotEmpty) {
        final addedPostData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('profiles')
            .doc(user!.uid)
            .collection('posts')
            .add({
          'building': buildingController.text,
          'price': priceController.text,
          'management': managementController.text,
          'prefecture': selectedPrefectureController.text,
          'city': selectedCityController.text,
          'town': selectedTownController.text,
          'address': adressController.text,
          'floorPlan': floorPlanController.text,
          'occupationArea': occupationAreaController.text,
          'nearestStationInfo1': {
            'station': nearestStationController1.text,
            'walkStation': walkStationController1.text
          },
          'nearestStationInfo2': {
            'station': nearestStationController2.text.isNotEmpty &&
                    walkStationController2.text.isNotEmpty
                ? nearestStationController2.text
                : null,
            'walkStation': nearestStationController2.text.isNotEmpty &&
                    walkStationController2.text.isNotEmpty
                ? walkStationController2.text
                : null
          },
          'nearestStationInfo3': {
            'station': nearestStationController3.text.isNotEmpty &&
                    walkStationController3.text.isNotEmpty
                ? nearestStationController3.text
                : null,
            'walkStation': nearestStationController3.text.isNotEmpty &&
                    walkStationController3.text.isNotEmpty
                ? walkStationController3.text
                : null
          },
          'buildingStructure': buildingStructureController.text,
          'ageOfBuilding': ageOfBuildingController.text,
          'contact': contactController.text
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PostDetailPage(postId: addedPostData.id)));
      }
      notifyListeners();
    } catch (e) {
      null;
    } finally {
      endLoading();
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_matching/post_files/post/post_model.dart';

import 'package:provider/provider.dart';

import '../../domain/picker.dart';
import '../register_nearest_station/register_nearest_station_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () {
          return model.willPopCallback(context);
        },
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: () {
                      model.confirmInterruptRegister(context);
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                title: const Text('新規投稿')),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        '基本情報（所要時間10分/全3ページ）',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      regularText(text1: '▷建築物名'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: model.buildingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '建築物名',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                      regularText(text1: '▷１ヶ月あたりの家賃'),
                      const SizedBox(height: 10),
                      PickerFormField(
                          pickerController: model.priceController,
                          hintText: '１ヶ月あたりの家賃',
                          picker: () {
                            model.picker(
                                context: context,
                                pickerController: model.priceController,
                                pickerList: model.priceList,
                                pickerIndex: model.priceIndex);
                          }),
                      const SizedBox(height: 30),
                      regularText(text1: '▷１ヶ月あたりの共益費'),
                      const SizedBox(height: 10),
                      PickerFormField(
                          pickerController: model.managementController,
                          hintText: '１ヶ月あたりの共益費',
                          picker: () {
                            model.picker(
                                context: context,
                                pickerController: model.managementController,
                                pickerList: model.managePriceList,
                                pickerIndex: model.managePriceIndex);
                          }),
                      const SizedBox(height: 30),
                      regularText(text1: '▷住所'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 2),
                          Expanded(
                            child: TextFormField(
                              onTap: () => model.prefecturePicker(context),
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                      Icons.arrow_drop_down_circle_outlined),
                                  border: OutlineInputBorder(),
                                  hintText: '都道府県'),
                              readOnly: true,
                              controller: model.selectedPrefectureController,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: TextFormField(
                              onTap: () => model.cityPicker(context),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: '市区'),
                              readOnly: true,
                              controller: model.selectedCityController,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: TextFormField(
                              onTap: () => model.townPicker(context),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: '町村'),
                              readOnly: true,
                              controller: model.selectedTownController,
                            ),
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                      const SizedBox(height: 30),
                      regularText(text1: '▷番地　*ハイフン(-)は半角'),
                      const SizedBox(height: 10),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,-]')),
                        ],
                        controller: model.adressController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '番地　〇〇-〇〇',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                      regularText(text1: '▷間取り'),
                      const SizedBox(height: 10),
                      PickerFormField(
                          pickerController: model.floorPlanController,
                          hintText: '間取り',
                          picker: () {
                            model.picker(
                                context: context,
                                pickerController: model.floorPlanController,
                                pickerList: model.floorPlanList,
                                pickerIndex: model.floorPlanIndex);
                          }),
                      const SizedBox(height: 30),
                      regularText(text1: '▷占有面積'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: model.occupationAreaController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '〇〇.〇〇㎡',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                      regularText(text1: '▷最寄駅(最大3駅)+駅徒歩分'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          selectNearestStations(
                              context, model, model.nearestStationController1),
                          Expanded(
                            child: PickerFormField(
                                pickerController: model.walkStationController1,
                                hintText: '駅徒歩分',
                                picker: () {
                                  model.picker(
                                      context: context,
                                      pickerController:
                                          model.walkStationController1,
                                      pickerList: model.walkTimeList,
                                      pickerIndex: model.walkTImeIndex);
                                }),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          selectNearestStations(
                              context, model, model.nearestStationController2),
                          Expanded(
                            child: PickerFormField(
                                pickerController: model.walkStationController2,
                                hintText: '駅徒歩分',
                                picker: () {
                                  model.picker(
                                      context: context,
                                      pickerController:
                                          model.walkStationController2,
                                      pickerList: model.walkTimeList,
                                      pickerIndex: model.walkTImeIndex);
                                }),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          selectNearestStations(
                              context, model, model.nearestStationController3),
                          Expanded(
                            child: PickerFormField(
                                pickerController: model.walkStationController3,
                                hintText: '駅徒歩分',
                                picker: () {
                                  model.picker(
                                      context: context,
                                      pickerController:
                                          model.walkStationController3,
                                      pickerList: model.walkTimeList,
                                      pickerIndex: model.walkTImeIndex);
                                }),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      regularText(text1: '▷築年数'),
                      const SizedBox(height: 10),
                      PickerFormField(
                          pickerController: model.ageOfBuildingController,
                          hintText: '~年',
                          picker: () {
                            model.picker(
                                context: context,
                                pickerController: model.ageOfBuildingController,
                                pickerList: model.ageOfBuildingList,
                                pickerIndex: model.ageOfBuildingIndex);
                          }),
                      const SizedBox(height: 30),
                      regularText(text1: '▷建物構造'),
                      const SizedBox(height: 10),
                      PickerFormField(
                          pickerController: model.buildingStructureController,
                          hintText: '建物構造',
                          picker: () {
                            model.picker(
                                context: context,
                                pickerController:
                                    model.buildingStructureController,
                                pickerList: model.buildingStructureList,
                                pickerIndex: model.buildingStructureIndex);
                          }),
                      const SizedBox(height: 30),
                      regularText(text1: '▷連絡手段'),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200,
                          child: PickerFormField(
                              pickerController: model.wayToContactController,
                              hintText: '連絡手段',
                              picker: () {
                                model.picker(
                                    context: context,
                                    pickerController:
                                        model.wayToContactController,
                                    pickerList: model.wayToContactList,
                                    pickerIndex: model.wayToContactIndex);
                              }),
                        ),
                      ),
                      TextFormField(
                        maxLines: null,
                        controller: model.contactController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              '電話番号 or LineID orメールアドレス or instagramID or 複数',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            model.postHome(context);
                          },
                          label: const Text('詳細を登録')),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            )),
      );
    });
  }

  Align selectNearestStations(
      BuildContext context, PostModel model, TextEditingController controller) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 230,
        child: TextFormField(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>
                        const RegisterNearestStationPage())).then((value) {
              final List<String> textList = [];
              final List<Map<String, dynamic>> mapList = [];

              if (value == null) {
                return const CircularProgressIndicator();
              }

              if (value != null) {
                print(value.runtimeType);
                mapList.add(value[0]);
                model.nearestMapList.add(value[0]);

                print(model.nearestMapList);
                print(mapList);

                for (int i = 0; i < mapList.length; i++) {
                  textList.add(
                      '${mapList[i]['trackLines']} ${mapList[i]['stations']}駅');

                  controller.text = textList.join('\n');
                }
              }
            });
          },
          readOnly: true,
          maxLines: 1,
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: '・〇〇線　〇〇駅',
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }

  Row regularText({required String text1, bool isOptional = false}) {
    return Row(
      children: [
        const SizedBox(width: 6),
        Text(
          text1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(width: 20),
        isOptional
            ? Container(
                color: Colors.blueGrey,
                child: const Text(
                  ' 任意 ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

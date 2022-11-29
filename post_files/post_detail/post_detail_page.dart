import 'package:flutter/material.dart';
import 'package:house_matching/post_files/post_detail/post_detail_model.dart';

import 'package:provider/provider.dart';

import '../../domain/picker.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, required this.postId}) : super(key: key);
  final String postId;
  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () {
          return model.willPopCallback(context, widget.postId);
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    model.confirmInterruptRegister(context, widget.postId);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              title: const Text('新規投稿')),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      '（2/3ページ目）',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    regularText(text1: '▷駐車場の料金', isOptional: true),
                    const SizedBox(height: 10),
                    PickerFormField(
                        pickerController: model.parkingController,
                        hintText: '駐車場',
                        picker: () {
                          model.picker(
                              context: context,
                              pickerController: model.parkingController,
                              pickerList: model.parkingPriceList,
                              pickerIndex: model.parkingPriceIndex);
                        }),
                    const SizedBox(height: 30),
                    regularText(text1: '▷保証金/敷金・償却金(自由入力)', isOptional: true),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: model.amortizationMoneyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〇〇円',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷契約期間', isOptional: true),
                    const SizedBox(height: 10),
                    PickerFormField(
                        pickerController: model.contractTermController,
                        hintText: '契約年数',
                        picker: () {
                          model.picker(
                              context: context,
                              pickerController: model.contractTermController,
                              pickerList: model.contractTermList,
                              pickerIndex: model.contractTermIndex);
                        }),
                    const SizedBox(height: 30),
                    regularText(text1: '▷敷金/礼金(自由入力)'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        Expanded(
                          child: TextFormField(
                            controller: model.securityDepositController,

                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: '〇〇円'),
                            // controller: model.selectedCityController,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: TextFormField(
                            controller: model.keyMoneyController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: '〇〇円'),
                          ),
                        ),
                        const SizedBox(width: 2),
                      ],
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷住宅保険'),
                    const SizedBox(height: 10),
                    PickerFormField(
                        pickerController: model.homeInsuranceController,
                        hintText: '要or不要',
                        picker: () {
                          model.picker(
                              context: context,
                              pickerController: model.homeInsuranceController,
                              pickerList: model.homeInsuranceList,
                              pickerIndex: model.homeInsuranceIndex);
                        }),
                    const SizedBox(height: 30),
                    regularText(text1: '▷総戸数(自由入力)'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: model.housesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〇〇戸',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷所在階/階数'),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        Expanded(
                            child: PickerFormField(
                                pickerController: model.totalFloorController,
                                hintText: '〇〇階建て',
                                picker: () {
                                  model.picker(
                                      context: context,
                                      pickerController:
                                          model.totalFloorController,
                                      pickerList: model.totalFloorList,
                                      pickerIndex: model.totalFloorIndex);
                                })),
                        const SizedBox(width: 2),
                        Expanded(
                            child: PickerFormField(
                                pickerController: model.floorController,
                                hintText: '〇〇階',
                                picker: () {
                                  model.picker(
                                      context: context,
                                      pickerController: model.floorController,
                                      pickerList: model.floorList,
                                      pickerIndex: model.floorIndex);
                                })),
                        const SizedBox(width: 2),
                      ],
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷更新料(自由入力)'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: model.renewalFeeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '〇〇円',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷入居可能時期(自由入力)'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: model.moveInDayController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '即日or~ヶ月後',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷近くの建物'),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: model.nearestBuildingsController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '・コンビニ230m\n・スーパー190m\n・一蘭900m\n・小学校1500m',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷アピールポイント'),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: model.appealController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '・バス・トイレ別\n・ペット相談可\n・追い焚き\n・二人入居可など',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    regularText(text1: '▷備考'),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: model.remarkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            '初期費用「賃貸補償要加入22,000円、定額クリーニング代70,000」、月額「保証料　月額総賃料2.2%または5.5%(ペット飼育時は月額総賃料2.2%)、サポート２４　330円（税込）'
                            '2年毎に更新事務手数料11,000円。',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          model.sendPostDetail(context, widget.postId);
                        },
                        label: const Text('完了')),
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
                )
            ],
          ),
        ),
      );
    });
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

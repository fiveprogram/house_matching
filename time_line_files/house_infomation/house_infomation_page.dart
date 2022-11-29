import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../../domain/post.dart';
import '../../domain/profile.dart';
import '../../map/map_page.dart';
import '../../owner_info/owner_info_page.dart';
import 'house_information_model.dart';

// ignore: must_be_immutable
class HouseInformationPage extends StatefulWidget {
  Post post;
  Profile? profile;
  HouseInformationPage({required this.post, required this.profile, Key? key})
      : super(key: key);

  @override
  State<HouseInformationPage> createState() => _HouseInformationPageState();
}

class _HouseInformationPageState extends State<HouseInformationPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HouseInformationModel>(
      create: (_) => HouseInformationModel(post: widget.post)
        ..getLatlng()
        ..gatherList(),
      child: Scaffold(
        body: Consumer<HouseInformationModel>(builder: (context, model, child) {
          Post post = widget.post;
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CarouselSlider.builder(
                          itemCount: model.allList.length,
                          itemBuilder: (context, int index, int pageViewIndex) {
                            String path = model.allList[index];
                            return buildImage(path, index);
                          },
                          carouselController: model.buttonCarouselController,
                          options: CarouselOptions(
                              height: 300,
                              initialPage: 0,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  model.activeIndex = index;
                                });
                              })),
                      Positioned(
                          left: 20,
                          bottom: 120,
                          child: IconButton(
                            onPressed: () {
                              model.changePreviousPage();
                            },
                            icon: const Icon(
                              Icons.arrow_circle_left,
                              size: 50,
                            ),
                          )),
                      Positioned(
                          right: 20,
                          bottom: 120,
                          child: IconButton(
                            onPressed: () {
                              model.changeNextPage();
                            },
                            icon: const Icon(
                              Icons.arrow_circle_right,
                              size: 50,
                            ),
                          )),
                      Positioned(
                          left: 10,
                          top: 10,
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white54,
                            ),
                            child: Center(
                              child: Text(
                                '${model.activeIndex + 1}/${model.allList.length}',
                                style: const TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  model.buildIndicator(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '🌟${post.building!}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(post.price!,
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      Text('(他：管理費等${post.management!})',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Text('敷:${post.securityDeposit}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      Text('礼:${post.securityDeposit}',
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('☆物件概要',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      '「仲介手数料(家賃１ヶ月+消費税)の半額の金額で契約を結んでいただくことができます。お部屋のご案内も無料です',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  houseInfoRow(
                      icon: Icons.pin_drop_sharp,
                      post: post,
                      info: post.prefecture! +
                          post.city! +
                          post.town! +
                          post.address!),
                  const SizedBox(height: 20),
                  houseInfoRow(
                      post: post,
                      icon: Icons.train,
                      info:
                          '${post.nearestStationInfo1!['station']} ${post.nearestStationInfo1!['walkStation']}'),
                  const SizedBox(height: 20),
                  houseInfoRow(
                      post: post,
                      icon: Icons.map,
                      info: post.nearestBuildings!),
                  const SizedBox(height: 20),
                  if (model.kGooglePlex != null)
                    Stack(
                      children: [
                        SizedBox(
                          height: 250,
                          width: 400,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            markers: model.setAddress(),
                            initialCameraPosition: model.kGooglePlex!,
                            onMapCreated: (GoogleMapController controller) {
                              if (!model.mapController.isCompleted) {
                                const CircularProgressIndicator();
                              }
                              model.mapController.complete(controller);
                            },
                          ),
                        ),
                        Container(
                          color: Colors.black26,
                          height: 250,
                          width: 400,
                        ),
                        Positioned(
                          right: 150,
                          bottom: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.orange, //ボタンの背景色
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MapPage(post: post)));
                              },
                              child: const Text('マップを見る')),
                        )
                      ],
                    ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '＊一部ストーリービュー対応',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: houseInfoListTile(
                        post: post,
                        text: post.contact!,
                        content: '連絡先',
                        tileColor: Colors.white),
                  ),
                  houseInfoListTile(
                      post: post,
                      text: post.amortizationMoney!,
                      content: '償却費',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: post.ageOfBuilding!,
                      content: '築年数',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.buildingStructure!,
                      content: '建物構造',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: post.floorPlan!,
                      content: '間取り',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.occupationArea!,
                      content: '占有面積',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: '${post.floor}/${post.totalFloor}',
                      content: '所在階/階数',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.houses!,
                      content: '総戸数',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: post.parking!,
                      content: '駐車場',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.moveInDay!,
                      content: '入居可能日',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: '${post.floor}/${post.totalFloor}',
                      content: '所在階/階数',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.renewal!,
                      content: '更新料',
                      tileColor: Colors.grey),
                  houseInfoListTile(
                      post: post,
                      text: post.contractionTerm!,
                      content: '契約期間',
                      tileColor: Colors.white),
                  houseInfoListTile(
                      post: post,
                      text: post.homeInsurance!,
                      content: '住宅保険',
                      tileColor: Colors.grey),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white54)),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          const SizedBox(width: 130, child: Text('備考')),
                          Expanded(
                            child: Text(
                              post.remark!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(thickness: 1),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('☆アピールポイント',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '　${post.appeal!}',
                        style: const TextStyle(fontSize: 17),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OwnerInfoPage(
                                      profile: widget.profile!,
                                      post: post,
                                    )));
                      },
                      child: const Text('オーナー情報を確認')),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Container houseInfoListTile(
      {required Post post,
      required Color tileColor,
      required String content,
      required String text}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: tileColor, border: Border.all(color: Colors.white54)),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SizedBox(width: 130, child: Text(content)),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Row houseInfoRow(
      {required Post post, required IconData icon, required String info}) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(icon, color: Colors.orange),
        const SizedBox(width: 10),
        Text(info),
      ],
    );
  }

  Widget buildImage(String path, int index) {
    return Container(
      color: Colors.orange,
      margin: const EdgeInsets.symmetric(horizontal: 13),
      child: Image.network(
        path,
        fit: BoxFit.fill,
      ),
    );
  }
}

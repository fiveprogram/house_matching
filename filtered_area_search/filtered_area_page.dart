import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/post.dart';
import '../domain/profile.dart';
import '../time_line_files/house_infomation/house_infomation_page.dart';
import 'filtered_area_model.dart';

class FilteredAreaPage extends StatefulWidget {
  const FilteredAreaPage({Key? key}) : super(key: key);

  @override
  State<FilteredAreaPage> createState() => _FilteredAreaPageState();
}

class _FilteredAreaPageState extends State<FilteredAreaPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilteredAreaModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
            title: const Text(
          '住所検索',
          style: TextStyle(
              color: Colors.orange, fontSize: 30, fontWeight: FontWeight.bold),
        )),
        body: Column(
          children: [
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '都道府県',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onTap: () {
                      model.selectPref(context);
                    },
                    readOnly: true,
                    controller: model.searchAreaPrefController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      hintText: '都道府県',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      model.selectCity(context);
                    },
                    readOnly: true,
                    controller: model.searchAreaCityController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      hintText: '市区町村',
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  model.searchAddress(context);
                },
                child: const Text('検索する')),
            const Divider(),

            ///条件に合う投稿があれば、popと同時に表示
            if (model.filteredAreaPosts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.filteredAreaPosts.length,
                  itemBuilder: ((context, index) {
                    Post post = model.filteredAreaPosts[index];

                    final profilePath = post.ref.parent.parent!.snapshots();
                    Profile? profile;

                    profilePath.listen((doc) {
                      profile = Profile.fromFirestore(doc);
                    });

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => HouseInformationPage(
                                      post: post,
                                      profile: profile,
                                    ))));
                      },
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '投稿日：${post.postTime!}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  postHousePictures(
                                      post: post,
                                      pictureList: post.exteriorList!),
                                  postHousePictures(
                                      post: post,
                                      pictureList: post.interiorList!),
                                  postHousePictures(
                                      post: post,
                                      pictureList: post.floorPlanList!),
                                  postHousePictures(
                                      post: post,
                                      pictureList: post.livingRoomList!),
                                ],
                              ),
                            ),
                            const Divider(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    '🌟${post.building!}',
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  StarButton(
                                    isStarred: post.isFavorite,
                                    valueChanged: (bool isFavorite) async {
                                      print(isFavorite);
                                      //もし、お気に入り登録されたら
                                      if (isFavorite) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(model.user!.uid)
                                            .collection('favorites')
                                            .doc(post.ref.id)
                                            .set({
                                          'postPath': post.ref,
                                        });
                                      }
                                      //もし、お気に入り登録を外されたら
                                      if (!isFavorite) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(model.user!.uid)
                                            .collection('favorites')
                                            .doc(post.ref.id)
                                            .delete();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  infoText(
                                      post: post,
                                      text: post.nearestStationInfo1![
                                                  'station']! !=
                                              null
                                          ? '${post.nearestStationInfo1!['station']!}  ${post.nearestStationInfo1!['walkStation']!}'
                                          : ''),
                                  const SizedBox(width: 20),
                                  if (post.nearestStationInfo2!['station'] !=
                                      null)
                                    infoText(
                                        post: post,
                                        text:
                                            '${post.nearestStationInfo2!['station']!} ${post.nearestStationInfo2!['walkStation']!}'),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  infoText(post: post, text: post.prefecture!),
                                  infoText(post: post, text: post.city!),
                                  infoText(post: post, text: post.town!),
                                  infoText(post: post, text: post.address!),
                                ],
                              ),
                            ),
                            if (post.totalFloor != null || post.floor != null)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    infoText(
                                        post: post, text: post.ageOfBuilding!),
                                    const SizedBox(width: 20),
                                    infoText(
                                        post: post, text: post.totalFloor!),
                                    infoText(
                                        post: post, text: '/${post.floor!}'),
                                  ],
                                ),
                              ),
                            const Divider(),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            '${post.floorPlanList![0]}',
                                            scale: 4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(post.price!,
                                              style: const TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold)),
                                          Text('(他:管理費等${post.management!})',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                      if (post.totalFloor != null ||
                                          post.floor != null)
                                        Row(
                                          children: [
                                            Text(post.floor!,
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                            const SizedBox(width: 20),
                                            Text(post.floorPlan!,
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                            const SizedBox(width: 20),
                                            Text('${post.occupationArea}',
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                          ],
                                        ),
                                      if (post.securityDeposit != null ||
                                          post.keyMoney != null)
                                        Row(
                                          children: [
                                            Text('敷:${post.securityDeposit}',
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                            const SizedBox(width: 5),
                                            Text('礼:${post.keyMoney}',
                                                overflow: TextOverflow.clip,
                                                style: const TextStyle(
                                                    fontSize: 20)),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    );
                  }),
                ),
              ),
            if (model.filteredAreaPosts.isEmpty)
              Column(
                children: const [
                  SizedBox(height: 80),
                  Text(
                    'テキストフォームより入力してください',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              )
          ],
        ),
      );
    });
  }
}

Container postHousePictures(
    {required Post post, required List<dynamic> pictureList}) {
  return Container(
    height: 180,
    width: 180,
    decoration: BoxDecoration(
      color: Colors.grey,
      image: DecorationImage(
        fit: BoxFit.fill,
        image: NetworkImage('${pictureList[0]}', scale: 4),
      ),
    ),
  );
}

Text infoText({required Post post, required String text}) {
  return Text(text, style: const TextStyle(fontSize: 20));
}

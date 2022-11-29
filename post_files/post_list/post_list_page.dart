import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_matching/post_files/post_list/post_list_model.dart';

import 'package:provider/provider.dart';

import '../../domain/post.dart';
import '../../domain/profile.dart';
import '../../time_line_files/house_infomation/house_infomation_page.dart';
import '../post/post_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '投稿履歴',
          style: TextStyle(
              color: Colors.orange, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<PostListModel>(builder: (context, model, child) {
        if (model.posts == null) {
          return const CircularProgressIndicator();
        }
        return model.posts!.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: model.posts!.length,
                itemBuilder: ((context, index) {
                  Post post = model.posts![index];

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
                                    text:
                                        '${post.nearestStationInfo1!['station']!}  ${post.nearestStationInfo1!['walkStation']!}'),
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
                                  infoText(post: post, text: post.totalFloor!),
                                  infoText(post: post, text: '/${post.floor!}'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    )),
                  );
                }),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    Text(
                      '物件情報の登録',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '(下記を把握した上で登録を開始してください)',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(thickness: 1),
                    SizedBox(height: 20),
                    Text(
                      '🌟登録には下記項目情報が必須です',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '・建築物名・月家賃・共益費・住所\n・間取り・占有面積・最寄駅\n・駅徒歩分・築年数・建物構造\n・敷金・礼金・住宅保険の有無'
                      '\n・総戸数・所在階・更新料\n・入居可能時期・近くの建物\n・アピールポイント・備考',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1),
                    SizedBox(height: 20),
                    Text(
                      '🌟登録には下記の写真が必要です\n\n (各上限６枚)\n・外観・内装・間取り図\n・居間・寝室\n・風呂・トイレ・キッチン\n・収納・その他',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
      }),
      floatingActionButton:
          Consumer<PostListModel>(builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Text('すでに登録しましたか？'),
                        title: const Text('物件情報の登録にはプロフィール情報が必要です？'),
                        actions: [
                          CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('戻る')),
                          CupertinoButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PostPage()));
                              },
                              child: const Text('はい'))
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.add,
              )),
        );
      }),
    );
  }
}

Text infoText({required Post post, required String text}) {
  return Text(text, style: const TextStyle(fontSize: 20));
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../domain/post.dart';
import '../domain/profile.dart';
import 'owner_info_model.dart';

// ignore: must_be_immutable
class OwnerInfoPage extends StatefulWidget {
  Profile? profile;
  Post? post;
  OwnerInfoPage({required this.profile, required this.post, Key? key})
      : super(key: key);

  @override
  State<OwnerInfoPage> createState() => _OwnerInfoPageState();
}

class _OwnerInfoPageState extends State<OwnerInfoPage> {
  @override
  Widget build(BuildContext context) {
    ///PostインスタンスとProfileインスタンスより、Postsを作成中

    Profile profile = widget.profile!;
    Post post = widget.post!;

    return ChangeNotifierProvider<OwnerInfoModel>(
      create: (_) => OwnerInfoModel(post)..fetchFavorite(),
      child: Consumer<OwnerInfoModel>(builder: (context, model, child) {
        print(post.prefecture);
        return Scaffold(
            appBar: AppBar(
              title: Text(
                profile.name ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (profile.imgURL != null)
                          CircleAvatar(
                              radius: 64,
                              backgroundImage: profile.imgURL != ''
                                  ? NetworkImage(profile.imgURL!)
                                  : const AssetImage('image/download.jpg')
                                      as ImageProvider),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: const Text(
                              'プロフィール一覧',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 23),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      profile.name != '' ? profile.name! : '未登録',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Divider(),
                    const Text(
                      '▷自己紹介',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      profile.selfIntroduction != ''
                          ? profile.selfIntroduction!
                          : '未登録',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(),
                    const Text(
                      '連絡先',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.wayToContact!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      post.contact!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(),
                    const Text(
                      '貸し出し物件履歴',
                      style: TextStyle(fontSize: 18),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.posts.length,
                      itemBuilder: ((context, index) {
                        final profilePath = post.ref.parent.parent!.snapshots();

                        profilePath.listen((doc) {
                          profile = Profile.fromFirestore(doc);
                        });

                        return Card(
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
                                                'station']! +
                                            post.nearestStationInfo1![
                                                'walkStation']!),
                                    const SizedBox(width: 20),
                                    if (post.nearestStationInfo2!['station'] !=
                                        null)
                                      infoText(
                                          post: post,
                                          text: post.nearestStationInfo2![
                                                  'station']! +
                                              post.nearestStationInfo2![
                                                  'walkStation']!),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    infoText(
                                        post: post, text: post.prefecture!),
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
                                          post: post,
                                          text: post.ageOfBuilding!),
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
                                    FittedBox(
                                      fit: BoxFit.fill,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${post.floorPlanList![0]}',
                                                scale: 4),
                                          ),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                        ));
                      }),
                    ),
                  ],
                ),
              ),
            ])));
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

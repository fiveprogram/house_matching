import 'package:flutter/material.dart';
import 'package:house_matching/post_files/post_image/post_image_model.dart';
import 'package:provider/provider.dart';

class PostImagePage extends StatefulWidget {
  String postId;
  PostImagePage({required this.postId, Key? key}) : super(key: key);

  @override
  State<PostImagePage> createState() => _PostImagePageState();
}

class _PostImagePageState extends State<PostImagePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostImageModel>(
      create: (_) => PostImageModel(widget.postId),
      child: Consumer<PostImageModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () {
            return model.willPopCallback(context, widget.postId);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('画像登録', style: TextStyle(fontSize: 25)),
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    model.confirmInterruptRegister(context, widget.postId);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        model.placeText(place: '外観(上限６枚)'),
                        if (model.exteriorPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.exteriorPaths),
                        model.pickButtonBox(
                          text: 'exteriorList',
                          model: model,
                          pathList: model.exteriorPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '内装(上限６枚)'),
                        if (model.interiorPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.interiorPaths),
                        model.pickButtonBox(
                          text: 'interiorList',
                          model: model,
                          pathList: model.interiorPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '間取り(上限６枚)'),
                        if (model.floorPlanPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.floorPlanPaths),
                        model.pickButtonBox(
                          text: 'floorPlanList',
                          model: model,
                          pathList: model.floorPlanPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '居間(上限6枚)'),
                        if (model.livingRoomPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.livingRoomPaths),
                        model.pickButtonBox(
                          text: 'livingRoomList',
                          model: model,
                          pathList: model.livingRoomPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '寝室(上限６枚)'),
                        if (model.bedRoomPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.bedRoomPaths),
                        model.pickButtonBox(
                          text: 'bedRoomList',
                          model: model,
                          pathList: model.bedRoomPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '風呂(上限６枚)'),
                        if (model.bathRoomPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.bathRoomPaths),
                        model.pickButtonBox(
                          text: 'bathRoomList',
                          model: model,
                          pathList: model.bathRoomPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: 'トイレ(上限６枚)'),
                        if (model.toiletPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.toiletPaths),
                        model.pickButtonBox(
                          text: 'toiletList',
                          model: model,
                          pathList: model.toiletPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: 'キッチン(上限６枚)'),
                        if (model.kitchenPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.kitchenPaths),
                        model.pickButtonBox(
                          text: 'kitchenList',
                          model: model,
                          pathList: model.kitchenPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: '収納(上限６枚)'),
                        if (model.shelvesPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.shelvesPaths),
                        model.pickButtonBox(
                          text: 'shelvesList',
                          model: model,
                          pathList: model.shelvesPaths,
                        ),
                        const Divider(thickness: 2),
                        model.placeText(place: 'その他(上限６枚)'),
                        if (model.otherPaths.isNotEmpty)
                          model.housePictureGridView(
                              model: model, pathList: model.otherPaths),
                        model.pickButtonBox(
                          text: 'otherList',
                          model: model,
                          pathList: model.otherPaths,
                        ),
                        const Divider(thickness: 2),
                        ElevatedButton(
                            onPressed: () async {
                              model.doneRegister(context);
                            },
                            child: const Text('登録を終了する'))
                      ],
                    ),
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
        );
      }),
    );
  }
}

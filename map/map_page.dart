import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../domain/post.dart';
import 'map_model.dart';

class MapPage extends StatefulWidget {
  MapPage({required this.post, Key? key}) : super(key: key);
  Post post;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapModel>(
      create: (_) => MapModel(post: widget.post),
      child: Consumer<MapModel>(
        builder: (context, model, child) {
          Post post = widget.post;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                post.prefecture! + post.city! + post.town! + post.address!,
              ),
            ),

            ///FutureBuilderがWidgetツリーに登録されたタイミングで、futureプロパティに指定したFuture型の関数を動かす。
            ///builderプロパティを用いて、returnするWidgetを決定する。
            ///futureの処理が終わったタイミングで、builderプロパティ内の関数は自動で再描画される。
            body: FutureBuilder(
              future: model.getLatlng(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                return GoogleMap(
                  mapType: MapType.normal,
                  markers: model.setAddress(),
                  initialCameraPosition: model.kGooglePlex!,
                  onMapCreated: (GoogleMapController controller) {
                    if (!model.map1Controller.isCompleted) {
                      const CircularProgressIndicator();
                    }
                    model.map1Controller.complete(controller);
                    model.moveCameraPosition(
                      post.prefecture! +
                          post.city! +
                          post.town! +
                          post.address!,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

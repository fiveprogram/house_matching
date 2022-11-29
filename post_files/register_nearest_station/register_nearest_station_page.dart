import 'package:flutter/material.dart';
import 'package:house_matching/post_files/register_nearest_station/register_nearest_station_model.dart';
import 'package:provider/provider.dart';

class RegisterNearestStationPage extends StatefulWidget {
  const RegisterNearestStationPage({Key? key}) : super(key: key);

  @override
  State<RegisterNearestStationPage> createState() =>
      _RegisterNearestStationPageState();
}

class _RegisterNearestStationPageState
    extends State<RegisterNearestStationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterNearestStationModel>(
        builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            onChanged: (String text) {
              model.filterStation(context);
            },
            controller: model.filterStationController,
            decoration: InputDecoration(
                hintText: '駅名を入力',
                suffixIcon: IconButton(
                    onPressed: () {
                      model.filterStationController.clear();
                    },
                    icon: const Icon(Icons.clear))),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: model.trackLineList.isNotEmpty
                  ? ListView.builder(
                      itemCount: model.filteredTrackLineList.isEmpty
                          ? model.trackLineList.length
                          : model.filteredTrackLineList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            model.filteredTrackLineList.isNotEmpty
                                ? Navigator.of(context)
                                    .pop(model.filteredTrackLineList)
                                : Navigator.of(context)
                                    .pop(model.trackLineList[index]);
                          },
                          title: Text(model.filteredTrackLineList.isEmpty
                              ? model.trackLineList[index]['stations']
                              : model.filteredTrackLineList[index]['stations']),
                          subtitle: Text(model.filteredTrackLineList.isEmpty
                              ? model.trackLineList[index]['trackLines']
                              : model.filteredTrackLineList[index]
                                  ['trackLines']),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    });
  }
}

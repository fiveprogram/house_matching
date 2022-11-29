import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'only_filtering_station_model.dart';

class OnlyFilteringStationPage extends StatefulWidget {
  const OnlyFilteringStationPage({Key? key}) : super(key: key);

  @override
  State<OnlyFilteringStationPage> createState() =>
      _OnlyFilteringStationPageState();
}

class _OnlyFilteringStationPageState extends State<OnlyFilteringStationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnlyFilteringStationModel>(
        builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            onChanged: (String text) {
              model.filterStation(context);
            },
            controller: model.filterStationController,
            decoration: const InputDecoration(hintText: '駅名を入力'),
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
                          onTap: model.filteredTrackLineList.isEmpty
                              ? () {
                                  model.randomSelectStation(index);
                                  Navigator.of(context)
                                      .pop(model.filteredTrackLineList);
                                }
                              : () {
                                  Navigator.of(context)
                                      .pop(model.filteredTrackLineList);
                                },
                          title: Text(model.filteredTrackLineList.isEmpty
                              ? model.trackLineList[index]['stations']
                              : model.filteredTrackLineList[index]['stations']),
                          subtitle: Text(
                            model.filteredTrackLineList.isEmpty
                                ? model.trackLineList[index]['trackLines']
                                : model.filteredTrackLineList[index]
                                    ['trackLines'],
                          ),
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

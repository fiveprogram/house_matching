import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnlyFilteringStationModel with ChangeNotifier {
  List<Map<String, dynamic>> trackLineList = [];
  List<Map<String, dynamic>> filteredTrackLineList = [];
  final filterStationController = TextEditingController();

  ///路線図のデータをjsonからList<List<dynamic>>に変換
  Future<void> trackLineJsonConvertToList() async {
    String trackLineData =
        await rootBundle.loadString('assets/N02-20_Station.geojson');
    final jsonResponse = json.decode(trackLineData);

    for (int i = 0; i < 10260; i++) {
      trackLineList.add({
        'stations': jsonResponse['features'][i]['properties']['N02_005'],
        'trackLines': jsonResponse['features'][i]['properties']['N02_003']
      });
    }
    notifyListeners();
  }

  Future<void> randomSelectStation(int index) async {
    filteredTrackLineList.add(trackLineList[index]);
  }

  Future<void> filterStation(context) async {
    for (int i = 0; i < trackLineList.length; i++) {
      if (!trackLineList[i].containsValue(filterStationController.text)) {
        filteredTrackLineList.clear();
      }
    }

    for (int i = 0; i < trackLineList.length; i++) {
      if (trackLineList[i].containsValue(filterStationController.text)) {
        filteredTrackLineList.clear();
        filteredTrackLineList.add(trackLineList[i]);
      }
    }
    notifyListeners();
  }
}

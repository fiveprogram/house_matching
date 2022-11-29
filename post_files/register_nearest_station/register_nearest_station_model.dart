import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class RegisterNearestStationModel with ChangeNotifier {
  List<Map<String, dynamic>> trackLineList = [];
  List<Map<String, dynamic>> filteredTrackLineList = [];
  final filterStationController = TextEditingController();

  Future<void> trackLineConvertJson() async {
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

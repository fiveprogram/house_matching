import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/post.dart';

class MapModel extends ChangeNotifier {
  Post post;
  MapModel({required this.post});

  LatLng? latLang;
  CameraPosition? kGooglePlex;
  final Completer<GoogleMapController> map1Controller = Completer();

  Future<void> getLatlng() async {
    List<Location> locations = await locationFromAddress(
        post.prefecture! + post.city! + post.town! + post.address!);
    kGooglePlex = CameraPosition(
      target: LatLng(locations.first.latitude, locations.first.longitude),
      zoom: 14.4746,
    );
    latLang = LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<void> moveCameraPosition(String text) async {
    await getLatlng();
    final GoogleMapController controller = await map1Controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex!));
    notifyListeners();
  }

  Set<Marker> setAddress() {
    return {
      Marker(
          markerId: MarkerId(post.building!),
          position: LatLng(latLang!.latitude, latLang!.longitude))
    };
  }
}

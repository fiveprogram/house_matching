import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../domain/post.dart';

class HouseInformationModel extends ChangeNotifier {
  Post post;
  HouseInformationModel({required this.post});

  CarouselController buttonCarouselController = CarouselController();

  List<dynamic> allList = [];

  void gatherList() {
    allList.clear();
    for (var exterior in post.exteriorList!) {
      allList.add(exterior);
    }
    for (var interior in post.interiorList!) {
      allList.add(interior);
    }
    for (var floorPlan in post.floorPlanList!) {
      allList.add(floorPlan);
    }
    for (var living in post.livingRoomList!) {
      allList.add(living);
    }
    for (var bed in post.bedRoomList!) {
      allList.add(bed);
    }
    for (var bath in post.bathRoomList!) {
      allList.add(bath);
    }
    for (var toilet in post.toiletList!) {
      allList.add(toilet);
    }
    for (var kitchen in post.kitchenList!) {
      allList.add(kitchen);
    }
    for (var shelves in post.shelvesList!) {
      allList.add(shelves);
    }
    for (var other in post.otherList!) {
      allList.add(other);
    }

    print(allList.length);
  }

  void changeNextPage() {
    buttonCarouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  void changePreviousPage() {
    buttonCarouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    notifyListeners();
  }

  int activeIndex = 0;
  List<double>? latLang;
  CameraPosition? kGooglePlex;

  final Completer<GoogleMapController> mapController = Completer();

  Future<void> getLatlng() async {
    final searchWord =
        post.prefecture! + post.city! + post.town! + post.address!;
    List<Location> locations = await locationFromAddress(searchWord);

    latLang = [locations.first.latitude, locations.first.longitude];
    kGooglePlex = CameraPosition(
      target: LatLng(latLang![0], latLang![1]),
      zoom: 14.4746,
    );
    notifyListeners();
  }

  Set<Marker> setAddress() {
    return {
      Marker(
          markerId: MarkerId(post.building!),
          position: LatLng(latLang![0], latLang![1]))
    };
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: post.exteriorList!.length +
          post.interiorList!.length +
          post.floorPlanList!.length +
          post.livingRoomList!.length +
          post.bedRoomList!.length +
          post.bathRoomList!.length +
          post.toiletList!.length +
          post.kitchenList!.length +
          post.shelvesList!.length +
          post.otherList!.length,
      //エフェクトはドキュメントを見た方がわかりやすい
      effect: const JumpingDotEffect(
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: Colors.orange,
          dotColor: Colors.black12),
    );
  }

  Future<void> popUpContact(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(post.contact!),
            content: const Text('こちらの連絡先に連絡してみましょう'),
          );
        });
  }
}

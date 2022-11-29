import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  DocumentReference ref;
  final String? address;
  String? ageOfBuilding;
  String? building;
  String? buildingStructure;
  String? prefecture;
  String? city;
  String? floorPlan;
  String? management;

  String? occupationArea;
  String? price;
  String? town;
  String? appeal;
  String? homeInsurance;
  String? amortizationMoney;
  String? moveInDay;
  String? renewal;
  String? contractionTerm;
  String? securityDeposit;
  String? keyMoney;
  String? houses;
  String? floor;
  String? totalFloor;
  String? parking;

  String? nearestBuildings;
  String? uid;
  String? postTime;
  String? remark;
  bool isFavorite;
  String? contact;
  String? wayToContact;
  String? postId;
  List<dynamic>? exteriorList;
  List<dynamic>? interiorList;
  List<dynamic>? floorPlanList;
  List<dynamic>? livingRoomList;
  List<dynamic>? bedRoomList;
  List<dynamic>? bathRoomList;
  List<dynamic>? toiletList;
  List<dynamic>? kitchenList;
  List<dynamic>? shelvesList;
  List<dynamic>? otherList;
  Map<String, dynamic>? nearestStationInfo1;
  Map<String, dynamic>? nearestStationInfo2;
  Map<String, dynamic>? nearestStationInfo3;

  Post({
    required this.ref,
    this.prefecture,
    this.city,
    this.address,
    this.town,
    this.appeal,
    this.ageOfBuilding,
    this.amortizationMoney,
    this.building,
    this.buildingStructure,
    this.contractionTerm,
    this.floor,
    this.floorPlan,
    this.homeInsurance,
    this.houses,
    this.keyMoney,
    this.management,
    this.moveInDay,
    this.occupationArea,
    this.parking,
    this.price,
    this.renewal,
    this.securityDeposit,
    this.totalFloor,
    this.nearestBuildings,
    this.uid,
    this.postTime,
    this.remark,
    required this.isFavorite,
    this.postId,
    this.exteriorList,
    this.interiorList,
    this.floorPlanList,
    this.livingRoomList,
    this.bedRoomList,
    this.bathRoomList,
    this.toiletList,
    this.kitchenList,
    this.shelvesList,
    this.otherList,
    this.contact,
    this.wayToContact,
    this.nearestStationInfo1,
    this.nearestStationInfo2,
    this.nearestStationInfo3,
  });

  // Post changeAddress(Post post,String newAddress){
  //   return Post(ref: post.ref, isFavorite: post.isFavorite,address: newAddress,)
  // }

  factory Post.fromFireStore(DocumentSnapshot doc) {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //Postインスタンスを返すための関数
    return Post(
        ref: doc.reference,
        address: data['address'],
        ageOfBuilding: data['ageOfBuilding'],
        amortizationMoney: data['amortizationMoney'],
        appeal: data['appeal'],
        building: data['building'],
        buildingStructure: data['buildingStructure'],
        city: data['city'],
        contractionTerm: data['contractionTerm'],
        floor: data['floor'],
        floorPlan: data['floorPlan'],
        homeInsurance: data['homeInsurance'],
        houses: data['houses'],
        keyMoney: data['keyMoney'],
        management: data['management'],
        moveInDay: data['moveInDay'],
        nearestStationInfo1: data['nearestStationInfo1'],
        nearestStationInfo2: data['nearestStationInfo2'],
        nearestStationInfo3: data['nearestStationInfo3'],
        occupationArea: data['occupationArea'],
        parking: data['parking'],
        prefecture: data['prefecture'],
        price: data['price'],
        renewal: data['renewal'],
        securityDeposit: data['securityDeposit'],
        totalFloor: data['totalFloor'],
        town: data['town'],
        nearestBuildings: data['nearestBuildings'],
        uid: user!.uid,
        postTime: data['postTime'],
        remark: data['remark'],
        isFavorite: false,
        postId: data['postId'],
        exteriorList: data['exteriorList'],
        interiorList: data['interiorList'],
        floorPlanList: data['floorPlanList'],
        livingRoomList: data['livingRoomList'],
        bedRoomList: data['bedRoomList'],
        bathRoomList: data['bathRoomList'],
        toiletList: data['toiletList'],
        kitchenList: data['kitchenList'],
        shelvesList: data['shelvesList'],
        otherList: data['otherList'],
        contact: data['contact'],
        wayToContact: data['wayToContact']);
  }
}

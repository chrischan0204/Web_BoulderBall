import 'package:boulderball/models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BundleModel {
  String id = "";
  String name = "";
  List<RouteModel> routes = [];
  String imgRef = "";
  String imgUrl = "";
  bool free = true;
  bool purchased = false;
  String bundleId = "";
  String shopUrl = "";
  DocumentReference? ref;

  BundleModel(
    this.id,
    this.name,
    this.imgRef,
    this.free,
    this.purchased,
    this.shopUrl,
    this.bundleId,
    this.ref,
  );

  factory BundleModel.fromJson(Map<String, dynamic> data) {
    final id = data["id"] ?? "";
    final name = data["name"] ?? "";
    final imgRef = data["image"] ?? "";
    final free = data["free"] ?? false;
    final bundlePurchased =
        data["purchased"] == null || free ? free : data["purchased"];
    final shopUrl = data["shop_url"] ?? "";
    final bundleId = data["bundleId"] ?? "";

    return BundleModel(
      id,
      name,
      imgRef,
      free,
      bundlePurchased,
      shopUrl,
      bundleId,
      null,
    );
  }
}

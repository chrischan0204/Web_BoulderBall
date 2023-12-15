import 'package:boulderball/models/bundle_model.dart';

class BundledBundleModel {
  String id = "";
  String name = "";
  String shopUrl = "";
  List<BundleModel> bundles = [];
  bool purchased = false;

  BundledBundleModel(this.id, this.name, this.shopUrl);

  factory BundledBundleModel.fromJson(Map<String, dynamic> data) {
    final id = data["id"] ?? "";
    final name = data["name"] ?? "";
    final shopUrl = data["shop_url"] ?? "";

    return BundledBundleModel(id, name, shopUrl);
  }
}

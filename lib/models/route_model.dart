import 'package:cloud_firestore/cloud_firestore.dart';

class RouteModel {
  String id = "";
  String name = "";
  // convert to list of images
  String imgFrontRef = "";
  String imgBackRef = "";
  String imgFrontUrl = "";
  String imgBackUrl = "";
  String imgSkillsRef = "";
  String imgSkillsUrl = "";
  bool purchased = false;
  String videoUrl = "";
  DocumentReference? ref;

  RouteModel(
    this.id,
    this.name,
    this.imgFrontRef,
    this.imgBackRef,
    this.imgSkillsRef,
    this.purchased,
    this.videoUrl,
  );

  factory RouteModel.fromJson(Map<String, dynamic> data) {
    final id = data["id"] ?? "";
    final name = data["name"] ?? "";
    final imgFrontRef = data["img-front"] ?? "";
    final imgBackRef = data["img-back"] ?? "";
    final imgSkillsRef = data["img-skills"] ?? "";
    final purchased = data["purchased"] ?? false;
    final videoUrl = data["video-url"] ?? "";

    return RouteModel(
      id,
      name,
      imgFrontRef,
      imgBackRef,
      imgSkillsRef,
      purchased,
      videoUrl,
    );
  }
}

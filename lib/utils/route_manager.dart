import 'dart:async';

import 'package:boulderball/models/bundle_model.dart';
import 'package:boulderball/models/bundled_bundles_model.dart';
import 'package:boulderball/models/route_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RouteManager {
  static final RouteManager instance = RouteManager._privateConstructor();

  RouteManager._privateConstructor();

  static const String routeBundleId = "route_bundle";
  static const String singleRouteId = "single_route";
  static const Set<String> productIds = {
    routeBundleId,
    singleRouteId,
  };

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  late CollectionReference<Map<String, dynamic>> routesCollection;
  late CollectionReference<Map<String, dynamic>> purchasesCollection;

  List<BundleModel> bundles = [];
  List<BundledBundleModel> bundledBundles = [];
  List<String> purchasedItems = [];

  String currency = "€";

  Function routesCallback = (() {});
  Function bundlesCallback = (() {});

  void init() {
    bundles = [];
    purchasedItems = [];

    routesCollection = firestore.collection("routes");
    purchasesCollection = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("purchases");

    createRoutesListener();
    createPurchasesListener();
  }

  void createRoutesListener() async {
    routesCollection
        .orderBy("index", descending: false)
        .snapshots()
        .listen((event) {
      getAllRoutes(event);
    });
  }

  void createPurchasesListener() async {
    purchasesCollection.snapshots().listen((event) {
      getPurchases();
    });
  }

  Future<void> getPurchases(
      [QuerySnapshot<Map<String, dynamic>>? purchases]) async {
    purchases ??= await purchasesCollection.get();

    List<String> ids = [];
    for (var purchase in purchases.docs) {
      var id = purchase.data()["id"];
      if (id != null) ids.add(id);
    }
    purchasedItems = ids;

    bundlesCallback();
  }

  bool getBundlePurchased(BundleModel bundle) {
    return bundle.free ||
        bundle.purchased ||
        purchasedItems.contains(bundle.id);
  }

  bool getBundledBundlePurchased(BundledBundleModel bb) {
    return purchasedItems.contains(bb.id);
  }

  Future<void> getBundledBundles() async {
    bundledBundles = [];
    var bundles = await firestore.collection("bundledBundles").get();

    for (var bundle in bundles.docs) {
      bundledBundles.add(BundledBundleModel.fromJson(bundle.data()));
    }
  }

  void getAllRoutes([QuerySnapshot<Map<String, dynamic>>? bundleData]) async {
    bundles = [];

    await getBundledBundles();
    await getPurchases();

    bundleData = await firestore
        .collection("routes")
        .orderBy("index", descending: false)
        .get();

    for (var bundleDoc in bundleData.docs) {
      var routesCollection =
          firestore.collection("routes").doc(bundleDoc.id).collection("routes");
      var routesData =
          await routesCollection.orderBy("index", descending: false).get();

      BundleModel bundle = BundleModel.fromJson(bundleDoc.data());
      bundle.ref = bundleDoc.reference;

      for (var routeDoc in routesData.docs) {
        RouteModel route = RouteModel.fromJson(routeDoc.data());
        route.ref = routeDoc.reference;
        bundle.routes.add(route);
      }

      if (bundle.bundleId != "") {
        for (var bundledBundle in bundledBundles) {
          if (bundledBundle.id == bundle.bundleId) {
            bundledBundle.bundles.add(bundle);
          }
        }
      } else {
        bundles.add(bundle);
      }

      bundlesCallback();
    }
  }

  Future<void> loadBundleImages(BundleModel bundle) async {
    if (bundle.imgRef != "") {
      try {
        var bundleImgRef = storage.refFromURL(bundle.imgRef);
        bundle.imgUrl = await bundleImgRef.getDownloadURL();
      } catch (e) {
        bundle.imgUrl = "";
      }
    }
  }

  Future<void> loadRouteImages(RouteModel route) async {
    loadRouteImage(route, 0);
    loadRouteImage(route, 1);
    loadRouteImage(route, 2);
  }

  Future<void> loadRouteImage(RouteModel route, int index) async {
    switch (index) {
      case 0:
        if (route.imgFrontRef != "") {
          try {
            var frontRef = storage.refFromURL(route.imgFrontRef);
            route.imgFrontUrl = await frontRef.getDownloadURL();
          } catch (e) {
            route.imgFrontUrl = "";
          }
        }
        break;

      case 1:
        if (route.imgBackRef != "") {
          try {
            var backRef = storage.refFromURL(route.imgBackRef);
            route.imgBackUrl = await backRef.getDownloadURL();
          } catch (e) {
            route.imgBackUrl = "";
          }
        }
        break;

      case 2:
        if (route.imgSkillsRef != "") {
          try {
            var skillsRef = storage.refFromURL(route.imgSkillsRef);
            route.imgSkillsUrl = await skillsRef.getDownloadURL();
          } catch (e) {
            route.imgSkillsUrl = "";
          }
        }
        break;

      default:
        break;
    }
  }

  Future<void> loadBundleRoutesImages(BundleModel bundle) async {
    for (RouteModel route in bundle.routes) {
      if (route.imgFrontUrl == "") loadRouteImage(route, 0);
      routesCallback();
    }
  }

  Future<bool> docExists(DocumentReference document) async {
    try {
      var doc = await document.get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}

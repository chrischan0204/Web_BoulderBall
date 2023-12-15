import 'package:boulderball/models/route_model.dart';
import 'package:boulderball/widgets/icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PurchasableRouteWidget extends StatefulWidget {
  const PurchasableRouteWidget({super.key, required this.route});

  final RouteModel route;

  @override
  State<PurchasableRouteWidget> createState() => _PurchasableRouteWidgetState();
}

class _PurchasableRouteWidgetState extends State<PurchasableRouteWidget> {
  String imgUrl = "";
  final storage = FirebaseStorage.instance;
  late Widget image;

  @override
  void initState() {
    super.initState();
    imgUrl = widget.route.imgFrontUrl;
  }

  @override
  Widget build(BuildContext context) {
    return imgUrl == ""
        ? Text(widget.route.name)
        : CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder: (context, imageProvider) => Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 0, 0, 0),
                      BlendMode.hue,
                    ),
                    child: Image(image: imageProvider),
                  ),
                ),
              ],
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          );
  }

  Widget getImageWidget() {
    return imgUrl == ""
        ? Text(widget.route.name)
        : CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder: (context, imageProvider) => Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 0, 0, 0),
                          BlendMode.hue,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: BBIconButton(
                    label: const Text("Buy"),
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          );
  }
}

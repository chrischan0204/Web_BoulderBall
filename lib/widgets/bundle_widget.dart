import 'package:boulderball/models/bundle_model.dart';
import 'package:boulderball/screens/route_list_screen.dart';
import 'package:boulderball/utils/route_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BundleWidget extends StatefulWidget {
  BundleWidget({
    super.key,
    required this.bundle,
  });

  BundleModel bundle;

  @override
  State<BundleWidget> createState() => _BundleWidgetState();
}

class _BundleWidgetState extends State<BundleWidget> {
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();

    if (widget.bundle.imgUrl == "") {
      RouteManager.instance.loadBundleImages(widget.bundle).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.bundle.purchased =
        RouteManager.instance.getBundlePurchased(widget.bundle);

    return GestureDetector(
      onTap: () {
        RouteManager.instance.loadBundleRoutesImages(widget.bundle);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RouteListScreen(
                routes: widget.bundle.routes,
                bundle: widget.bundle,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: widget.bundle.id,
              child: Stack(
                children: [
                  _buildImage(widget.bundle.imgUrl),
                  _buildGradient(),
                  _buildTitle(),
                  _buildPriceText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return url == ""
        ? Container()
        : CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: double.infinity,
          );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(1.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.45, 0.99],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.79)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.45, 0.99],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.bundle.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            widget.bundle.purchased == false && widget.bundle.shopUrl != ""
                ? ButtonBar(
                    buttonPadding: const EdgeInsets.all(0),
                    children: [
                      TextButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse(widget.bundle.shopUrl),
                            mode: LaunchMode.externalApplication,
                          );
                          setState(() {});
                        },
                        child: const Text("Buy"),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceText() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.bundle.shopUrl != ""
              ? (widget.bundle.purchased ? "" : "6.90€")
              : "Free",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

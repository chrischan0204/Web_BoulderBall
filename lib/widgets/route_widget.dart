import 'package:boulderball/models/route_model.dart';
import 'package:boulderball/utils/route_manager.dart';
import 'package:boulderball/screens/route_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({
    super.key,
    required this.route,
  });

  final RouteModel route;

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  final storage = FirebaseStorage.instance;
  late Widget image;

  @override
  void initState() {
    super.initState();

    if (widget.route.imgFrontUrl == "") {
      RouteManager.instance.loadRouteImage(widget.route, 0).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RouteDetailsScreen(route: widget.route);
        }));
      },
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    return Center(
      child: _buildEmptyRoute(
        child: widget.route.imgFrontUrl == ""
            ? Center(child: Text(widget.route.name))
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.scaleDown,
                  imageUrl: widget.route.imgFrontUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      _buildEmptyRoute(
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyRoute({required Widget child}) {
    return AspectRatio(
      aspectRatio: 827 / 1182, // size of the image
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

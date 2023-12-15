import 'package:boulderball/models/bundle_model.dart';
import 'package:boulderball/utils/route_manager.dart';
import 'package:boulderball/models/route_model.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:boulderball/widgets/purchasable_route_widget.dart';
import 'package:boulderball/widgets/route_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class RouteListScreen extends StatefulWidget {
  RouteListScreen({
    super.key,
    required this.routes,
    required this.bundle,
  });

  List<RouteModel>? routes = [];
  BundleModel bundle;

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    RouteManager.instance.routesCallback = routeListCallback;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BBScaffold(
      title: Text(widget.bundle.name),
      body: Center(
        child: Hero(
          tag: widget.bundle.id,
          child: PageStorage(
            bucket: _bucket,
            child: CarouselSlider.builder(
              itemCount: widget.bundle.routes.length,
              itemBuilder: (context, index, realIndex) {
                RouteModel route = widget.bundle.routes[index];
                if (widget.bundle.purchased) {
                  return RouteWidget(route: route);
                } else {
                  return PurchasableRouteWidget(route: route);
                }
              },
              options: CarouselOptions(
                height: height * 0.7,
                enlargeCenterPage: true,
                enlargeFactor: 0.35,
                enableInfiniteScroll: false,
                pageSnapping: false,
                clipBehavior: Clip.none,
                scrollPhysics: const BouncingScrollPhysics(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void routeListCallback() {
    if (mounted) {
      setState(() {});
    }
  }
}

import 'package:boulderball/utils/route_manager.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:boulderball/widgets/bundle_widget.dart';
import 'package:boulderball/widgets/bundled_bundle_widget.dart';
import 'package:boulderball/widgets/email_dialog.dart';
import 'package:flutter/material.dart';

class BundlesScreen extends StatefulWidget {
  const BundlesScreen({super.key});

  @override
  State<BundlesScreen> createState() => _BundlesScreenState();
}

class _BundlesScreenState extends State<BundlesScreen> {
  List<Widget> bundleWidgets = [];

  @override
  void initState() {
    super.initState();
    RouteManager.instance.bundlesCallback = bundleListCallback;
    bundleListCallback();
  }

  @override
  Widget build(BuildContext context) {
    return BBScaffold(
      title: const Text("Routes"),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: ListView(
          shrinkWrap: true,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const EmailDialog(),
                );
              },
              child: const Text(
                "Already purchased?",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: bundleWidgets.length,
                itemBuilder: (BuildContext context, int collectionIndex) {
                  return bundleWidgets[collectionIndex];
                },
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }

  void bundleListCallback() {
    if (mounted) {
      setState(() {
        bundleWidgets = [];

        for (var bundledBundle in RouteManager.instance.bundledBundles) {
          bundleWidgets.add(BundledBundleWidget(bundledBundle: bundledBundle));
        }
        for (var bundle in RouteManager.instance.bundles) {
          bundleWidgets.add(BundleWidget(bundle: bundle));
        }
      });
    }
  }

  Size getScreenSizeWithoutSafeArea(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Size(width - padding.left - padding.right,
        height - padding.top - padding.bottom);
  }
}

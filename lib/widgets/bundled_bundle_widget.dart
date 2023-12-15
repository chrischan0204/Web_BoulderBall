import 'package:boulderball/models/bundle_model.dart';
import 'package:boulderball/models/bundled_bundles_model.dart';
import 'package:boulderball/utils/route_manager.dart';
import 'package:boulderball/widgets/bundle_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BundledBundleWidget extends StatefulWidget {
  BundledBundleWidget({
    super.key,
    required this.bundledBundle,
  });

  BundledBundleModel bundledBundle;

  @override
  State<BundledBundleWidget> createState() => _BundledBundleWidgetState();
}

class _BundledBundleWidgetState extends State<BundledBundleWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.bundledBundle.purchased =
        RouteManager.instance.getBundledBundlePurchased(widget.bundledBundle);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                  width: 3, color: Theme.of(context).colorScheme.secondary),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.bundledBundle.bundles.length,
              itemBuilder: (context, index) {
                BundleModel bundle = widget.bundledBundle.bundles[index];
                if (widget.bundledBundle.purchased) {
                  bundle.purchased = true;
                } else {
                  bundle.purchased = false;
                }
                return BundleWidget(bundle: bundle);
              },
            ),
          ),
        ),
        widget.bundledBundle.purchased
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: const ButtonStyle(),
                    onPressed: () {
                      launchUrl(
                        Uri.parse(widget.bundledBundle.shopUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(1.0),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: const Text("Buy Bundle"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(1.0),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "9.90€",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

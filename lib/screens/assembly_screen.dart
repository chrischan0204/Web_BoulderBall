import 'dart:convert';

import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AssemblyScreen extends StatefulWidget {
  const AssemblyScreen({super.key});

  @override
  State<AssemblyScreen> createState() => _AssemblyScreenState();
}

class _AssemblyScreenState extends State<AssemblyScreen> {
  List<Widget> images = [];
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();

    DefaultAssetBundle.of(context)
        .loadString('AssetManifest.json')
        .then((value) {
      var imagePaths = jsonDecode(value)
          .keys
          .where((String key) => key.startsWith('assets/assembly'))
          .toList();

      imagePaths.sort();

      for (var image in imagePaths) {
        setState(() {
          images.add(
            Image(image: AssetImage(image)),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BBScaffold(
      title: Text("Step ${_currentIndex + 1}"),
      body: Stack(
        children: [
          Column(
            children: [
              getIndicator(),
              CarouselSlider(
                items: images,
                carouselController: _carouselController,
                options: CarouselOptions(
                    height: height * 0.85,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.7,
                    enableInfiniteScroll: false,
                    pageSnapping: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      if (mounted) {
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    }),
              ),
            ],
          ),
          _currentIndex < images.length - 1
              ? Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: () {
                      _carouselController.nextPage();
                    },
                    icon: const Icon(Icons.keyboard_arrow_right_rounded),
                  ),
                )
              : Container(),
          _currentIndex > 0
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: () {
                      _carouselController.previousPage();
                    },
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget getIndicator() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: width / 12 * (_currentIndex + 1),
      height: 10,
    );
  }
}

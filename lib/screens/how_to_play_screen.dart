import 'package:boulderball/screens/how-to-play/basics_screen.dart';
import 'package:boulderball/screens/how-to-play/free_climbing_screen.dart';
import 'package:boulderball/screens/how-to-play/special_moves_screen.dart';
import 'package:boulderball/screens/how-to-play/workout_screen.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:boulderball/widgets/folder_widget.dart';
import 'package:flutter/material.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  List<Widget> folders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    folders = [
      Folder(
          text: const Text("Basics"),
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const BasicsScreen(),
            ));
          }),
      const Padding(padding: EdgeInsets.only(top: 20)),
      Folder(
          text: const Text("Special Moves"),
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SpecialMovesScreen(),
            ));
          }),
      const Padding(padding: EdgeInsets.only(top: 20)),
      Folder(
          text: const Text("Free Climbing"),
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FreeClimbingScreen(),
            ));
          }),
      const Padding(padding: EdgeInsets.only(top: 20)),
      Folder(
          text: const Text("Warm Up & Workout"),
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const WorkoutScreen(),
            ));
          }),
    ];

    return BBScaffold(
      title: const Text("How To Play"),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(40),
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: folders,
        ),
      ),
    );
  }
}

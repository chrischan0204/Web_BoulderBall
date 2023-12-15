import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '5uHIbWIj41Y',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
      disableDragSeek: true,
      loop: true,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BBScaffold(
      title: const Text("Warm Up & Workout"),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: ListView(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: const Text(
                  "In this Boulderball warm-up and workout routine, we'll focus on preparing and strengthening your fingers, hands, and forearms for an awesome climbing session. Follow along with the video to learn and perform the specific exercises designed to improve your grip strength and flexibility. Let's get those muscles ready for some intense bouldering and let's crush those holds!",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                decoration: BoxDecoration(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 9 / 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

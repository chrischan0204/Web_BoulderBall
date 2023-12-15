import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeClimbingScreen extends StatefulWidget {
  const FreeClimbingScreen({super.key});

  @override
  State<FreeClimbingScreen> createState() => _FreeClimbingScreenState();
}

class _FreeClimbingScreenState extends State<FreeClimbingScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'frHV6DOMjtk',
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
      title: const Text("Free Climbing"),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          clipBehavior: Clip.none,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  image: AssetImage("assets/htp/free_climbing.png"),
                ),
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
    );
  }
}

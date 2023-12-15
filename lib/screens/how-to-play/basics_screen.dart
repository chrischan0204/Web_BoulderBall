import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BasicsScreen extends StatefulWidget {
  const BasicsScreen({super.key});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'O0E7sl4y1HQ',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
      disableDragSeek: true,
      loop: true,
    ),
  );

  final List<String> instructions = [
    "Pick a route",
    "Use magnesium for your fingers",
    "Use both hands when climbing. However, only 3 fingers may touch the BB at the same time",
    "Hold the BB up on the first two indicated holds of the route. With a third finger, hold grip 3 of the route. Now release grip 1 and move on to grip 4",
    "Follow the given route in this way",
  ];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BBScaffold(
      title: const Text("Basics"),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instructions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "${index + 1}. ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                instructions[index],
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        index < instructions.length - 1
                            ? const Divider(
                                thickness: 1.5,
                              )
                            : Container(),
                      ],
                    );
                  },
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

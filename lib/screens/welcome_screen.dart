import 'dart:ui';

import 'package:boulderball/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  late Size screenSize;
  bool signedIn = false;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.asset('assets/backgrounds/welcome-video.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            _controller.setVolume(0.0);
            _controller.play();
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    signedIn = FirebaseAuth.instance.currentUser != null;
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: _controller.value.size.width * screenSize.aspectRatio,
                child: _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Container(),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "BOULDERBALL - let's challenge!",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 2,
                  indent: screenSize.width * 0.2,
                  endIndent: screenSize.width * 0.2,
                ),
                const Padding(padding: EdgeInsets.all(5)),
                !signedIn
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: "sign-in",
                            child: SizedBox(
                              width: screenSize.width * 0.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: const Text("Sign In"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text("Swipe up to start"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:boulderball/widgets/nav_drawer_widget.dart';
import 'package:flutter/material.dart';

class BBScaffold extends StatefulWidget {
  BBScaffold({
    super.key,
    required this.title,
    required this.body,
    this.navDrawer = false,
    this.fab,
  });

  Widget title;
  Widget body;
  bool navDrawer;
  Widget? fab;

  @override
  State<BBScaffold> createState() => _BBScaffoldState();
}

class _BBScaffoldState extends State<BBScaffold> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/home_screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Scaffold(
          appBar: widget.navDrawer
              ? AppBar(
                  title: widget.title,
                )
              : AppBar(
                  title: widget.title,
                  leading: const BackButton(),
                ),
          backgroundColor: Colors.transparent,
          body: widget.body,
          drawer: widget.navDrawer ? NavDrawer() : Container(),
          floatingActionButton: widget.fab,
        ),
      ],
    );
  }
}

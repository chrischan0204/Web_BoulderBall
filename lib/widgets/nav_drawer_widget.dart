import 'package:boulderball/screens/welcome_screen.dart';
import 'package:boulderball/utils/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                const Text(
                  'Boulderball',
                  style: TextStyle(fontSize: 35),
                ),
                FutureBuilder<String>(
                  future: UserManager.getUsername(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text(
                      snapshot.data ?? "",
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              UserManager.signOut();
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const WelcomeScreen();
              }));
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: const Text("Privacy Policy"),
                onTap: () {
                  launchUrl(
                    Uri.parse(
                        "https://sites.google.com/view/boulderball-privacy-policy/"),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:boulderball/screens/home_screen.dart';
import 'package:boulderball/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // disable page rotation

  runApp(const BoulderballApp());
}

class BoulderballApp extends StatefulWidget {
  const BoulderballApp({super.key});

  @override
  State<BoulderballApp> createState() => _BoulderballAppState();
}

class _BoulderballAppState extends State<BoulderballApp> {
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  late bool signedIn = false;
  ScrollPhysics pageViewPhysics = const NeverScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();

    signedIn = FirebaseAuth.instance.currentUser != null;
    pageViewPhysics =
        signedIn ? const ScrollPhysics() : const NeverScrollableScrollPhysics();

    EasyLoading.instance
      ..backgroundColor = const Color(0xff122D3C)
      ..indicatorType = EasyLoadingIndicatorType.squareCircle
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black;
  }

  @override
  Widget build(BuildContext context) {
    // signedIn = FirebaseAuth.instance.currentUser != null;

    const Color backgroundColor = Color(0xff122D3C);
    const Color secondaryColor = Color(0xffF3B727);

    return MaterialApp(
      title: 'Boulderball',
      builder: (context, child) {
        return EasyLoading.init()(context, child);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.dark,
          background: backgroundColor,
          secondary: secondaryColor,
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        cardTheme: const CardTheme(
          color: backgroundColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.all(14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            // primary: Colors.orange,
            foregroundColor: secondaryColor,
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: backgroundColor,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      home: getLandingPage(),
    );
  }

  Widget getLandingPage() {
    return PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      physics: pageViewPhysics,
      onPageChanged: ((value) {
        if (!signedIn) {
          pageController.jumpToPage(0);
        } else {
          // disable swipe down when on home screen
          setState(() {
            pageViewPhysics = const NeverScrollableScrollPhysics();
          });
        }
      }),
      children: const [
        WelcomeScreen(),
        HomeScreen(),
      ],
    );
  }
}

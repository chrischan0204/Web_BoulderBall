import 'package:boulderball/screens/home_screen.dart';
import 'package:boulderball/utils/user_manager.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BBScaffold(
      title: const Text("Sign Up"),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  validator: validateEmail,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: validatePassword,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                  ),
                  validator: validatePassword,
                ),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: screenSize.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      handleSignUp();
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSignUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: "loading");

    UserManager.signUpWithEmail(_emailController.text, _passwordController.text)
        .then((value) {
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
      );
    }).catchError((e) {
      switch (e.code) {
        case "invalid-email":
          EasyLoading.showError("Invalid email address");
          break;
        case "email-already-in-use":
          EasyLoading.showError("Email already in Use");
          break;
        case "invalid-password":
          EasyLoading.showError("Invalid Password");
          break;
        case "weak-password":
          EasyLoading.showError("Password not strong enough");
          break;
        default:
          EasyLoading.showError("Failed to Sign Up");
          break;
      }
    });
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Enter a password";
    }

    if (value.length < 6) {
      return "Password must be longer than 6 characters";
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords do not match";
    }

    return null;
  }
}

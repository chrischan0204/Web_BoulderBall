import 'package:boulderball/screens/home_screen.dart';
import 'package:boulderball/screens/signup_screen.dart';
import 'package:boulderball/utils/user_manager.dart';
import 'package:boulderball/widgets/bb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  UserManager userManager = UserManager();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BBScaffold(
      title: const Text("Sign In"),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Hero(
            tag: "sign-in",
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: validateEmail,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    validator: validatePassword,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        var emailValid = validateEmail(_emailController.text);
                        if (emailValid != null) {
                          EasyLoading.showError(emailValid);
                          return;
                        }
                        UserManager.resetPassword(email: _emailController.text)
                            .then((value) =>
                                EasyLoading.showSuccess("Email has been sent"));
                      },
                      child: const Text("Forgot your password?"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    width: screenSize.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        handleLogin();
                      },
                      child: const Text("Sign In"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  const Divider(thickness: 1.8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("New?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                          },
                          child: const Text("Create Account")),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: "loading");

    UserManager.signInWithEmail(_emailController.text, _passwordController.text)
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
        case "user-not-found":
          EasyLoading.showError("User not found");
          break;
        case "wrong-password":
          EasyLoading.showError("Incorrect password");
          break;
        default:
          EasyLoading.showError("Failed to Sign In");
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

    return null;
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/auth/login_page.dart';
import 'package:wbrs/pages/auth/writing_data_user.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black,
            )
          ]),
          child: Image.asset(
            "assets/fon2.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.7),
            colorBlendMode: BlendMode.modulate,
            scale: 0.6,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "WBRS",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Well-built relationships",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                "Создайте профиль и присоединяйтесь к нам!",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: textInputDecoration.copyWith(
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  labelText: "Никнэйм",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  fullName = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Имя не может быть пустым";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: textInputDecoration.copyWith(
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },

                              // check tha validation
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Введите корректный email";
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  labelText: "Пароль",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Пароль должен содержать 6 символов";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Зарегистрироваться",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  register();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text.rich(TextSpan(
                              text: "Уже есть аккаунт? ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Войти",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
                                      }),
                              ],
                            )),
                          ],
                        )),
                  ),
                ),
        ),
      ],
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          FirebaseAuth.instance.currentUser?.updateDisplayName(fullName);
          nextScreenReplace(context, const AboutUserWriting());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

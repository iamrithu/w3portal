// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../provider/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool visible = false;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  setLoggedInDetails(email, password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Email', email);
    await prefs.setString('Password', password);
    await prefs.setString('autoLogin', "true");
  }

  getlocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? getEmail = prefs.getString('Email');
    final String? getPassword = prefs.getString('Password');
    final String? getAutoLogin = prefs.getString('autoLogin');

    if (getAutoLogin == null || getAutoLogin.isEmpty) {
      return;
    } else {
      setState(() {
        isChecked = true;
        _email.text = getEmail!;
        _password.text = getPassword!;
      });
      authendication(getEmail!, getPassword!);
    }
  }

  authendication(String email, String password) {
    setState(() {
      visible = !visible;
    });
    API().authendication(email, password).then((value) {
      if (value.statusCode != 200) {
        setState(() {
          visible = !visible;
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '${value.data["error"]["message"]}',
        );
        return null;
      }
      setState(() {
        visible = !visible;
      });
      if (isChecked) {
        setLoggedInDetails(email, password);
      }
      ;
      print("i am also working");

      ref
          .read(tokenProvider.notifier)
          .update((state) => value.data["data"]["token"]);

      ref.read(loggedInProvider.notifier).state = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocal();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 27, 24, 73);
      }
      return Color.fromARGB(255, 27, 24, 73);
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: Colors.blue[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: width * 0.9,
                  height: height * 0.45,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: Text(
                                  "W3CERT",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color.fromARGB(255, 27, 24, 73),
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Sing In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: width * 0.8,
                            height: height * 0.095,
                            child: TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email Address',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.8,
                            height: height * 0.095,
                            child: TextFormField(
                              obscureText: true,
                              controller: _password,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: isChecked,
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "Stay Logged In",
                                  style: GoogleFonts.ptSans(
                                      color: Color.fromARGB(255, 27, 24, 73),
                                      fontSize: width * 0.028,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(width * 0.8, height * 0.05)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authendication(_email.text, _password.text);
                              }
                            },
                            child: Container(
                              width: width * 0.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Log In'),
                                  Icon(Icons.arrow_circle_right_outlined)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: visible,
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.45,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Card(
                        color: Color.fromARGB(119, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            elevation: 10,
                            child: Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              alignment: Alignment.center,
                              child: Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  elevation: 10,
                                  child: Container(
                                    width: width * 0.1,
                                    height: width * 0.1,
                                    alignment: Alignment.center,
                                    child:
                                        LoadingAnimationWidget.twoRotatingArc(
                                            color:
                                                Color.fromARGB(255, 27, 24, 73),
                                            size: width * 0.07),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

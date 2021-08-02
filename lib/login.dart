import 'package:app_contatos/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'globals.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future logInFuture = Future.value(false);
  bool isLoading = false;
  bool fixDuplicate = true;

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final UnderlineInputBorder focusBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: globals.mainColor,
    ),
  );

  void doLogin() => setState(() {
        logInFuture = repository.login(login: loginController.text, password: passwordController.text);
      });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(
                width: MediaQuery.of(context).size.width * .7,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: globals.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'AHHHHHHHHHH!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * .7,
                child: TextField(
                  controller: loginController,
                  decoration: InputDecoration(
                    hintText: 'Login',
                    focusedBorder: focusBorder,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * .7,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    focusedBorder: focusBorder,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  if (!isLoading) {
                    doLogin();
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  width: MediaQuery.of(context).size.width * .7,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: globals.mainColor,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'ENTRAR',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: globals.mainColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 3,
                        child: FutureBuilder(
                          future: logInFuture,
                          builder: (context, snapshot) {
                            isLoading = snapshot.connectionState == ConnectionState.waiting;

                            if (fixDuplicate && !isLoading && snapshot.hasData && snapshot.data) {
                              fixDuplicate = false;
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              });
                            }

                            return isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(globals.mainColor,)),
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_right,
                                    color: globals.mainColor,
                                  );
                          },
                        ),
                      ),
                    ],
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

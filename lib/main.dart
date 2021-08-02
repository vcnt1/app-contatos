import 'package:app_contatos/repository.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogged = await repository.checkIfLogged();
  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  MyApp({this.isLogged});

  final bool isLogged;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iNeedHelp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLogged ? Home() : Login(),
    );
  }
}

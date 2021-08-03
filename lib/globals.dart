import 'package:flutter/material.dart';

import 'models/user.dart';

Globals globals = Globals();

class Globals {
  static final Globals _Globals = Globals._internal();

  factory Globals() {
    return _Globals;
  }

  Globals._internal();

  User currentUser;
  Color mainColor = Color(0xFFEB5757);

  MaterialColor mainColorMaterial = MaterialColor(0xFFEB5757, {
    50: Color.fromRGBO(235, 87, 87, .1),
    100: Color.fromRGBO(235, 87, 87, .2),
    200: Color.fromRGBO(235, 87, 87, .3),
    300: Color.fromRGBO(235, 87, 87, .4),
    400: Color.fromRGBO(235, 87, 87, .5),
    500: Color.fromRGBO(235, 87, 87, .6),
    600: Color.fromRGBO(235, 87, 87, .7),
    700: Color.fromRGBO(235, 87, 87, .8),
    800: Color.fromRGBO(235, 87, 87, .9),
    900: Color.fromRGBO(235, 87, 87, 1),
  });
}

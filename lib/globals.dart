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
  Color mainColor = Color(0xFF9B51E0);

  MaterialColor mainColorMaterial = MaterialColor(0xFF9B51E0, {
    50: Color.fromRGBO(155, 81, 224, .1),
    100: Color.fromRGBO(155, 81, 224, .2),
    200: Color.fromRGBO(155, 81, 224, .3),
    300: Color.fromRGBO(155, 81, 224, .4),
    400: Color.fromRGBO(155, 81, 224, .5),
    500: Color.fromRGBO(155, 81, 224, .6),
    600: Color.fromRGBO(155, 81, 224, .7),
    700: Color.fromRGBO(155, 81, 224, .8),
    800: Color.fromRGBO(155, 81, 224, .9),
    900: Color.fromRGBO(155, 81, 224, 1),
  });
}

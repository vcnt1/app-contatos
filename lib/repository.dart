import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'home.dart';
import 'models/user.dart';

Repository repository = Repository();

class Repository {
  static final Repository _Repository = Repository._internal();

  factory Repository() {
    return _Repository;
  }

  Repository._internal();

  Future userDataChanged() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String strUsers = sp.get('users');
    List<User> users = usersFromJson(strUsers);

    int index = users.indexWhere((User e) => e.id == globals.currentUser.id);
    users[index] = globals.currentUser;

    sp.setString('users', json.encode(users));
    sp.setString('logged_user', json.encode(globals.currentUser));
  }

  Future checkIfLogged() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String loggedIser = sp.get('logged_user');
    if (loggedIser == null || !userFromJson(loggedIser).rememberMe) {
      return false;
    } else {
      globals.currentUser = userFromJson(loggedIser);
      updateState();
      return true;
    }
  }

  Future<bool> login({String login, String password}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String strUsers = sp.get('users');

    List<User> users = [];
    bool newUser = true;

    if (strUsers != null) {
      users = usersFromJson(strUsers);
      for (final user in users) {
        if (user.login == login && user.password == password) {
          newUser = false;
          globals.currentUser = user;
        }
      }
    }

    if (newUser) {
      final int userId = users.length + 1 ?? 0;
      globals.currentUser = User(
        id: userId,
        login: login,
        password: password,
        rememberMe: true,
      );

      users.add(globals.currentUser);
      sp.setString('users', json.encode(users));
    }

    updateState();
    sp.setString('logged_user', json.encode(globals.currentUser));

    await Future.delayed(Duration(seconds: 2), () {});
    return true;
  }

  Future logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('logged_user');
    globals.currentUser = User();
    currentUserNotifier.value = User();
    currentUserNotifier.notifyListeners();
  }
}

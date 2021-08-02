// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> usersFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.login,
    this.password,
    this.rememberMe,
    contacts,
  }){
    this.contacts = contacts ?? List<PhoneContact>();
  }

  final int id;
  final String login;
  final String password;
  bool rememberMe;
  List<PhoneContact> contacts;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        login: json["login"],
        password: json["password"],
        rememberMe: json["rememberMe"],
        contacts: ['null', null].contains(json["contacts"]) ? [] : List<PhoneContact>.from(json["contacts"].map((x) => PhoneContact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "password": password,
        "rememberMe": rememberMe,
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
      };
}

class PhoneContact {
  PhoneContact({
    this.name,
    this.phone,
  });

  final String name;
  final String phone;

  factory PhoneContact.fromJson(Map<String, dynamic> json) => PhoneContact(
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
      };
}

import 'dart:math';

import 'package:app_contatos/globals.dart';
import 'package:app_contatos/models/user.dart';
import 'package:app_contatos/repository.dart';
import 'package:app_contatos/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

final currentUserNotifier = ValueNotifier<User>(globals.currentUser);

void updateState() {
  repository.userDataChanged();
  currentUserNotifier.value = globals.currentUser;
  currentUserNotifier.notifyListeners();
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(),
                SelectedContactsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(),
        GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              context: context,
              isScrollControlled: true,
              builder: (_) => Settings(),
            );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 0, 30),
            child: Icon(
              Icons.settings,
              color: globals.mainColor,
            ),
          ),
        ),
      ],
    );
  }
}

class SelectedContactsList extends StatefulWidget {
  const SelectedContactsList({Key key}) : super(key: key);

  @override
  _SelectedContactsListState createState() => _SelectedContactsListState();
}

class _SelectedContactsListState extends State<SelectedContactsList> {
  final List<Color> colors = [Colors.green, Colors.blue, Colors.grey, Colors.red, Colors.pink, Colors.orange, Colors.purple, Colors.brown];
  List<PhoneContact> items = <PhoneContact>[];

  void reload() => setState(() {
        items = globals.currentUser.contacts;
      });

  _launchCaller(String phoneNumber) async {
    final permitted = await Permission.phone.request().isGranted;
    final url = "tel:$phoneNumber";

    if(permitted){
      FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentUserNotifier,
        builder: (context, User value, widget) {
          List<PhoneContact> contacts = value.contacts;
          bool emptyContacts = contacts == null || contacts.isEmpty;
          return Column(
            children: [
              Center(
                child: Text(
                  emptyContacts ? '0 CONTATOS' : 'CLIQUE PARA LIGAR !',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: globals.mainColor),
                ),
              ),
              SizedBox(height: 20),
              emptyContacts
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Clique na Engrenagem para adicionar contatos.'),
                    )
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      direction: Axis.horizontal,
                      children: contacts.map<Widget>(
                        (PhoneContact e) {
                          int random = Random().nextInt(7) + 3;
                          return GestureDetector(
                            onTap: () async => await _launchCaller(e.phone),
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 40 - 10) * .5,
                              decoration: BoxDecoration(
                                color: globals.mainColorMaterial[random * 100],
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
            ],
          );
        });
  }
}

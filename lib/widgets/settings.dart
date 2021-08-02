import 'package:app_contatos/globals.dart';
import 'package:app_contatos/models/user.dart';
import 'package:app_contatos/repository.dart';
import 'package:app_contatos/widgets/bottom_sheet_container.dart';
import 'package:app_contatos/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import '../login.dart';
import 'contacts_list.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      children: [
        BottomSheetHeader(
          title: 'Configurações',
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: currentUserNotifier,
                  builder: (context, User value, widget) => SwitchListTile(
                    title: Text(
                      'Permanecer conectadx',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    activeColor: globals.mainColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    value: value.rememberMe,
                    onChanged: (bool e) {
                      globals.currentUser.rememberMe = e;
                      updateState();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListTile(
                    leading: Icon(
                        Icons.exit_to_app_rounded,
                      color: Colors.black54,
                    ),
                    title: Text(
                      'Sair',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                      repository.logout();
                    },
                  ),
                ),
                Text(
                  'GERENCIAR CONTATOS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                ContactsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

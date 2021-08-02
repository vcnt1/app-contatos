import 'package:app_contatos/globals.dart';
import 'package:app_contatos/models/user.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../home.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  bool accessContactsPermitted = false;
  Future permissionFuture, contactsFuture;

  Future<void> getPermission() async => setState(() {
        permissionFuture = Permission.contacts.request().isGranted;
      });

  @override
  void initState() {
    super.initState();

    permissionFuture = Permission.contacts.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: permissionFuture,
      builder: (context, snapshot) {
        bool requesting = snapshot.connectionState != ConnectionState.done;
        accessContactsPermitted = snapshot.data ?? false;

        if (accessContactsPermitted) {
          contactsFuture = ContactsService.getContacts();
        }

        return requesting
            ? Container()
            : accessContactsPermitted
                ? FutureBuilder(
                    future: contactsFuture,
                    builder: (context, snapshot) {
                      bool canShow = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                      List<Contact> contacts = snapshot.hasData ? List<Contact>.from(snapshot.data) : [];

                      return ValueListenableBuilder(
                        valueListenable: currentUserNotifier,
                        builder: (context, User value, widget) {
                          List<String> addedContacts =
                              globals.currentUser.contacts == null ? <String>[] : globals.currentUser.contacts.map<String>((e) => e.phone).toList();

                          List<Widget> items = canShow
                              ? contacts.map((Contact e) {
                                  Item phone = e.phones.first;
                                  bool alreadyAdded = addedContacts.contains(phone.value);

                                  return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.displayName,
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(phone.value),
                                              alreadyAdded
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        int index = globals.currentUser.contacts.indexWhere(
                                                            (PhoneContact contact) => contact.name == e.displayName && contact.phone == phone.value);
                                                        globals.currentUser.contacts.removeAt(index);
                                                        updateState();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                              color: Colors.red,
                                                            )),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.restore_from_trash_rounded,
                                                              color: Colors.red,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              'Remover',
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        globals.currentUser.contacts.add(
                                                          PhoneContact(
                                                            name: e.displayName,
                                                            phone: phone.value,
                                                          ),
                                                        );
                                                        updateState();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                              color: Colors.grey,
                                                            )),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.add),
                                                            SizedBox(width: 5),
                                                            Text('Adicionar'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList()
                              : [1, 2, 3, 4, 5, 6]
                                  .map(
                                    (e) => Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();

                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: items,
                          );
                        },
                      );
                    },
                  )
                : GestureDetector(
                    onTap: () => getPermission(),
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: globals.mainColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                          child: Text(
                        'Permitir o acesso ao seus contatos.',
                        style: TextStyle(color: globals.mainColor),
                      )),
                    ),
                  );
      },
    );
  }
}

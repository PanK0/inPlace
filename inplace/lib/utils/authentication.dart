import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

// Used to show the user name of the current user
// ignore: non_constant_identifier_names
String? get_user_name() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? userName = FirebaseAuth.instance.currentUser!.displayName;
  return userName;
}

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 24, bottom: 8),
        child: !loggedIn ? const Text('') : Header(get_user_name()!),
      ),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: StyledButton(
                onPressed: () {
                  !loggedIn
                      ? Navigator.of(context).pushNamed('/sign-in')
                      : signOut();
                },
                child: !loggedIn ? const Text('RSVP') : const Text('Logout')),
          ),
          Visibility(
              visible: loggedIn,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 8),
                child: StyledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    child: const Text('Profile')),
              )),
          // Clusters button
          Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/clusters');
                },
                child: const Text('Clusters'),
              )),
        ],
      )
    ]);
  }
}

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../utils/applicationState.dart";
import "../utils/authentication.dart";
import "../widgets/appbar.dart";
import "../widgets/geolocation.dart";
import "../widgets/guestbook.dart";
import "../widgets/widgets.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[
          //Image.asset("assets/map.png"),
          const Geoloc(),
          const SizedBox(height: 8),
          //const IconAndDetail(Icons.calendar_today, "October 30"),
          //const IconAndDetail(Icons.location_city, "San Francisco"),
          // Authentication module
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),

          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Messages in this area"),
          const Paragraph(
            "All messages in an area of two squared kilometers from your position",
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  //const Header("Discussion"),
                  // Guestbook here to add and read messages
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

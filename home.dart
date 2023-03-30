import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:provider/provider.dart'; // new
import 'app_state.dart';
import 'recipes.dart'; // new
import 'src/authentication.dart'; // new
import 'src/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API in use for showing recipes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(6),
        children: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          const Header("header"),
          const Paragraph(
            'lisää resepti',
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  const Header('Discussion'),
                  recipes(
                    messages: appState.recipeMessages,
                    addMessage: (message) => appState.addNameToRecipe(message),
                  ),
                  const Paragraph(
                    '^^^^^^^^',
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

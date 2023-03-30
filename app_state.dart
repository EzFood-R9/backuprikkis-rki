import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'dart:async';
import 'readrecipes.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _recipeSubscription;
  List<ReadRecipes> _recipeMessages = [];
  List<ReadRecipes> get recipeMessages => _recipeMessages;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _recipeSubscription = FirebaseFirestore.instance
            .collection('recipes')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _recipeMessages = [];
          for (final document in snapshot.docs) {
            _recipeMessages.add(
              ReadRecipes(
                name: document.data()['name'] as String,
                instructions: document.data()['instructions'] as String,
                
              ),
              
            );
          }
          debugPrint("testesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttestt");
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _recipeMessages = [];
        _recipeSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addNameToRecipe(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
debugPrint("testesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttestt");
    return FirebaseFirestore.instance
        .collection('recipes')
        .add(<String, dynamic>{
          
      'name': message,
      'instructions': DateTime.now().millisecondsSinceEpoch,
      'materials': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      
    });
    
  }
}

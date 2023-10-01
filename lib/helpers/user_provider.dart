import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _loggedInUser =
      ''; 

  String get loggedInUser => _loggedInUser;

  void setLoggedInUser(String username) {
    _loggedInUser = username;
    notifyListeners(); 
  }
}

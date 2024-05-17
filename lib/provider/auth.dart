import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exceptions.dart';

class Auth with ChangeNotifier {
  String? tokken;
  DateTime? expiryDate;
  String? userId;
  Timer? authTime;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (expiryDate != null &&
        expiryDate!.isAfter(DateTime.now()) &&
        tokken != null) {
      return tokken;
    }
    return null;
  }

  Future<void> signUpUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBgRr6pjRVPikqJEd8hI5pqAym80-BRhdE';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      if (json.decode(responce.body)['error'] != null) {
        throw HttpExceptions(json.decode(responce.body)['error']['message']);
      }
      var responceData = json.decode(responce.body);
      tokken = responceData['idToken'];
      userId = responceData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responceData['expiresIn'])));
      loginTimer();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'tokken': tokken,
        'userId': userId,
        'expiryDate': expiryDate!.toIso8601String()
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    //print(json.decode(responce.body));}
  }

  Future<void> loginUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBgRr6pjRVPikqJEd8hI5pqAym80-BRhdE';
    try {
      final responce = await https.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      //print(json.decode(responce.body));
      if (json.decode(responce.body)['error'] != null) {
        throw HttpExceptions(json.decode(responce.body)['error']['message']);
      }
      var responceData = json.decode(responce.body);
      tokken = responceData['idToken'];
      userId = responceData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responceData['expiresIn'])));
      loginTimer();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'tokken': tokken,
        'userId': userId,
        'expiryDate': expiryDate!.toIso8601String()
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    tokken = null;
    expiryDate = null;
    userId = null;
    if (authTime != null) {
      authTime!.cancel();
      authTime = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void loginTimer() {
    if (authTime != null) {
      authTime!.cancel();
    }
    final remainingTime = expiryDate!.difference(DateTime.now()).inSeconds;
    authTime = Timer(Duration(seconds: remainingTime), (() => logout()));
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(pref.getString('userData').toString())
        as Map<String, Object>;
    if (DateTime.parse(userData['expiryDate'].toString())
        .isBefore(DateTime.now())) {
      return false;
    }
    tokken = userData['tokken'].toString();
    expiryDate = DateTime.parse(userData['expiryDate'].toString());
    userId = userData['userId'].toString();
    notifyListeners();
    loginTimer();
    return true;
  }
}

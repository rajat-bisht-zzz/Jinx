import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _userRole;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  bool get isAdmin {
    return (_userRole == "Host");
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String name, String email, String password,
      AuthMode authMode, String urlString, String role) async {
    const apiKey = 'AIzaSyD3HVmLiH7ZGpgmrLQlhlD0CZtpMVguANw';
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlString?key=$apiKey');
    try {
      final response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        return Future.error(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      if (authMode == AuthMode.Signup) {
        await FirebaseFirestore.instance.collection('users').doc(_userId).set({
          'name': name,
          'email': email,
          'role': role,
        });
        _userRole = role;
      } else {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .get();
        _userRole = userData['role'];
        // Add logic to check userRole and redirect accordingly
      }
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'role' : _userRole
        },
      );
      pref.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(
      String name, String email, String password, String role) async {
    return _authenticate(
        name, email, password, AuthMode.Signup, 'signUp', role);
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(
        '', email, password, AuthMode.Login, 'signInWithPassword', '');
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(pref.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _userRole = extractedUserData['role'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _userRole = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final time = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: time), logOut);
  }
}

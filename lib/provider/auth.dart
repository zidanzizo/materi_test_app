import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  int _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    final url = 'https://api.sourcecode.gq/api/login';
    try {
      final response = await http.post(url,
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      print(response.statusCode);
      final responseData = json.decode(response.body);
      _token = responseData['access_token'];
      _userId = responseData['user']['id'];
      _expiryDate = DateTime.now()
          .add(Duration(milliseconds: responseData['expires_in']));

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> barcodeScan(int userId, String barcode) async {
    final url = 'https://api.sourcecode.gq/api/scan';
    try {
      final response = await http.post(url,
          body: jsonEncode({
            "user_id": userId,
            "barcode": barcode,
          }),
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
            "Authorization": "Bearer $_token",
          });
      print('$userId + $barcode');
      print(response.statusCode);
      final responseData = json.decode(response.body);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Map<String, dynamic>> profile() async {
    if (!isAuth) {
      tryAutoLogin();
    }
    final url = 'https://api.sourcecode.gq/api/profile?user_id=$_userId';
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      final responseData = jsonDecode(response.body);
      var userData = responseData['data'];
      return userData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> task() async {
    final url = 'https://api.sourcecode.gq/api/task?user_id=$_userId';
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      final responseData = jsonDecode(response.body);
      final taskData = responseData['data'];
      return taskData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> history() async {
    final url = 'https://api.sourcecode.gq/api/history?user_id=$_userId';
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      final responseData = jsonDecode(response.body);
      // List<dynamic> data = responseData['data'];
      return responseData['data'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> information() async {
    final url = 'https://api.sourcecode.gq/api/information';
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      print(response.statusCode);
      final responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      return jsonDecode(response.body);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final url = 'https://api.sourcecode.gq/api/logout';
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timetoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}

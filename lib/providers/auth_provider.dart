import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/auth.dart';

class AuthProvider with ChangeNotifier {
  Auth? _auth;
  bool _isAuthenticating;
  final SessionManager _sessionManager;

  AuthProvider()
      : _sessionManager = SessionManager(),
        _isAuthenticating = false;

  bool get isAuth => _auth != null;
  Auth? get auth => _auth;
  bool get isAuthenticating => _isAuthenticating;

  Future<void> _authenticate({
    required String username,
    required String password,
  }) async {
    _isAuthenticating = true;
    try {
      final response = await http.post(
        Uri.parse('${getHostName()}$loginEndpoint'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            "username": username,
            "password": password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData.toString());
      }
      await Future.delayed(const Duration(milliseconds: 1500));
      _auth = Auth.fromAPIResponse(responseData);
      _sessionManager.set('auth_data', _auth!);
    } catch (error) {
      _auth = null;
    }
    _isAuthenticating = false;
    notifyListeners();
  }

  // Future<void> signup(String email, String password) async {
  //   return _authenticate(email, password);
  // }

  Future<void> login(
          {required String username, required String password}) async =>
      _authenticate(
        username: username,
        password: password,
      );

  Future<void> tryAutoLogin() async {
    var _ = await _sessionManager.get('auth_data');
    await Future.delayed(const Duration(milliseconds: 1500));
    if (_ == null) return;
    _auth = Auth.fromJson(_);
    try {
      var headers = {
        'Authorization': 'Token ${_auth!.tokenKey}',
      };
      var request =
          http.Request('GET', Uri.parse('${getHostName()}$verifyUserEndpoint'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
    } catch (error) {
      await _sessionManager.remove('auth_data');
      _auth = null;
    }
  }

  // return type: bool represents if the method executed successfully.
  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${getHostName()}$logoutEndpoint'),
        headers: {
          'Authorization': 'Token ${_auth!.tokenKey}',
        },
      );
      if (response.statusCode >= 400) {
        throw HttpException(json.decode(response.body));
      }
      await _sessionManager.remove('auth_data');
      _auth = null;
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await http.post(
        Uri.parse('${getHostName()}$passwordResetEndpoint'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "email": email,
        }),
      );
    } catch (error) {
      return false;
    }
    return true;
  }
}

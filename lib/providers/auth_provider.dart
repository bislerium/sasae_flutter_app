import 'dart:io';
import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:json_store/json_store.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/auth.dart';

class AuthProvider with ChangeNotifier {
  AuthModel? _authModel;
  final SessionManager _sessionManager;
  final String _authModelKey;

  AuthProvider()
      : _sessionManager = SessionManager(),
        _authModelKey = 'auth';

  bool get getIsAuth => _authModel != null;
  AuthModel? get getAuth => _authModel;

  AuthModel _randAuth() => AuthModel(
        tokenKey: faker.jwt.secret,
        group: faker.randomGenerator.element(UserGroup.values),
        accountID: faker.randomGenerator.integer(1000000),
        profileID: faker.randomGenerator.integer(1000000),
        isVerified: faker.randomGenerator.boolean(),
      );

  Future<void> _authenticate(
      {required String username,
      required String password,
      bool isDemo = demo}) async {
    try {
      if (isDemo) {
        await delay();
        _authModel = _randAuth();
      } else {
        final response = await http
            .post(
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
            )
            .timeout(timeOutDuration);
        final responseData = json.decode(response.body);
        if (response.statusCode >= 400) {
          throw HttpException(responseData.toString());
        }
        _authModel = AuthModel.fromAPIResponse(responseData);
      }
      await flushAuthCredential(_authModel!);
    } catch (error) {
      _authModel = null;
    }
  }

  Future<void> flushAuthCredential(AuthModel authModel) async {
    await _sessionManager.set(_authModelKey, authModel);
  }

  Future<void> setIsVerified(bool isVerified) async {
    if (isVerified != _authModel!.isVerified) {
      await flushAuthCredential(_authModel!..isVerified = isVerified);
    }
  }

  Future<void> login(
          {required String username, required String password}) async =>
      _authenticate(
        username: username,
        password: password,
      );

  Future<void> tryAutoLogin({isDemo = demo}) async {
    var authData = await _sessionManager.get(_authModelKey);
    if (authData == null) return;
    _authModel = AuthModel.fromJson(authData);
    try {
      if (isDemo) {
        await delay();
        return;
      }
      var headers = {
        'Authorization': 'Token ${_authModel!.tokenKey}',
      };
      var request =
          http.Request('GET', Uri.parse('${getHostName()}$verifyUserEndpoint'));

      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(timeOutDuration);

      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
    } catch (error) {
      await removeUser();
    }
  }

  // return type: bool represents if the method executed successfully.
  Future<bool> logout({bool isDemo = demo}) async {
    try {
      if (isDemo) {
        await delay();
      } else {
        final response = await http.post(
          Uri.parse('${getHostName()}$logoutEndpoint'),
          headers: {
            'Authorization': 'Token ${_authModel!.tokenKey}',
          },
        ).timeout(timeOutDuration);
        if (response.statusCode >= 400) {
          throw HttpException(json.decode(response.body));
        }
      }
      await removeUser();
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<bool> resetPassword(String email, {bool isDemo = demo}) async {
    try {
      if (isDemo) {
        await delay();
        return true;
      }
      await http
          .post(
            Uri.parse('${getHostName()}$passwordResetEndpoint'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "email": email,
            }),
          )
          .timeout(timeOutDuration);
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<bool> deleteUser({isDemo = demo}) async {
    try {
      if (!isDemo) {
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Token ${_authModel!.tokenKey}',
        };
        var request = http.Request(
            'DELETE', Uri.parse('${getHostName()}$peopleDeleteEndpoint'));

        request.headers.addAll(headers);

        http.StreamedResponse response =
            await request.send().timeout(timeOutDuration);
        if (response.statusCode >= 400) {
          throw HttpException(await response.stream.bytesToString());
        }
      }
      await removeUser();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> removeUser() async {
    await _sessionManager.remove(_authModelKey);
    JsonStore().clearDataBase();
    _authModel = null;
  }

  Future<bool> changePassword(
      {required String oldPassword,
      required String newPassword1,
      required String newPassword2,
      bool isDemo = demo}) async {
    try {
      if (isDemo) {
        await delay();
        return true;
      }
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Token ${_authModel!.tokenKey}',
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('${getHostName()}$passwordChangeEndpoint'));
      request.fields.addAll({
        'old_password': oldPassword,
        'new_password1': newPassword1,
        'new_password2': newPassword2,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(timeOutDuration);

      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

class Cred {
  final String username;
  final String password;

  Cred(this.username, this.password);
}

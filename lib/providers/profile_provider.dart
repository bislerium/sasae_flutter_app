import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _authP;
  final Dio _dio;
  User? _user;
  List<Post_>? _userPosts;

  ProfileProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  User? get userData => _user;
  List<Post_>? get getUserPostData => _userPosts;

  set setAuthP(AuthProvider authP) => _authP = authP;

  Future<void> initFetchUser({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    switch (_authP.auth!.group) {
      case 'General':
        _user = await PeopleProvider.fetchPeople(
          isDemo: isDemo,
          auth: _authP.auth!,
        );
        break;
      case 'NGO':
        _user = await NGOProvider.fetchNGO(
          isDemo: isDemo,
          auth: _authP.auth!,
        );
        break;
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await initFetchUser();
  }

  Future<void> intiFetchUserPosts({int? userID, UserType? userType}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _userPosts = await fetchUserPosts(userID: userID, userType: userType);
  }

  Future<List<Post_>?> fetchUserPosts({int? userID, UserType? userType}) async {
    late String endpoint;
    if (userID == null || userType == null) {
      switch (_authP.auth!.group) {
        case 'General':
          endpoint = '$peopleEndpoint${_authP.auth!.profileID}/posts/';
          break;
        case 'NGO':
          endpoint = '$ngoEndpoint${_authP.auth!.profileID}/posts/';
          break;
      }
    } else {
      endpoint = 'api/${userType.name}/$userID/posts/';
    }
    try {
      var response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Token ${_authP.auth!.tokenKey}',
          },
        ),
      );
      return (response.data['results'] as List)
          .map((element) => Post_.fromAPIResponse(element))
          .toList();
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> refreshUserPosts({int? userID, UserType? userType}) async {
    await intiFetchUserPosts(userID: userID, userType: userType);
    notifyListeners();
  }

  Future<bool> delete({required int postID}) async {
    print(postID);
    try {
      await _dio.delete(
        '$postEndpoint$postID/delete/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      _userPosts!.removeWhere((element) => element.id == postID);
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    }
  }
}

enum UserType { people, ngo }

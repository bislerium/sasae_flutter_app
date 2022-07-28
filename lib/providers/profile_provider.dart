import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_interface.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';

class ProfileProvider with ChangeNotifier {
  late AuthProvider _authP;
  final Dio _dio;
  UserModel? _user;

  ProfileProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 10 * 1000,
          ),
        );

  UserModel? get getUserData => _user;

  set setAuthP(AuthProvider authP) => _authP = authP;

  Future<void> initFetchUser() async {
    switch (_authP.getAuth!.group) {
      case UserGroup.general:
        _user = await PeopleProvider.fetchPeople(
          auth: _authP.getAuth!,
        );
        break;
      case UserGroup.ngo:
        _user = await NGOProvider.fetchNGO(
          auth: _authP.getAuth!,
        );
        break;
    }
    notifyListeners();
  }

  void disposeUserProfile() => _user = null;

  Future<bool> deletePost({required int postID}) async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        await _dio.delete(
          '$postEndpoint$postID/delete/',
          options: Options(headers: {
            'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
          }),
        );
      }
      return true;
    } on DioError {
      return false;
    }
  }
}

class ProfilePostProvider with ChangeNotifier implements IPost {
  late AuthProvider _authP;
  final Dio _dio;
  List<Post_Model>? _profilePosts;

  ProfilePostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 10 * 1000,
          ),
        );

  @override
  List<Post_Model>? get getPosts => _profilePosts;

  set setAuthP(AuthProvider authP) => _authP = authP;
  String? _url;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  bool get getHasMore => _hasMore;

  Future<void> fetchProfilePosts() async {
    if (_isLoading) return;
    if (!_hasMore) return;
    _isLoading = true;
    try {
      List<Post_Model> fetchedPosts;
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        fetchedPosts = PostProvider.randPosts();
      } else {
        var response = await _dio.get(
          _url!,
          options: Options(
            headers: {
              'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
            },
          ),
        );
        _url = response.data['next'];
        if (_url == null) _hasMore = false;
        fetchedPosts = (response.data['results'] as List)
            .map((element) => Post_Model.fromAPIResponse(element))
            .toList();
      }
      _profilePosts ??= [];
      _profilePosts?.addAll(fetchedPosts);
      // ignore: empty_catches
    } on DioError {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProfilePosts() async {
    _hasMore = true;
    _profilePosts = null;
    _isLoading = false;
    await fetchProfilePosts();
    notifyListeners();
  }

  void disposeProfilePosts() {
    _url = null;
    _profilePosts = null;
    _hasMore = true;
    _isLoading = false;
  }
}

class NGOProfilePostProvider extends ProfilePostProvider {
  void setURL({required int userID, required UserType userType}) {
    _url = 'api/${userType.name}/$userID/posts/?limit=$limit';
  }
}

class UserProfilePostProvider extends ProfilePostProvider {
  void setURL() {
    switch (_authP.getAuth!.group) {
      case UserGroup.general:
        _url =
            '$peopleEndpoint${_authP.getAuth!.profileID}/posts/?limit=$limit';
        break;
      case UserGroup.ngo:
        _url = '$ngoEndpoint${_authP.getAuth!.profileID}/posts/?limit=$limit';
        break;
    }
  }
}

enum UserType { people, ngo }

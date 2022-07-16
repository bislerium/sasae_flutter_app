import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/providers/post_interface.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';

class ProfileProvider with ChangeNotifier implements IPost {
  late AuthProvider _authP;
  final Dio _dio;
  UserModel? _user;
  List<Post_Model>? _userPosts;

  ProfileProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 10 * 1000,
          ),
        );

  UserModel? get getUserData => _user;

  @override
  List<Post_Model>? get getPostData => _userPosts;

  set setAuthP(AuthProvider authP) => _authP = authP;

  Future<void> initFetchUser({bool isDemo = demo}) async {
    switch (_authP.getAuth!.group) {
      case UserGroup.general:
        _user = await PeopleProvider.fetchPeople(
          isDemo: isDemo,
          auth: _authP.getAuth!,
        );
        break;
      case UserGroup.ngo:
        _user = await NGOProvider.fetchNGO(
          isDemo: isDemo,
          auth: _authP.getAuth!,
        );
        break;
    }
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await initFetchUser();
  }

  String? _url;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  bool get getHasMore => _hasMore;

  void setURL({int? userID, UserType? userType}) {
    if (userID == null || userType == null) {
      switch (_authP.getAuth!.group) {
        case UserGroup.general:
          _url =
              '$peopleEndpoint${_authP.getAuth!.profileID}/posts/?limit=$limit';
          break;
        case UserGroup.ngo:
          _url = '$ngoEndpoint${_authP.getAuth!.profileID}/posts/?limit=$limit';
          break;
      }
    } else {
      _url = 'api/${userType.name}/$userID/posts/?limit=$limit';
    }
    print(_url);
  }

  Future<void> fetchUserPosts({bool isDemo = demo}) async {
    if (_isLoading) return;
    if (!_hasMore) return;
    _isLoading = true;
    try {
      List<Post_Model> fetchedPosts;
      if (isDemo) {
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
      _userPosts ??= [];
      _userPosts?.addAll(fetchedPosts);
      // ignore: empty_catches
    } on DioError {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUserPosts({int? userID, UserType? userType}) async {
    setURL(userID: userID, userType: userType);
    _hasMore = true;
    _userPosts = null;
    _isLoading = false;
    await fetchUserPosts();
    notifyListeners();
  }

  Future<bool> deletePost({required int postID, bool isDemo = demo}) async {
    try {
      if (isDemo) {
        await delay();
      } else {
        await _dio.delete(
          '$postEndpoint$postID/delete/',
          options: Options(headers: {
            'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
          }),
        );
      }

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

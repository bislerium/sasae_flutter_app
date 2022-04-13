import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/api_config.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_post.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class PostProvider with ChangeNotifier {
  late AuthProvider _authP;
  List<Post_Model>? _posts;
  final Dio _dio;

  PostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  List<Post_Model>? get getPostData => _posts;
  set setAuthP(AuthProvider auth) => _authP = auth;

  List<Post_Model> _randPosts() {
    var random = Random();
    int length = random.nextInt(100 - 20) + 20;
    return List.generate(
      length,
      (index) {
        return Post_Model(
          id: index,
          relatedTo: List.generate(
            random.nextInt(8 - 1) + 1,
            (index) => faker.lorem.word(),
          ),
          postContent:
              faker.lorem.sentences(random.nextInt(15 - 2) + 2).join(' '),
          postedOn: faker.date.dateTime(minYear: 2018, maxYear: 2022),
          postType: faker.randomGenerator.fromPattern([
            'Normal Post',
            'Poll Post',
            'Join Request Post',
            'Petition Request Post'
          ]),
          isPostedAnonymously: faker.randomGenerator.boolean(),
          isPokedToNGO: faker.randomGenerator.boolean(),
        );
      },
    );
  }

  Future<void> intiFetchPosts({bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) {
      _posts = _randPosts();
    } else {
      _posts = await fetchPosts();
    }
    notifyListeners();
  }

  Future<List<Post_Model>?> fetchPosts() async {
    try {
      var response = await _dio.get(
        postsEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Token ${_authP.auth!.tokenKey}',
          },
        ),
      );
      return (response.data['results'] as List)
          .map((element) => Post_Model.fromAPIResponse(element))
          .toList();
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> refreshPosts() async {
    await intiFetchPosts();
  }

  Future<bool> report({required int postID}) async {
    try {
      await _dio.post(
        '$postEndpoint$postID/report/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    }
  }
}

class PostCreateProvider with ChangeNotifier {
  late AuthProvider _authP;
  final Dio _dio;

  PostCreateProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        ),
        _createPostType = PostType.normal,
        _normalPostCreate = NormalPostCUModel(),
        _pollPostCreate = PollPostCUModel(),
        _requestPostCreate = RequestPostCUModel();

  set setAuthP(AuthProvider auth) => _authP = auth;

  List<String>? _postRelatedTo;
  List<NGO__Model>? _ngoOptions;

  List<String>? get getPostRelatedToData => _postRelatedTo;
  List<NGO__Model>? get getNGOOptionsData => _ngoOptions;

  Future<void> initPostRelatedTo() async {
    _postRelatedTo = await getPostRelatedTo();
    notifyListeners();
  }

  Future<void> initNGOOptions() async {
    _ngoOptions = await getNGOOptions();
    notifyListeners();
  }

  Future<void> refreshPostRelatedTo() async {
    await initPostRelatedTo();
  }

  Future<void> refreshNGOOptions() async {
    await initNGOOptions();
  }

  Future<List<String>?> getPostRelatedTo() async {
    try {
      var response = await _dio.get(
        postRelatedToEndpoint,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return response.data['options'].cast<String>();
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<List<NGO__Model>?> getNGOOptions() async {
    try {
      var response = await _dio.get(
        postNGOsEndpoint,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return (response.data as List)
          .map((e) => NGO__Model.fromAPIResponse(e))
          .toList();
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  PostType _createPostType;

  PostType get getCreatePostType => _createPostType;

  set setCreatePostType(PostType type) {
    if (_createPostType != type) {
      _createPostType = type;
      notifyListeners();
    }
  }

  Future<void> Function()? _postCreateHandler;

  Future<void> Function()? get getPostCreateHandler => _postCreateHandler;

  set setPostHandler(Future<void> Function()? handler) {
    if (_postCreateHandler != handler) {
      _postCreateHandler = handler;
      notifyListeners();
    }
  }

  final NormalPostCUModel _normalPostCreate;
  final PollPostCUModel _pollPostCreate;
  final RequestPostCUModel _requestPostCreate;

  NormalPostCUModel get getNormalPostCreate => _normalPostCreate;
  PollPostCUModel get getPollPostCreate => _pollPostCreate;
  RequestPostCUModel get getRequestPostCreate => _requestPostCreate;

  Future<bool> createNormalPost() async {
    try {
      var headers = {
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${getHostName()}$postNormalPostEndpoint',
        ),
      );
      request.fields.addAll({
        'post_head': json.encode(
          {
            "related_to": _normalPostCreate.getRelatedTo,
            "post_content": _normalPostCreate.getPostContent,
            "is_anonymous": _normalPostCreate.getIsAnonymous
          },
        ),
        'poked_to': json.encode(_normalPostCreate.getPokedNGO),
      });

      if (_normalPostCreate.getPostImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'post_image', _normalPostCreate.getPostImage!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));

      var jsonResponse = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode >= 400) {
        throw HttpException(jsonResponse);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> createPollPost() async {
    try {
      var headers = {
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
        'Content-Type': 'application/json',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${getHostName()}$postPollPostEndpoint'),
      );
      request.body = json.encode({
        "poll_post": {
          "option": _pollPostCreate.getPollOptions,
          "ends_on": _pollPostCreate.getPollDuration == null
              ? null
              : Jiffy(_pollPostCreate.getPollDuration)
                  .format("yyyy-MM-dd'T'HH:mm:ss"),
        },
        "post_head": {
          "related_to": _pollPostCreate.getRelatedTo,
          "post_content": _pollPostCreate.getPostContent,
          "is_anonymous": _pollPostCreate.getIsAnonymous
        },
        "poked_to": _pollPostCreate.getPokedNGO
      });
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));

      var jsonResponse = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode >= 400) {
        throw HttpException(jsonResponse);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> createRequestPost() async {
    try {
      var headers = {
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
        'Content-Type': 'application/json',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${getHostName()}$postRequestPostEndpoint'),
      );
      request.body = json.encode({
        "request_post": {
          "min": _requestPostCreate.getMin,
          "max": _requestPostCreate.getMax,
          "target": _requestPostCreate.getTarget,
          "ends_on": _requestPostCreate.getRequestDuration == null
              ? null
              : Jiffy(_requestPostCreate.getRequestDuration)
                  .format("yyyy-MM-dd'T'HH:mm:ss"),
          "request_type": _requestPostCreate.getRequestType
        },
        "post_head": {
          "related_to": _requestPostCreate.getRelatedTo,
          "post_content": _requestPostCreate.getPostContent,
          "is_anonymous": _requestPostCreate.getIsAnonymous
        },
        "poked_to": _requestPostCreate.getPokedNGO
      });
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));

      var jsonResponse = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode >= 400) {
        throw HttpException(jsonResponse);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

class PostUpdateProvider with ChangeNotifier {
  late AuthProvider _authP;

  set setAuthP(AuthProvider auth) => _authP = auth;

  NormalPostCUModel? _normalPostCU;
  PollPostCUModel? _pollPostCU;
  RequestPostCUModel? _requestPostCU;
  PostType? _updatePostType;

  NormalPostCUModel? get getNormalPostCU => _normalPostCU;
  PollPostCUModel? get getPollPostCU => _pollPostCU;
  RequestPostCUModel? get getRequestPostCU => _requestPostCU;
  PostType? get getUpdatePostType => _updatePostType;

  void nullifyNormalPostCU() => _normalPostCU = null;
  void nullifyPollPostCU() => _pollPostCU = null;
  void nullifyRequestPostCU() => _requestPostCU = null;
  void nullifyPostType() => _updatePostType = null;

  void nullfyPerPostType() {
    switch (_updatePostType) {
      case PostType.normal:
        nullifyNormalPostCU();
        break;
      case PostType.poll:
        nullifyPollPostCU();
        break;
      case PostType.request:
        nullifyRequestPostCU();
        break;
      default:
        nullifyNormalPostCU();
        nullifyPollPostCU();
        nullifyRequestPostCU();
    }
    nullifyPostType();
  }

  Future<void> Function()? _postUpdateHandler;

  Future<void> Function()? get getPostUpdateHandler => _postUpdateHandler;

  set setPostHandler(Future<void> Function()? handler) {
    if (_postUpdateHandler != handler) {
      _postUpdateHandler = handler;
      notifyListeners();
    }
  }

  Future<void> retrieveUpdatePost({required int postID}) async {
    try {
      final request = http.MultipartRequest(
          'GET', Uri.parse('${getHostName()}$postEndpoint$postID/detail/'));

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
      };

      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        throw HttpException(responseBody);
      }

      await Future.delayed(const Duration(seconds: 1));

      var jsonBody = json.decode(responseBody);

      switch (jsonBody['post_type']) {
        case 'Normal':
          _normalPostCU = NormalPostCUModel.fromAPIResponse(jsonBody);
          if (_normalPostCU?.getPostImageLink != null) {
            _normalPostCU!.setPostImage =
                await imageURLToXFile(_normalPostCU!.getPostImageLink!);
          }
          _updatePostType = PostType.normal;
          break;
        case 'Poll':
          _pollPostCU = PollPostCUModel.fromAPIResponse(jsonBody);
          _updatePostType = PostType.poll;
          break;
        case 'Request':
          _requestPostCU = RequestPostCUModel.fromAPIResponse(jsonBody);
          _updatePostType = PostType.request;
          break;
      }
      notifyListeners();
    } catch (error) {
      print(error);
      _normalPostCU = null;
      _pollPostCU = null;
      _requestPostCU = null;
      _updatePostType = null;
    }
  }

  Future<void> refreshRetrieveUpdatePost({required int postID}) async {
    await retrieveUpdatePost(postID: postID);
  }

  Future<bool> updatePost({
    required int postID,
    required PostType postType,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token ${_authP.auth!.tokenKey}',
      };
      var uri = Uri.parse(
        '${getHostName()}$postEndpoint$postID/detail/',
      );

      dynamic request;

      if (postType == PostType.normal) {
        request = http.MultipartRequest('PUT', uri);
      } else {
        request = http.Request('PUT', uri);
      }
      switch (postType) {
        case PostType.normal:
          headers.remove('Content-Type');
          request.fields.addAll({
            'post_head': json.encode(
              {
                "related_to": _normalPostCU!.getRelatedTo,
                "post_content": _normalPostCU!.getPostContent,
                "is_anonymous": _normalPostCU!.getIsAnonymous
              },
            ),
            'poked_to': json.encode(_normalPostCU!.getPokedNGO),
          });
          if (_normalPostCU!.getPostImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'post_image', _normalPostCU!.getPostImage!.path));
          }
          break;
        case PostType.poll:
          request.body = json.encode({
            "poll_post": {
              "option": _pollPostCU!.getPollOptions,
              "ends_on": _pollPostCU!.getPollDuration == null
                  ? null
                  : Jiffy(_pollPostCU!.getPollDuration)
                      .format("yyyy-MM-dd'T'HH:mm:ss"),
            },
            "post_head": {
              "related_to": _pollPostCU!.getRelatedTo,
              "post_content": _pollPostCU!.getPostContent,
              "is_anonymous": _pollPostCU!.getIsAnonymous
            },
            "poked_to": _pollPostCU!.getPokedNGO
          });
          break;
        case PostType.request:
          request.body = json.encode({
            "request_post": {
              "min": _requestPostCU!.getMin,
              "max": _requestPostCU!.getMax,
              "target": _requestPostCU!.getTarget,
              "ends_on": _requestPostCU!.getRequestDuration == null
                  ? null
                  : Jiffy(_requestPostCU!.getRequestDuration)
                      .format("yyyy-MM-dd'T'HH:mm:ss"),
              "request_type": _requestPostCU!.getRequestType
            },
            "post_head": {
              "related_to": _requestPostCU!.getRelatedTo,
              "post_content": _requestPostCU!.getPostContent,
              "is_anonymous": _requestPostCU!.getIsAnonymous
            },
            "poked_to": _requestPostCU!.getPokedNGO
          });
          break;
      }
      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 5));

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        throw HttpException(responseBody);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

//------------------------------Normal Post --------------------------------//

class NormalPostProvider with ChangeNotifier {
  NormalPostModel? _normalPost;
  late AuthProvider _authP;
  final Dio _dio;

  NormalPostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;
  NormalPostModel? get normalPostData => _normalPost;

  NormalPostModel _randNormalPost() {
    Random rand = Random();
    bool upvoted = faker.randomGenerator.boolean();
    return NormalPostModel(
      attachedImage: faker.randomGenerator.boolean()
          ? faker.image.image(random: true)
          : null,
      upVote: faker.randomGenerator
          .numbers(1500, faker.randomGenerator.integer(1500)),
      downVote: faker.randomGenerator
          .numbers(1500, faker.randomGenerator.integer(1500)),
      upVoted: upvoted,
      downVoted: upvoted ? false : faker.randomGenerator.boolean(),
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
              )),
      postType: 'Normal Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
    );
  }

  Future<void> initFetchNormalPost(
      {required int postID, bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (isDemo) {
      _normalPost = _randNormalPost();
    } else {
      _normalPost = await fetchNormalPost(postID: postID);
    }
    notifyListeners();
  }

  Future<NormalPostModel?> fetchNormalPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$postEndpoint$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return NormalPostModel.fromAPIResponse(response.data);
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> refreshNormalPost({required int postID}) async {
    await initFetchNormalPost(postID: postID);
  }

  Future<bool> toggleReaction(NormalPostReactionType type) async {
    try {
      late String uri;
      switch (type) {
        case NormalPostReactionType.upVote:
          uri = '$postEndpoint${_normalPost!.id}/upvote/';
          break;
        case NormalPostReactionType.downVote:
          uri = '$postEndpoint${_normalPost!.id}/downvote/';
      }
      await _dio.post(
        uri,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    }
  }

  void nullifyNormalPost() => _normalPost = null;
}

//--------------------------------Poll Post ----------------------------------//

class PollPostProvider with ChangeNotifier {
  PollPostModel? _pollPost;
  late AuthProvider _authP;
  final Dio _dio;

  PollPostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;

  PollPostModel? get pollPostData => _pollPost;

  PollPostModel _randPollPost() {
    Random rand = Random();
    var pollOptions = List.generate(
      faker.randomGenerator.integer(10, min: 2),
      (index) => PollOptionModel(
        id: faker.randomGenerator.integer(1500),
        option: faker.food.dish(),
        reaction: faker.randomGenerator
            .numbers(500, faker.randomGenerator.integer(500)),
      ),
    );
    int? choice = faker.randomGenerator.boolean()
        ? null
        : (faker.randomGenerator.element(pollOptions)).id;
    return PollPostModel(
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
              )),
      postType: 'Poll Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
      endsOn: faker.randomGenerator.boolean()
          ? faker.date.dateTime(
              minYear: DateTime.now().year - 1,
              maxYear: DateTime.now().year + 1)
          : null,
      polls: pollOptions,
      choice: choice,
    );
  }

  Future<void> initFetchPollPost(
      {required int postID, bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) {
      _pollPost = _randPollPost();
    } else {
      _pollPost = await fetchPollPost(postID: postID);
    }
    notifyListeners();
  }

  Future<PollPostModel?> fetchPollPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$postEndpoint$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return PollPostModel.fromAPIResponse(response.data);
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> refreshPollPost({required int postID}) async {
    await initFetchPollPost(postID: postID);
  }

  Future<bool> pollTheOption({required int optionID}) async {
    try {
      await _dio.post(
        '$postEndpoint${_pollPost!.id}/poll/$optionID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    }
  }

  void nullifyPollPost() => _pollPost = null;
}

//-------------------------------Request Post --------------------------------//

class RequestPostProvider with ChangeNotifier {
  RequestPostModel? _requestPost;
  late AuthProvider _authP;
  final Dio _dio;

  RequestPostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;

  RequestPostModel? get requestPostData => _requestPost;

  RequestPostModel _randRequestPost() {
    Random rand = Random();
    int min = faker.randomGenerator.integer(1500);
    int target = faker.randomGenerator.integer(2000, min: min);
    int? max = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(3000, min: target)
        : null;
    int numReaction = faker.randomGenerator.integer(max ?? (target * 2));
    return RequestPostModel(
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
              )),
      postType: 'Request Post',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
      endsOn: faker.date.dateTime(
          minYear: DateTime.now().year - 1, maxYear: DateTime.now().year + 1),
      isParticipated: numReaction > 0 ? faker.randomGenerator.boolean() : false,
      min: min,
      target: target,
      max: max,
      reaction: faker.randomGenerator
          .numbers(1500, faker.randomGenerator.integer(1500)),
      requestType: faker.randomGenerator.fromPattern(['Join', 'Petition']),
    );
  }

  Future<void> intiFetchRequestPost(
      {required int postID, bool isDemo = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (isDemo) {
      _requestPost = _randRequestPost();
    } else {
      _requestPost = await fetchRequestPost(postID: postID);
    }
    notifyListeners();
  }

  Future<RequestPostModel?> fetchRequestPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$postEndpoint$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      return RequestPostModel.fromAPIResponse(response.data);
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> refreshRequestPost({required int postID}) async {
    await intiFetchRequestPost(postID: postID);
  }

  //Sign for petition and join for Joinform
  Future<bool> participateRequest() async {
    try {
      await _dio.post(
        '$postEndpoint${_requestPost!.id}/participate/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      _requestPost!.reaction.add(_authP.auth!.profileID);
      _requestPost!.isParticipated = true;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    }
  }

  void nullifyRequestPost() => _requestPost = null;
}

enum PostType {
  normal,
  poll,
  request,
}

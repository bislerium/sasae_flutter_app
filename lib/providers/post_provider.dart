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
import 'package:sasae_flutter_app/models/post/post_create.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';

class PostProvider with ChangeNotifier {
  late AuthProvider _authP;
  List<Post_>? _posts;
  final Dio _dio;

  PostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 5 * 1000,
          ),
        );

  List<Post_>? get postData => _posts;
  set setAuthP(AuthProvider auth) => _authP = auth;

  List<Post_> _randPosts() {
    var random = Random();
    int length = random.nextInt(100 - 20) + 20;
    return List.generate(
      length,
      (index) {
        return Post_(
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

  Future<List<Post_>?> fetchPosts() async {
    try {
      var response = await _dio.get(
        posts,
        options: Options(
          headers: {
            'Authorization': 'Token ${_authP.auth!.tokenKey}',
            'Keep-Alive': 'timeout=5, max=10',
          },
        ),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      var body = response.data;
      return (body['results'] as List)
          .map((element) => Post_.fromAPIResponse(element))
          .toList();
    } catch (error) {
      return null;
    }
  }

  Future<void> refreshPosts() async {
    await intiFetchPosts();
  }

  Future<bool> report({required int postID}) async {
    try {
      var response = await _dio.post(
        '$post$postID/report/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      return true;
    } catch (error) {
      print(error);
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
        _normalPostCreate = NormalPostCreate(),
        _pollPostCreate = PollPostCreate(),
        _requestPostCreate = RequestPostCreate();

  set setAuthP(AuthProvider auth) => _authP = auth;

  List<String>? _postRelatedTo;
  List<NGO__>? _ngoOptions;

  List<String>? get getPostRelatedToData => _postRelatedTo;
  List<NGO__>? get getNGOOptionsData => _ngoOptions;

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
        postRelatedTo,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      // await Future.delayed(const Duration(seconds: 2));
      return response.data['options'].cast<String>();
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<NGO__>?> getNGOOptions() async {
    try {
      var response = await _dio.get(
        postNGOs,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      return (response.data as List)
          .map((e) => NGO__.fromAPIResponse(e))
          .toList();
    } catch (error) {
      print(error);
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

  Future<void> Function()? _postHandler;

  Future<void> Function()? get getPostHandler => _postHandler;

  set setPostHandler(Future<void> Function()? handler) {
    if (_postHandler != handler) {
      _postHandler = handler;
      notifyListeners();
    }
  }

  final NormalPostCreate _normalPostCreate;
  final PollPostCreate _pollPostCreate;
  final RequestPostCreate _requestPostCreate;

  NormalPostCreate get getNormalPostCreate => _normalPostCreate;
  PollPostCreate get getPollPostCreate => _pollPostCreate;
  RequestPostCreate get getRequestPostCreate => _requestPostCreate;

  Future<bool> createNormalPost() async {
    try {
      var formData = FormData.fromMap(
        {
          "json": json.encode({
            "post_head": {
              "related_to": _normalPostCreate.getRelatedTo,
              "post_content": _normalPostCreate.getPostContent,
              "is_anonymous": _normalPostCreate.getIsAnonymous
            },
            "poked_to": _normalPostCreate.getPokedNGO
          }),
          'post_image': _normalPostCreate.getPostImage == null
              ? null
              : await MultipartFile.fromFile(
                  _normalPostCreate.getPostImage!.path,
                ),
        },
      );
      var response = await _dio.post(
        '${getHostName()}$postNormalPost',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
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
        Uri.parse('${getHostName()}$postPollPost'),
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

      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
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
        Uri.parse('${getHostName()}$postRequestPost'),
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
      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 400) {
        throw HttpException(await response.stream.bytesToString());
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
  NormalPost? _normalPost;
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
  NormalPost? get normalPostData => _normalPost;

  NormalPost _randNormalPost() {
    Random rand = Random();
    bool upvoted = faker.randomGenerator.boolean();
    return NormalPost(
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
          (index) => NGO__(
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

  Future<NormalPost?> fetchNormalPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$post$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      var body = response.data;
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(body);
      }
      return NormalPost.fromAPIResponse(body);
    } catch (error) {
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
          uri = '$post${_normalPost!.id}/upvote/';
          break;
        case NormalPostReactionType.downVote:
          uri = '$post${_normalPost!.id}/downvote/';
      }
      var response = await _dio.post(
        uri,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void nullifyNormalPost() => _normalPost = null;
}

//--------------------------------Poll Post ----------------------------------//

class PollPostProvider with ChangeNotifier {
  PollPost? _pollPost;
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

  PollPost? get pollPostData => _pollPost;

  PollPost _randPollPost() {
    Random rand = Random();
    var pollOptions = List.generate(
      faker.randomGenerator.integer(10, min: 2),
      (index) => PollOption(
        id: faker.randomGenerator.integer(1500),
        option: faker.food.dish(),
        reaction: faker.randomGenerator
            .numbers(500, faker.randomGenerator.integer(500)),
      ),
    );
    int? choice = faker.randomGenerator.boolean()
        ? null
        : (faker.randomGenerator.element(pollOptions)).id;
    return PollPost(
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__(
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

  Future<PollPost?> fetchPollPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$post$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      var body = response.data;
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(body);
      }
      return PollPost.fromAPIResponse(body);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> refreshPollPost({required int postID}) async {
    await initFetchPollPost(postID: postID);
  }

  Future<bool> pollTheOption({required int optionID}) async {
    try {
      var response = await _dio.post(
        '$post${_pollPost!.id}/poll/$optionID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void nullifyPollPost() => _pollPost = null;
}

//-------------------------------Request Post --------------------------------//

class RequestPostProvider with ChangeNotifier {
  RequestPost? _requestPost;
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

  RequestPost? get requestPostData => _requestPost;

  RequestPost _randRequestPost() {
    Random rand = Random();
    int min = faker.randomGenerator.integer(1500);
    int target = faker.randomGenerator.integer(2000, min: min);
    int? max = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(3000, min: target)
        : null;
    int numReaction = faker.randomGenerator.integer(max ?? (target * 2));
    return RequestPost(
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__(
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

  Future<RequestPost?> fetchRequestPost({required int postID}) async {
    try {
      var response = await _dio.get(
        '$post$postID/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      var body = response.data;
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(body);
      }
      print(body);
      print('-----------------------------------');
      print(RequestPost.fromAPIResponse(body));
      print('-----------------------------------');
      return RequestPost.fromAPIResponse(body);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> refreshRequestPost({required int postID}) async {
    await intiFetchRequestPost(postID: postID);
  }

  //Sign for petition and join for Joinform
  Future<bool> participateRequest() async {
    try {
      var response = await _dio.post(
        '$post${_requestPost!.id}/participate/',
        options: Options(headers: {
          'Authorization': 'Token ${_authP.auth!.tokenKey}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == null || statusCode >= 400) {
        throw HttpException(response.data);
      }
      _requestPost!.reaction.add(_authP.auth!.profileID);
      _requestPost!.isParticipated = true;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
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

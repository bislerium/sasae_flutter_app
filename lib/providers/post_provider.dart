import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/config.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_post.dart';
import 'package:sasae_flutter_app/models/post/post_.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/post_interface.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';

class PostProvider with ChangeNotifier implements IPost {
  late AuthProvider _authP;
  List<Post_Model>? _posts;
  final Dio _dio;

  PostProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 10 * 1000,
          ),
        );

  @override
  List<Post_Model>? get getPosts => _posts;
  set setAuthP(AuthProvider auth) => _authP = auth;

  static List<Post_Model> randPosts() {
    var random = Random();
    return List.generate(
      limit,
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
          postType: faker.randomGenerator
              .element(['Normal', 'Poll', 'Join Request', 'Petition Request']),
          isPostedAnonymously: faker.randomGenerator.boolean(),
          isPokedToNGO: faker.randomGenerator.boolean(),
        );
      },
    );
  }

  String? _url = postsEndpoint;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  bool get getHasMore => _hasMore;

  Future<void> fetchPosts() async {
    if (_isLoading) return;
    if (!_hasMore) return;
    _isLoading = true;
    try {
      List<Post_Model> fetchedPosts;
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        fetchedPosts = randPosts();
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
      _posts ??= [];
      _posts?.addAll(fetchedPosts);
      // ignore: empty_catches
    } on DioError {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    disposePosts();
    await fetchPosts();
  }

  void disposePosts() {
    _url = postsEndpoint;
    _hasMore = true;
    _posts = null;
    _isLoading = false;
  }

  Future<bool> report({required int postID}) async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        await _dio.post(
          '$postEndpoint$postID/report/',
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

class PostCreateProvider with ChangeNotifier {
  late AuthProvider _authP;
  final Dio _dio;

  PostCreateProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: getHostName(),
            receiveDataWhenStatusError: true,
            connectTimeout: 10 * 1000,
          ),
        ),
        _createPostType = PostType.normal,
        _normalPostCreate = NormalPostCUModel(),
        _pollPostCreate = PollPostCUModel(),
        _requestPostCreate = RequestPostCUModel();

  void reset() {
    _postRelatedTo = null;
    _ngoOptions = null;
    _postCreateHandler = null;
  }

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
    if (StartupConfigProvider.getIsDemo) {
      await delay(random: false);
      return faker.lorem
          .words(faker.randomGenerator.integer(30, min: 5))
          .toSet()
          .toList();
    }
    try {
      var response = await _dio.get(
        postRelatedToEndpoint,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        }),
      );
      return response.data['options'].cast<String>();
    } on DioError {
      return null;
    }
  }

  List<NGO__Model> _randNGOOptions() => List.generate(
        faker.randomGenerator.integer(40, min: 10),
        (index) => NGO__Model(
          id: faker.randomGenerator.integer(50000),
          orgName: faker.company.name(),
          orgPhoto: faker.image.image(random: true),
          fieldOfWork: faker.randomGenerator
              .amount((i) => faker.randomGenerator.element(_postRelatedTo!), 12)
              .toSet()
              .toList(),
        ),
      );

  Future<List<NGO__Model>?> getNGOOptions() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay(random: false);
        return _randNGOOptions();
      }
      var response = await _dio.get(
        postNGOsEndpoint,
        options: Options(headers: {
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        }),
      );
      return (response.data as List)
          .map((e) => NGO__Model.fromAPIResponse(e))
          .toList();
    } on DioError {
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
      if (StartupConfigProvider.getIsDemo) {
        await delay();
        return true;
      }
      var headers = {
        'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
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
          await request.send().timeout(timeOutDuration);

      var jsonResponse = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode >= 400) {
        throw HttpException(jsonResponse);
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> createPollPost() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        var headers = {
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
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
            await request.send().timeout(timeOutDuration);

        var jsonResponse = jsonDecode(await response.stream.bytesToString());

        if (response.statusCode >= 400) {
          throw HttpException(jsonResponse);
        }
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> createRequestPost() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        var headers = {
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
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
            await request.send().timeout(timeOutDuration);

        var jsonResponse = jsonDecode(await response.stream.bytesToString());

        if (response.statusCode >= 400) {
          throw HttpException(jsonResponse);
        }
      }

      return true;
    } catch (error) {
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
  void nullifyUpdatePostType() => _updatePostType = null;

  void nullifyPerPostType() {
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
    nullifyUpdatePostType();
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
        'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
      };

      request.headers.addAll(headers);

      http.StreamedResponse response =
          await request.send().timeout(timeOutDuration);

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        throw HttpException(responseBody);
      }

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
        'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
      };
      var uri = Uri.parse(
        '${getHostName()}$postEndpoint$postID/update/',
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
          await request.send().timeout(timeOutDuration);

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        throw HttpException(responseBody);
      }
      return true;
    } catch (error) {
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
            connectTimeout: 10 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;
  NormalPostModel? get getNormalPostData => _normalPost;

  NormalPostModel _randNormalPost() {
    Random rand = Random();
    bool upVoted = faker.randomGenerator.boolean();
    return NormalPostModel(
      attachedImage: faker.randomGenerator.boolean()
          ? faker.image.image(random: true)
          : null,
      upVote: faker.randomGenerator
          .numbers(1500, faker.randomGenerator.integer(1500)),
      downVote: faker.randomGenerator
          .numbers(1500, faker.randomGenerator.integer(1500)),
      upVoted: upVoted,
      downVoted: upVoted ? false : faker.randomGenerator.boolean(),
      postContent: faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      createdOn:
          faker.date.dateTime(minYear: 2020, maxYear: DateTime.now().year),
      id: faker.randomGenerator.integer(1000),
      isAnonymous: faker.randomGenerator.boolean(),
      isPersonalPost: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
                fieldOfWork: List.generate(
                  Random().nextInt(8 - 1) + 1,
                  (index) => faker.lorem.word(),
                ),
              )),
      postType: 'Normal',
      relatedTo: List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      author: faker.person.firstName(),
    );
  }

  Future<void> initFetchNormalPost({required int postID}) async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
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
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        }),
      );
      return NormalPostModel.fromAPIResponse(response.data);
    } on DioError {
      return null;
    }
  }

  Future<void> refreshNormalPost({required int postID}) async {
    await initFetchNormalPost(postID: postID);
  }

  Future<bool> toggleReaction(
    NormalPostReactionType type,
  ) async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
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
            'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
          }),
        );
      }

      return true;
    } on DioError {
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
            connectTimeout: 10 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;

  PollPostModel? get getPollPostData => _pollPost;

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
      isPersonalPost: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
                fieldOfWork: List.generate(
                  Random().nextInt(8 - 1) + 1,
                  (index) => faker.lorem.word(),
                ),
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

  Future<void> initFetchPollPost({required int postID}) async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
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
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        }),
      );
      return PollPostModel.fromAPIResponse(response.data);
    } on DioError {
      return null;
    }
  }

  Future<void> refreshPollPost({required int postID}) async {
    await initFetchPollPost(postID: postID);
  }

  Future<bool> pollTheOption({required int optionID}) async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        await _dio.post(
          '$postEndpoint${_pollPost!.id}/poll/$optionID/',
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
            connectTimeout: 10 * 1000,
          ),
        );

  set setAuthP(AuthProvider auth) => _authP = auth;

  RequestPostModel? get getRequestPostData => _requestPost;

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
      isPersonalPost: faker.randomGenerator.boolean(),
      pokedNGO: List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => NGO__Model(
                id: faker.randomGenerator.integer(1000),
                orgName: faker.company.name(),
                orgPhoto: faker.image.image(random: true),
                fieldOfWork: List.generate(
                  Random().nextInt(8 - 1) + 1,
                  (index) => faker.lorem.word(),
                ),
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

  Future<void> intiFetchRequestPost({required int postID}) async {
    if (StartupConfigProvider.getIsDemo) {
      await delay();
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
          'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
        }),
      );
      return RequestPostModel.fromAPIResponse(response.data);
    } on DioError {
      return null;
    }
  }

  Future<void> refreshRequestPost({required int postID}) async {
    await intiFetchRequestPost(postID: postID);
  }

  //Sign for petition and join for participate-form
  Future<bool> considerRequest() async {
    try {
      if (StartupConfigProvider.getIsDemo) {
        await delay();
      } else {
        await _dio.post(
          '$postEndpoint${_requestPost!.id}/participate/',
          options: Options(headers: {
            'Authorization': 'Token ${_authP.getAuth!.tokenKey}',
          }),
        );
      }
      _requestPost!.reaction.add(_authP.getAuth!.profileID);
      _requestPost!.isParticipated = true;

      notifyListeners();
      return true;
    } on DioError {
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

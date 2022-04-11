import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

class NormalPostCUModel {
  int? _postID;
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  String? _postImageLink;
  XFile? _postImage;

  NormalPostCUModel();
  int? get getPostID => _postID;
  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  String? get getPostImageLink => _postImageLink;
  XFile? get getPostImage => _postImage;

  set setPostID(int? postID) => _postID = postID;
  set setRelatedTo(List<String>? relatedTo) => _relatedTo = relatedTo;
  set setPostContent(String? postContent) => _postContent = postContent;
  set setIsAnonymous(bool? isAnonymous) => _isAnonymous = isAnonymous;
  set setPokedNGO(List<int>? pokedNGO) => _pokedNGO = pokedNGO;

  set setPostImageLiink(String? postImageLink) =>
      _postImageLink = postImageLink;
  set setPostImage(XFile? postImage) => _postImage = postImage;

  factory NormalPostCUModel.fromAPIResponse(Map<String, dynamic> map) {
    return NormalPostCUModel()
      .._postID = map['id']?.toInt() ?? 0
      .._relatedTo = List<String>.from(map['related_to'])
      .._postContent = map['post_content']
      .._isAnonymous = map['is_anonymous']
      .._pokedNGO = List<int>.from(map['poked_ngo'])
      .._postImageLink = map['post_image'];
  }

  void nullifyNormal() {
    _postImage = null;
  }

  void nullifyAll() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    nullifyNormal();
  }

  @override
  String toString() {
    return 'NormalPostCU(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO, _postImage: $_postImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NormalPostCUModel &&
        listEquals(other._relatedTo, _relatedTo) &&
        other._postContent == _postContent &&
        other._isAnonymous == _isAnonymous &&
        listEquals(other._pokedNGO, _pokedNGO) &&
        other._postImage == _postImage;
  }

  @override
  int get hashCode {
    return _relatedTo.hashCode ^
        _postContent.hashCode ^
        _isAnonymous.hashCode ^
        _pokedNGO.hashCode ^
        _postImage.hashCode;
  }
}

class PollPostCUModel {
  int? _postID;
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  List<String>? _pollOptions;
  DateTime? _pollDuration;

  PollPostCUModel();

  int? get getPostID => _postID;
  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  List<String>? get getPollOptions => _pollOptions;
  DateTime? get getPollDuration => _pollDuration;

  set setPostID(int? postID) => _postID = postID;
  set setRelatedTo(List<String>? relatedTo) => _relatedTo = relatedTo;
  set setPostContent(String? postContent) => _postContent = postContent;
  set setIsAnonymous(bool? isAnonymous) => _isAnonymous = isAnonymous;
  set setPokedNGO(List<int>? pokedNGO) => _pokedNGO = pokedNGO;

  set setPollOptions(List<String>? pollOptions) => _pollOptions = pollOptions;
  set setPollDuration(DateTime? pollDuration) => _pollDuration = pollDuration;

  factory PollPostCUModel.fromAPIResponse(Map<String, dynamic> map) {
    return PollPostCUModel()
      .._postID = map['id']?.toInt() ?? 0
      .._relatedTo = List<String>.from(map['related_to'])
      .._postContent = map['post_content']
      .._isAnonymous = map['is_anonymous']
      .._pokedNGO = List<int>.from(map['poked_ngo'])
      .._pollOptions = List<String>.from(map['option'])
      .._pollDuration = map['ends_on'] != null
          ? Jiffy(map['ends_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime
          : null;
  }

  void nullifyPoll() {
    _pollOptions = null;
    _pollDuration = null;
  }

  void nullifyAll() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    nullifyPoll();
  }

  @override
  String toString() {
    return 'PollPostCU(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO, _pollOptions: $_pollOptions, _pollDuration: $_pollDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollPostCUModel &&
        listEquals(other._relatedTo, _relatedTo) &&
        other._postContent == _postContent &&
        other._isAnonymous == _isAnonymous &&
        listEquals(other._pokedNGO, _pokedNGO) &&
        listEquals(other._pollOptions, _pollOptions) &&
        other._pollDuration == _pollDuration;
  }

  @override
  int get hashCode {
    return _relatedTo.hashCode ^
        _postContent.hashCode ^
        _isAnonymous.hashCode ^
        _pokedNGO.hashCode ^
        _pollOptions.hashCode ^
        _pollDuration.hashCode;
  }
}

class RequestPostCUModel {
  int? _postID;
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  int? _min;
  int? _target;
  int? _max;
  String? _requestType;
  DateTime? _requestDuration;

  RequestPostCUModel();

  int? get getPostID => _postID;
  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  int? get getMin => _min;
  int? get getTarget => _target;
  int? get getMax => _max;
  String? get getRequestType => _requestType;
  DateTime? get getRequestDuration => _requestDuration;

  set setPostID(int? postID) => _postID = postID;
  set setRelatedTo(List<String>? relatedTo) => _relatedTo = relatedTo;
  set setPostContent(String? postContent) => _postContent = postContent;
  set setIsAnonymous(bool? isAnonymous) => _isAnonymous = isAnonymous;
  set setPokedNGO(List<int>? pokedNGO) => _pokedNGO = pokedNGO;

  set setMin(int? min) => _min = min;
  set setTarget(int? target) => _target = target;
  set setMax(int? max) => _max = max;
  set setRequestType(String? requestType) => _requestType = requestType;
  set setRequestDuration(DateTime? requestDuration) =>
      _requestDuration = requestDuration;

  factory RequestPostCUModel.fromAPIResponse(Map<String, dynamic> map) {
    return RequestPostCUModel()
      .._postID = map['id']?.toInt() ?? 0
      .._relatedTo = List<String>.from(map['related_to'])
      .._postContent = map['post_content']
      .._isAnonymous = map['is_anonymous']
      .._pokedNGO = List<int>.from(map['poked_ngo'])
      .._min = map['min']?.toInt() ?? 0
      .._target = map['target']?.toInt() ?? 0
      .._max = map['max']?.toInt()
      .._requestDuration =
          Jiffy(map['ends_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime
      .._requestType = map['request_type'] ?? '';
  }

  void nullifyRequest() {
    _min = null;
    _target = null;
    _max = null;
    _requestType = null;
    _requestDuration = null;
  }

  void nullifyAll() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    nullifyRequest();
  }

  @override
  String toString() {
    return 'RequestPostCU(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestPostCUModel &&
        listEquals(other._relatedTo, _relatedTo) &&
        other._postContent == _postContent &&
        other._isAnonymous == _isAnonymous &&
        listEquals(other._pokedNGO, _pokedNGO);
  }

  @override
  int get hashCode {
    return _relatedTo.hashCode ^
        _postContent.hashCode ^
        _isAnonymous.hashCode ^
        _pokedNGO.hashCode;
  }
}

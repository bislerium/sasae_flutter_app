import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class NormalPostCreate {
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  XFile? _postImage;

  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  XFile? get getPostImage => _postImage;

  set setRelatedTo(List<String>? relatedTo) => _relatedTo = relatedTo;
  set setPostContent(String? postContent) => _postContent = postContent;
  set setIsAnonymous(bool? isAnonymous) => _isAnonymous = isAnonymous;
  set setPokedNGO(List<int>? pokedNGO) => _pokedNGO = pokedNGO;

  set setPostImage(XFile? postImage) => _postImage = postImage;

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
    return 'NormalPostCreate(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO, _postImage: $_postImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NormalPostCreate &&
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

class PollPostCreate {
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  List<String>? _pollOptions;
  DateTime? _pollDuration;

  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  List<String>? get getPollOptions => _pollOptions;
  DateTime? get getPollDuration => _pollDuration;

  set setRelatedTo(List<String>? relatedTo) => _relatedTo = relatedTo;
  set setPostContent(String? postContent) => _postContent = postContent;
  set setIsAnonymous(bool? isAnonymous) => _isAnonymous = isAnonymous;
  set setPokedNGO(List<int>? pokedNGO) => _pokedNGO = pokedNGO;

  set setPollOptions(List<String>? pollOptions) => _pollOptions = pollOptions;
  set setPollDuration(DateTime? pollDuration) => _pollDuration = pollDuration;

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
    return 'PollPostCreate(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO, _pollOptions: $_pollOptions, _pollDuration: $_pollDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollPostCreate &&
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

class RequestPostCreate {
  List<String>? _relatedTo;
  String? _postContent;
  bool? _isAnonymous;
  List<int>? _pokedNGO;

  int? _min;
  int? _target;
  int? _max;
  String? _requestType;
  DateTime? _requestDuration;

  List<String>? get getRelatedTo => _relatedTo;
  String? get getPostContent => _postContent;
  bool? get getIsAnonymous => _isAnonymous;
  List<int>? get getPokedNGO => _pokedNGO;

  int? get getMin => _min;
  int? get getTarget => _target;
  int? get getMax => _max;
  String? get getRequestType => _requestType;
  DateTime? get getRequestDuration => _requestDuration;

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
    return 'RequestPostCreate(_relatedTo: $_relatedTo, _postContent: $_postContent, _isAnonymous: $_isAnonymous, _pokedNGO: $_pokedNGO)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestPostCreate &&
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

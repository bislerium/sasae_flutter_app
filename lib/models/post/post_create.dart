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

  void nullifyFields() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    _postImage = null;
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

  void nullifyFields() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    _pollOptions = null;
    _pollDuration = null;
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

  void nullifyFields() {
    _relatedTo = null;
    _postContent = null;
    _isAnonymous = null;
    _pokedNGO = null;
    _min = null;
    _target = null;
    _max = null;
    _requestType = null;
    _requestDuration = null;
  }
}

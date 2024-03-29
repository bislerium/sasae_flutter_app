import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/post/abstract_post.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';

class RequestPostModel implements AbstractPostModel {
  final int min;
  final int target;
  final int? max;
  List<int> reaction;
  final DateTime endsOn;
  final String requestType;
  bool isParticipated;

  @override
  String? author;

  @override
  int? authorID;

  @override
  DateTime createdOn;

  @override
  int id;

  @override
  bool isAnonymous;

  @override
  bool isPersonalPost;

  @override
  DateTime? modifiedOn;

  @override
  List<NGO__Model> pokedNGO;

  @override
  String postContent;

  @override
  String postType;

  @override
  List<String> relatedTo;

  RequestPostModel({
    required this.min,
    required this.target,
    this.max,
    required this.reaction,
    required this.endsOn,
    required this.requestType,
    required this.isParticipated,
    this.author,
    this.authorID,
    required this.createdOn,
    required this.id,
    required this.isAnonymous,
    required this.isPersonalPost,
    this.modifiedOn,
    required this.pokedNGO,
    required this.postContent,
    required this.postType,
    required this.relatedTo,
  });

  RequestPostModel copyWith({
    int? min,
    int? target,
    int? max,
    List<int>? reaction,
    DateTime? endsOn,
    String? requestType,
    bool? isParticipated,
    String? author,
    int? authorID,
    DateTime? createdOn,
    int? id,
    bool? isAnonymous,
    bool? isPersonalPost,
    DateTime? modifiedOn,
    List<NGO__Model>? pokedNGO,
    String? postContent,
    String? postType,
    List<String>? relatedTo,
  }) {
    return RequestPostModel(
      min: min ?? this.min,
      target: target ?? this.target,
      max: max ?? this.max,
      reaction: reaction ?? this.reaction,
      endsOn: endsOn ?? this.endsOn,
      requestType: requestType ?? this.requestType,
      isParticipated: isParticipated ?? this.isParticipated,
      author: author ?? this.author,
      authorID: authorID ?? this.authorID,
      createdOn: createdOn ?? this.createdOn,
      id: id ?? this.id,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isPersonalPost: isPersonalPost ?? this.isPersonalPost,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      pokedNGO: pokedNGO ?? this.pokedNGO,
      postContent: postContent ?? this.postContent,
      postType: postType ?? this.postType,
      relatedTo: relatedTo ?? this.relatedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min': min,
      'target': target,
      'max': max,
      'reaction': reaction,
      'endsOn': endsOn.millisecondsSinceEpoch,
      'requestType': requestType,
      'isParticipated': isParticipated,
      'author': author,
      'authorID': authorID,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'id': id,
      'isAnonymous': isAnonymous,
      'isPersonalPost': isPersonalPost,
      'modifiedOn': modifiedOn?.millisecondsSinceEpoch,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postContent': postContent,
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory RequestPostModel.fromAPIResponse(Map<String, dynamic> map) {
    return RequestPostModel(
      min: map['post_request']['min']?.toInt() ?? 0,
      target: map['post_request']['target']?.toInt() ?? 0,
      max: map['post_request']['max']?.toInt(),
      reaction: List<int>.from(map['post_request']['reacted_by']),
      endsOn: Jiffy(map['post_request']['ends_on'], "yyyy-MM-dd'T'HH:mm:ss")
          .dateTime,
      requestType: map['post_request']['request_type'] ?? '',
      isParticipated: map['post_request']['is_participated'] ?? false,
      author: map['author'],
      authorID: map['author_id']?.toInt(),
      createdOn: Jiffy(map['created_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['is_anonymous'] ?? false,
      isPersonalPost: map['post_request']['is_personal_post'] as bool,
      modifiedOn: map['modified_on'] != null
          ? Jiffy(map['modified_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime
          : null,
      pokedNGO: List<NGO__Model>.from(
          map['poked_ngo']?.map((x) => NGO__Model.fromAPIResponse(x))),
      postContent: map['post_content'] ?? '',
      postType: map['post_type'] ?? '',
      relatedTo: List<String>.from(map['related_to']),
    );
  }

  factory RequestPostModel.fromMap(Map<String, dynamic> map) {
    return RequestPostModel(
      min: map['min'] as int,
      target: map['target'] as int,
      max: map['max'] != null ? map['max'] as int : null,
      reaction: List<int>.from(map['reaction'] as List<int>),
      endsOn: DateTime.fromMillisecondsSinceEpoch(map['endsOn'] as int),
      requestType: map['requestType'] as String,
      isParticipated: map['isParticipated'] as bool,
      author: map['author'] != null ? map['author'] as String : null,
      authorID: map['authorID'] != null ? map['authorID'] as int : null,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn'] as int),
      id: map['id'] as int,
      isAnonymous: map['isAnonymous'] as bool,
      isPersonalPost: map['isPersonalPost'] as bool,
      modifiedOn: map['modifiedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['modifiedOn'] as int)
          : null,
      pokedNGO: List<NGO__Model>.from(
        (map['pokedNGO'] as List<int>).map<NGO__Model>(
          (x) => NGO__Model.fromMap(x as Map<String, dynamic>),
        ),
      ),
      postContent: map['postContent'] as String,
      postType: map['postType'] as String,
      relatedTo: List<String>.from(map['relatedTo'] as List<String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestPostModel.fromJson(String source) =>
      RequestPostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RequestPostModel(min: $min, target: $target, max: $max, reaction: $reaction, endsOn: $endsOn, requestType: $requestType, isParticipated: $isParticipated, author: $author, authorID: $authorID, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, isPersonalPost: $isPersonalPost, modifiedOn: $modifiedOn, pokedNGO: $pokedNGO, postContent: $postContent, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(covariant RequestPostModel other) {
    if (identical(this, other)) return true;

    return other.min == min &&
        other.target == target &&
        other.max == max &&
        listEquals(other.reaction, reaction) &&
        other.endsOn == endsOn &&
        other.requestType == requestType &&
        other.isParticipated == isParticipated &&
        other.author == author &&
        other.authorID == authorID &&
        other.createdOn == createdOn &&
        other.id == id &&
        other.isAnonymous == isAnonymous &&
        other.isPersonalPost == isPersonalPost &&
        other.modifiedOn == modifiedOn &&
        listEquals(other.pokedNGO, pokedNGO) &&
        other.postContent == postContent &&
        other.postType == postType &&
        listEquals(other.relatedTo, relatedTo);
  }

  @override
  int get hashCode {
    return min.hashCode ^
        target.hashCode ^
        max.hashCode ^
        reaction.hashCode ^
        endsOn.hashCode ^
        requestType.hashCode ^
        isParticipated.hashCode ^
        author.hashCode ^
        authorID.hashCode ^
        createdOn.hashCode ^
        id.hashCode ^
        isAnonymous.hashCode ^
        isPersonalPost.hashCode ^
        modifiedOn.hashCode ^
        pokedNGO.hashCode ^
        postContent.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

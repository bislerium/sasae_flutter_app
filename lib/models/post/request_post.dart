import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/post/abstract_post.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';

class RequestPost implements AbstractPost {
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
  DateTime? modifiedOn;

  @override
  List<NGO__> pokedNGO;

  @override
  String postContent;

  @override
  String postType;

  @override
  List<String> relatedTo;

  RequestPost({
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
    this.modifiedOn,
    required this.pokedNGO,
    required this.postContent,
    required this.postType,
    required this.relatedTo,
  });

  RequestPost copyWith({
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
    DateTime? modifiedOn,
    List<NGO__>? pokedNGO,
    String? postContent,
    String? postType,
    List<String>? relatedTo,
  }) {
    return RequestPost(
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
      modifiedOn: modifiedOn ?? this.modifiedOn,
      pokedNGO: pokedNGO ?? this.pokedNGO,
      postContent: postContent ?? this.postContent,
      postType: postType ?? this.postType,
      relatedTo: relatedTo ?? this.relatedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'modifiedOn': modifiedOn?.millisecondsSinceEpoch,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postContent': postContent,
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory RequestPost.fromAPIResponse(Map<String, dynamic> map) {
    return RequestPost(
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
      modifiedOn: map['modified_on'] != null
          ? Jiffy(map['modified_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime
          : null,
      pokedNGO: List<NGO__>.from(
          map['poked_ngo']?.map((x) => NGO__.fromAPIResponse(x))),
      postContent: map['post_content'] ?? '',
      postType: map['post_type'] ?? '',
      relatedTo: List<String>.from(map['related_to']),
    );
  }

  factory RequestPost.fromMap(Map<String, dynamic> map) {
    return RequestPost(
      min: map['min']?.toInt() ?? 0,
      target: map['target']?.toInt() ?? 0,
      max: map['max']?.toInt(),
      reaction: List<int>.from(map['reaction']),
      endsOn: DateTime.fromMillisecondsSinceEpoch(map['endsOn']),
      requestType: map['requestType'] ?? '',
      isParticipated: map['isParticipated'] ?? false,
      author: map['author'],
      authorID: map['authorID']?.toInt(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['isAnonymous'] ?? false,
      modifiedOn: map['modifiedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['modifiedOn'])
          : null,
      pokedNGO: List<NGO__>.from(map['pokedNGO']?.map((x) => NGO__.fromMap(x))),
      postContent: map['postContent'] ?? '',
      postType: map['postType'] ?? '',
      relatedTo: List<String>.from(map['relatedTo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestPost.fromJson(String source) =>
      RequestPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RequestPost(min: $min, target: $target, max: $max, reaction: $reaction, endsOn: $endsOn, requestType: $requestType, isParticipated: $isParticipated, author: $author, authorID: $authorID, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, modifiedOn: $modifiedOn, pokedNGO: $pokedNGO, postContent: $postContent, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestPost &&
        other.min == min &&
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
        modifiedOn.hashCode ^
        pokedNGO.hashCode ^
        postContent.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sasae_flutter_app/models/post/abstract_post.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';

class RequestPost implements AbstractPost {
  final int min;
  final int target;
  final int? max;
  int numParticipation;
  final DateTime endsOn;
  final String requestType;
  bool isParticipated;

  @override
  String author;

  @override
  String content;

  @override
  DateTime createdOn;

  @override
  int id;

  @override
  bool isAnonymous;

  @override
  List<NGO__> pokedNGO;

  @override
  String postType;

  @override
  List<String> relatedTo;
  RequestPost({
    required this.min,
    required this.target,
    this.max,
    required this.numParticipation,
    required this.endsOn,
    required this.requestType,
    required this.isParticipated,
    required this.author,
    required this.content,
    required this.createdOn,
    required this.id,
    required this.isAnonymous,
    required this.pokedNGO,
    required this.postType,
    required this.relatedTo,
  });

  RequestPost copyWith({
    int? min,
    int? target,
    int? max,
    int? numParticipation,
    DateTime? endsOn,
    String? requestType,
    bool? isParticipated,
    String? author,
    String? content,
    DateTime? createdOn,
    int? id,
    bool? isAnonymous,
    List<NGO__>? pokedNGO,
    String? postType,
    List<String>? relatedTo,
  }) {
    return RequestPost(
      min: min ?? this.min,
      target: target ?? this.target,
      max: max ?? this.max,
      numParticipation: numParticipation ?? this.numParticipation,
      endsOn: endsOn ?? this.endsOn,
      requestType: requestType ?? this.requestType,
      isParticipated: isParticipated ?? this.isParticipated,
      author: author ?? this.author,
      content: content ?? this.content,
      createdOn: createdOn ?? this.createdOn,
      id: id ?? this.id,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      pokedNGO: pokedNGO ?? this.pokedNGO,
      postType: postType ?? this.postType,
      relatedTo: relatedTo ?? this.relatedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'target': target,
      'max': max,
      'numParticipation': numParticipation,
      'endsOn': endsOn.millisecondsSinceEpoch,
      'requestType': requestType,
      'isParticipated': isParticipated,
      'author': author,
      'content': content,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'id': id,
      'isAnonymous': isAnonymous,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory RequestPost.fromMap(Map<String, dynamic> map) {
    return RequestPost(
      min: map['min']?.toInt() ?? 0,
      target: map['target']?.toInt() ?? 0,
      max: map['max']?.toInt(),
      numParticipation: map['numParticipation']?.toInt() ?? 0,
      endsOn: DateTime.fromMillisecondsSinceEpoch(map['endsOn']),
      requestType: map['requestType'] ?? '',
      isParticipated: map['isParticipated'] ?? false,
      author: map['author'] ?? '',
      content: map['content'] ?? '',
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['isAnonymous'] ?? false,
      pokedNGO: List<NGO__>.from(map['pokedNGO']?.map((x) => NGO__.fromMap(x))),
      postType: map['postType'] ?? '',
      relatedTo: List<String>.from(map['relatedTo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestPost.fromJson(String source) =>
      RequestPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RequestPost(min: $min, target: $target, max: $max, numParticipation: $numParticipation, endsOn: $endsOn, requestType: $requestType, isParticipated: $isParticipated, author: $author, content: $content, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, pokedNGO: $pokedNGO, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestPost &&
        other.min == min &&
        other.target == target &&
        other.max == max &&
        other.numParticipation == numParticipation &&
        other.endsOn == endsOn &&
        other.requestType == requestType &&
        other.isParticipated == isParticipated &&
        other.author == author &&
        other.content == content &&
        other.createdOn == createdOn &&
        other.id == id &&
        other.isAnonymous == isAnonymous &&
        listEquals(other.pokedNGO, pokedNGO) &&
        other.postType == postType &&
        listEquals(other.relatedTo, relatedTo);
  }

  @override
  int get hashCode {
    return min.hashCode ^
        target.hashCode ^
        max.hashCode ^
        numParticipation.hashCode ^
        endsOn.hashCode ^
        requestType.hashCode ^
        isParticipated.hashCode ^
        author.hashCode ^
        content.hashCode ^
        createdOn.hashCode ^
        id.hashCode ^
        isAnonymous.hashCode ^
        pokedNGO.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

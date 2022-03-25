import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

// ignore: camel_case_types
class Post_ {
  final int id;
  final List<String> relatedTo;
  final String postContent;
  final DateTime postedOn;
  final String postType;
  final bool isPostedAnonymously;
  final bool isPokedToNGO;

  Post_({
    required this.id,
    required this.relatedTo,
    required this.postContent,
    required this.postedOn,
    required this.postType,
    required this.isPostedAnonymously,
    required this.isPokedToNGO,
  });

  Post_ copyWith({
    int? id,
    List<String>? relatedTo,
    String? postContent,
    DateTime? postedOn,
    String? postType,
    bool? isPostedAnonymously,
    bool? isPokedToNGO,
  }) {
    return Post_(
      id: id ?? this.id,
      relatedTo: relatedTo ?? this.relatedTo,
      postContent: postContent ?? this.postContent,
      postedOn: postedOn ?? this.postedOn,
      postType: postType ?? this.postType,
      isPostedAnonymously: isPostedAnonymously ?? this.isPostedAnonymously,
      isPokedToNGO: isPokedToNGO ?? this.isPokedToNGO,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'relatedTo': relatedTo,
      'postContent': postContent,
      'postedOn': postedOn.millisecondsSinceEpoch,
      'postType': postType,
      'isPostedAnonymously': isPostedAnonymously,
      'isPokedToNGO': isPokedToNGO,
    };
  }

  factory Post_.fromAPIResponse(Map<String, dynamic> map) {
    return Post_(
      id: map['id']?.toInt() ?? 0,
      relatedTo: List<String>.from(map['related_to']),
      postContent: map['post_content'] ?? '',
      postedOn: Jiffy(map['created_on'], 'yyyy-MM-dd').dateTime,
      postType: map['post_type'] ?? '',
      isPostedAnonymously: map['is_anonymous'] ?? false,
      isPokedToNGO: map['is_ngo_poked'] ?? false,
    );
  }

  factory Post_.fromMap(Map<String, dynamic> map) {
    return Post_(
      id: map['id']?.toInt() ?? 0,
      relatedTo: List<String>.from(map['relatedTo']),
      postContent: map['postContent'] ?? '',
      postedOn: DateTime.fromMillisecondsSinceEpoch(map['postedOn']),
      postType: map['postType'] ?? '',
      isPostedAnonymously: map['isPostedAnonymously'] ?? false,
      isPokedToNGO: map['isPokedToNGO'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post_.fromJson(String source) => Post_.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post_(id: $id, relatedTo: $relatedTo, postContent: $postContent, postedOn: $postedOn, postType: $postType, isPostedAnonymously: $isPostedAnonymously, isPokedToNGO: $isPokedToNGO)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post_ &&
        other.id == id &&
        listEquals(other.relatedTo, relatedTo) &&
        other.postContent == postContent &&
        other.postedOn == postedOn &&
        other.postType == postType &&
        other.isPostedAnonymously == isPostedAnonymously &&
        other.isPokedToNGO == isPokedToNGO;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        relatedTo.hashCode ^
        postContent.hashCode ^
        postedOn.hashCode ^
        postType.hashCode ^
        isPostedAnonymously.hashCode ^
        isPokedToNGO.hashCode;
  }
}

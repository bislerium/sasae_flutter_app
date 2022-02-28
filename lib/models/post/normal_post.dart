import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';

import 'abstract_post.dart';

class NormalPost implements AbstractPost {
  final String? attachedImage;
  final int upVote;
  final int downVote;
  final bool upVoted;
  final bool downVoted;

  @override
  String author;

  @override
  String description;

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
  NormalPost({
    this.attachedImage,
    required this.upVote,
    required this.downVote,
    required this.upVoted,
    required this.downVoted,
    required this.author,
    required this.description,
    required this.createdOn,
    required this.id,
    required this.isAnonymous,
    required this.pokedNGO,
    required this.postType,
    required this.relatedTo,
  });

  NormalPost copyWith({
    String? attachedImage,
    int? upVote,
    int? downVote,
    bool? upVoted,
    bool? downVoted,
    String? author,
    String? content,
    DateTime? createdOn,
    int? id,
    bool? isAnonymous,
    List<NGO__>? pokedNGO,
    String? postType,
    List<String>? relatedTo,
  }) {
    return NormalPost(
      attachedImage: attachedImage ?? this.attachedImage,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      upVoted: upVoted ?? this.upVoted,
      downVoted: downVoted ?? this.downVoted,
      author: author ?? this.author,
      description: content ?? this.description,
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
      'attachedImage': attachedImage,
      'upVote': upVote,
      'downVote': downVote,
      'upVoted': upVoted,
      'downVoted': downVoted,
      'author': author,
      'content': description,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'id': id,
      'isAnonymous': isAnonymous,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory NormalPost.fromMap(Map<String, dynamic> map) {
    return NormalPost(
      attachedImage: map['attachedImage'],
      upVote: map['upVote']?.toInt() ?? 0,
      downVote: map['downVote']?.toInt() ?? 0,
      upVoted: map['upVoted'] ?? false,
      downVoted: map['downVoted'] ?? false,
      author: map['author'] ?? '',
      description: map['content'] ?? '',
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['isAnonymous'] ?? false,
      pokedNGO: List<NGO__>.from(map['pokedNGO']?.map((x) => NGO__.fromMap(x))),
      postType: map['postType'] ?? '',
      relatedTo: List<String>.from(map['relatedTo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NormalPost.fromJson(String source) =>
      NormalPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NormalPost(attachedImage: $attachedImage, upVote: $upVote, downVote: $downVote, upVoted: $upVoted, downVoted: $downVoted, author: $author, content: $description, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, pokedNGO: $pokedNGO, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NormalPost &&
        other.attachedImage == attachedImage &&
        other.upVote == upVote &&
        other.downVote == downVote &&
        other.upVoted == upVoted &&
        other.downVoted == downVoted &&
        other.author == author &&
        other.description == description &&
        other.createdOn == createdOn &&
        other.id == id &&
        other.isAnonymous == isAnonymous &&
        listEquals(other.pokedNGO, pokedNGO) &&
        other.postType == postType &&
        listEquals(other.relatedTo, relatedTo);
  }

  @override
  int get hashCode {
    return attachedImage.hashCode ^
        upVote.hashCode ^
        downVote.hashCode ^
        upVoted.hashCode ^
        downVoted.hashCode ^
        author.hashCode ^
        description.hashCode ^
        createdOn.hashCode ^
        id.hashCode ^
        isAnonymous.hashCode ^
        pokedNGO.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

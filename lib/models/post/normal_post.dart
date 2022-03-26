import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';

import 'abstract_post.dart';

class NormalPost implements AbstractPost {
  final String? attachedImage;
  final List<int> upVote;
  final List<int> downVote;
  final bool upVoted;
  final bool downVoted;

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
  NormalPost({
    this.attachedImage,
    required this.upVote,
    required this.downVote,
    required this.upVoted,
    required this.downVoted,
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

  NormalPost copyWith({
    String? attachedImage,
    List<int>? upVote,
    List<int>? downVote,
    bool? upVoted,
    bool? downVoted,
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
    return NormalPost(
      attachedImage: attachedImage ?? this.attachedImage,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      upVoted: upVoted ?? this.upVoted,
      downVoted: downVoted ?? this.downVoted,
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
      'attachedImage': attachedImage,
      'upVote': upVote,
      'downVote': downVote,
      'upVoted': upVoted,
      'downVoted': downVoted,
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

  factory NormalPost.fromAPIResponse(Map<String, dynamic> map) {
    return NormalPost(
      attachedImage: map['post_normal']['post_image'],
      upVote: List<int>.from(map['post_normal']['up_vote']),
      downVote: List<int>.from(map['post_normal']['down_vote']),
      upVoted: map['post_normal']['up_voted'] ?? false,
      downVoted: map['post_normal']['down_voted'] ?? false,
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

  factory NormalPost.fromMap(Map<String, dynamic> map) {
    return NormalPost(
      attachedImage: map['attachedImage'],
      upVote: List<int>.from(map['upVote']),
      downVote: List<int>.from(map['downVote']),
      upVoted: map['upVoted'] ?? false,
      downVoted: map['downVoted'] ?? false,
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

  factory NormalPost.fromJson(String source) =>
      NormalPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NormalPost(attachedImage: $attachedImage, upVote: $upVote, downVote: $downVote, upVoted: $upVoted, downVoted: $downVoted, author: $author, authorID: $authorID, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, modifiedOn: $modifiedOn, pokedNGO: $pokedNGO, postContent: $postContent, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NormalPost &&
        other.attachedImage == attachedImage &&
        listEquals(other.upVote, upVote) &&
        listEquals(other.downVote, downVote) &&
        other.upVoted == upVoted &&
        other.downVoted == downVoted &&
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
    return attachedImage.hashCode ^
        upVote.hashCode ^
        downVote.hashCode ^
        upVoted.hashCode ^
        downVoted.hashCode ^
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

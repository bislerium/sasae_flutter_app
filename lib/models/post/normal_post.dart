import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/post/ngo__.dart';

import 'abstract_post.dart';

enum NormalPostReactionType { upVote, downVote }

class NormalPostModel implements AbstractPostModel {
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

  NormalPostModel({
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
    required this.isPersonalPost,
    this.modifiedOn,
    required this.pokedNGO,
    required this.postContent,
    required this.postType,
    required this.relatedTo,
  });

  NormalPostModel copyWith({
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
    bool? isPersonalPost,
    DateTime? modifiedOn,
    List<NGO__Model>? pokedNGO,
    String? postContent,
    String? postType,
    List<String>? relatedTo,
  }) {
    return NormalPostModel(
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
      'isPersonalPost': isPersonalPost,
      'modifiedOn': modifiedOn?.millisecondsSinceEpoch,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postContent': postContent,
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory NormalPostModel.fromAPIResponse(Map<String, dynamic> map) {
    return NormalPostModel(
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
      isPersonalPost: map['post_normal']['is_personal_post'] as bool,
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

  factory NormalPostModel.fromMap(Map<String, dynamic> map) {
    return NormalPostModel(
      attachedImage:
          map['attachedImage'] != null ? map['attachedImage'] as String : null,
      upVote: List<int>.from(map['upVote'] as List<int>),
      downVote: List<int>.from(map['downVote'] as List<int>),
      upVoted: map['upVoted'] as bool,
      downVoted: map['downVoted'] as bool,
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

  factory NormalPostModel.fromJson(String source) =>
      NormalPostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NormalPostModel(attachedImage: $attachedImage, upVote: $upVote, downVote: $downVote, upVoted: $upVoted, downVoted: $downVoted, author: $author, authorID: $authorID, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, isPersonalPost: $isPersonalPost, modifiedOn: $modifiedOn, pokedNGO: $pokedNGO, postContent: $postContent, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(covariant NormalPostModel other) {
    if (identical(this, other)) return true;

    return other.attachedImage == attachedImage &&
        listEquals(other.upVote, upVote) &&
        listEquals(other.downVote, downVote) &&
        other.upVoted == upVoted &&
        other.downVoted == downVoted &&
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
        isPersonalPost.hashCode ^
        modifiedOn.hashCode ^
        pokedNGO.hashCode ^
        postContent.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

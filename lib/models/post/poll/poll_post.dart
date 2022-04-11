import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/post/abstract_post.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';

class PollPostModel implements AbstractPostModel {
  final List<PollOptionModel> polls;
  final DateTime? endsOn;
  final int? choice;

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
  List<NGO__Model> pokedNGO;

  @override
  String postContent;

  @override
  String postType;

  @override
  List<String> relatedTo;

  PollPostModel({
    required this.polls,
    this.endsOn,
    this.choice,
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

  PollPostModel copyWith({
    List<PollOptionModel>? polls,
    DateTime? endsOn,
    int? choice,
    String? author,
    int? authorID,
    DateTime? createdOn,
    int? id,
    bool? isAnonymous,
    DateTime? modifiedOn,
    List<NGO__Model>? pokedNGO,
    String? postContent,
    String? postType,
    List<String>? relatedTo,
  }) {
    return PollPostModel(
      polls: polls ?? this.polls,
      endsOn: endsOn ?? this.endsOn,
      choice: choice ?? this.choice,
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
      'polls': polls.map((x) => x.toMap()).toList(),
      'endsOn': endsOn?.millisecondsSinceEpoch,
      'choice': choice,
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

  factory PollPostModel.fromAPIResponse(Map<String, dynamic> map) {
    return PollPostModel(
      polls: List<PollOptionModel>.from(map['post_poll']['options']
          ?.map((x) => PollOptionModel.fromAPIResponse(x))),
      endsOn: map['post_poll']['ends_on'] != null
          ? Jiffy(map['post_poll']['ends_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime
          : null,
      choice: map['post_poll']['choice'],
      author: map['author'],
      authorID: map['author_id']?.toInt(),
      createdOn: Jiffy(map['created_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['is_anonymous'] ?? false,
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

  factory PollPostModel.fromMap(Map<String, dynamic> map) {
    return PollPostModel(
      polls: List<PollOptionModel>.from(
          map['polls']?.map((x) => PollOptionModel.fromMap(x))),
      endsOn: map['endsOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endsOn'])
          : null,
      choice: map['choice']?.toInt(),
      author: map['author'],
      authorID: map['authorID']?.toInt(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['isAnonymous'] ?? false,
      modifiedOn: map['modifiedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['modifiedOn'])
          : null,
      pokedNGO: List<NGO__Model>.from(
          map['pokedNGO']?.map((x) => NGO__Model.fromMap(x))),
      postContent: map['postContent'] ?? '',
      postType: map['postType'] ?? '',
      relatedTo: List<String>.from(map['relatedTo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollPostModel.fromJson(String source) =>
      PollPostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PollPost(polls: $polls, endsOn: $endsOn, choice: $choice, author: $author, authorID: $authorID, createdOn: $createdOn, id: $id, isAnonymous: $isAnonymous, modifiedOn: $modifiedOn, pokedNGO: $pokedNGO, postContent: $postContent, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollPostModel &&
        listEquals(other.polls, polls) &&
        other.endsOn == endsOn &&
        other.choice == choice &&
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
    return polls.hashCode ^
        endsOn.hashCode ^
        choice.hashCode ^
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

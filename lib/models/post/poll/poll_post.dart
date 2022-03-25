import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sasae_flutter_app/models/post/abstract_post.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';

class PollPost implements AbstractPost {
  final List<PollOption> polls;
  final DateTime? endsOn;
  final String? choice;

  @override
  String? author;

  @override
  DateTime createdOn;

  @override
  String description;

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
  PollPost({
    required this.polls,
    this.endsOn,
    this.choice,
    this.author,
    required this.createdOn,
    required this.description,
    required this.id,
    required this.isAnonymous,
    required this.pokedNGO,
    required this.postType,
    required this.relatedTo,
  });

  PollPost copyWith({
    List<PollOption>? polls,
    DateTime? endsOn,
    String? choice,
    String? author,
    DateTime? createdOn,
    String? description,
    int? id,
    bool? isAnonymous,
    List<NGO__>? pokedNGO,
    String? postType,
    List<String>? relatedTo,
  }) {
    return PollPost(
      polls: polls ?? this.polls,
      endsOn: endsOn ?? this.endsOn,
      choice: choice ?? this.choice,
      author: author ?? this.author,
      createdOn: createdOn ?? this.createdOn,
      description: description ?? this.description,
      id: id ?? this.id,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      pokedNGO: pokedNGO ?? this.pokedNGO,
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
      'createdOn': createdOn.millisecondsSinceEpoch,
      'description': description,
      'id': id,
      'isAnonymous': isAnonymous,
      'pokedNGO': pokedNGO.map((x) => x.toMap()).toList(),
      'postType': postType,
      'relatedTo': relatedTo,
    };
  }

  factory PollPost.fromMap(Map<String, dynamic> map) {
    return PollPost(
      polls: List<PollOption>.from(
          map['polls']?.map((x) => PollOption.fromMap(x))),
      endsOn: map['endsOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endsOn'])
          : null,
      choice: map['choice'],
      author: map['author'],
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      description: map['description'] ?? '',
      id: map['id']?.toInt() ?? 0,
      isAnonymous: map['isAnonymous'] ?? false,
      pokedNGO: List<NGO__>.from(map['pokedNGO']?.map((x) => NGO__.fromMap(x))),
      postType: map['postType'] ?? '',
      relatedTo: List<String>.from(map['relatedTo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollPost.fromJson(String source) =>
      PollPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PollPost(polls: $polls, endsOn: $endsOn, choice: $choice, author: $author, createdOn: $createdOn, description: $description, id: $id, isAnonymous: $isAnonymous, pokedNGO: $pokedNGO, postType: $postType, relatedTo: $relatedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollPost &&
        listEquals(other.polls, polls) &&
        other.endsOn == endsOn &&
        other.choice == choice &&
        other.author == author &&
        other.createdOn == createdOn &&
        other.description == description &&
        other.id == id &&
        other.isAnonymous == isAnonymous &&
        listEquals(other.pokedNGO, pokedNGO) &&
        other.postType == postType &&
        listEquals(other.relatedTo, relatedTo);
  }

  @override
  int get hashCode {
    return polls.hashCode ^
        endsOn.hashCode ^
        choice.hashCode ^
        author.hashCode ^
        createdOn.hashCode ^
        description.hashCode ^
        id.hashCode ^
        isAnonymous.hashCode ^
        pokedNGO.hashCode ^
        postType.hashCode ^
        relatedTo.hashCode;
  }
}

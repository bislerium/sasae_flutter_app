import 'dart:convert';

import 'package:flutter/foundation.dart';

class PollOptionModel {
  final int id;
  final String option;
  List<int> reaction;

  PollOptionModel({
    required this.id,
    required this.option,
    required this.reaction,
  });

  PollOptionModel copyWith({
    int? id,
    String? option,
    List<int>? reaction,
  }) {
    return PollOptionModel(
      id: id ?? this.id,
      option: option ?? this.option,
      reaction: reaction ?? this.reaction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'option': option,
      'reaction': reaction,
    };
  }

  factory PollOptionModel.fromAPIResponse(Map<String, dynamic> map) {
    return PollOptionModel(
      id: map['id']?.toInt() ?? 0,
      option: map['option'] ?? '',
      reaction: List<int>.from(map['reacted_by']),
    );
  }

  factory PollOptionModel.fromMap(Map<String, dynamic> map) {
    return PollOptionModel(
      id: map['id']?.toInt() ?? 0,
      option: map['option'] ?? '',
      reaction: List<int>.from(map['reaction']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollOptionModel.fromJson(String source) =>
      PollOptionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PollOption(id: $id, option: $option, reaction: $reaction)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollOptionModel &&
        other.id == id &&
        other.option == option &&
        listEquals(other.reaction, reaction);
  }

  @override
  int get hashCode => id.hashCode ^ option.hashCode ^ reaction.hashCode;
}

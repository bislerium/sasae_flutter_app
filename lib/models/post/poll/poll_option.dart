import 'dart:convert';

class PollOption {
  final String option;
  final int numReaction;

  PollOption({
    required this.option,
    required this.numReaction,
  });

  PollOption copyWith({
    String? option,
    int? numReaction,
  }) {
    return PollOption(
      option: option ?? this.option,
      numReaction: numReaction ?? this.numReaction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'option': option,
      'numReaction': numReaction,
    };
  }

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      option: map['option'] ?? '',
      numReaction: map['numReaction']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PollOption.fromJson(String source) =>
      PollOption.fromMap(json.decode(source));

  @override
  String toString() => 'PollOption(option: $option, numReaction: $numReaction)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PollOption &&
        other.option == option &&
        other.numReaction == numReaction;
  }

  @override
  int get hashCode => option.hashCode ^ numReaction.hashCode;
}

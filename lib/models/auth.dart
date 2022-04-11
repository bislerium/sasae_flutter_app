import 'dart:convert';

class AuthModel {
  final String tokenKey;
  final String group;
  final int accountID;
  final int profileID;

  AuthModel({
    required this.tokenKey,
    required this.group,
    required this.accountID,
    required this.profileID,
  });

  AuthModel copyWith({
    String? tokenKey,
    String? group,
    int? accountID,
    int? profileID,
  }) {
    return AuthModel(
      tokenKey: tokenKey ?? this.tokenKey,
      group: group ?? this.group,
      accountID: accountID ?? this.accountID,
      profileID: profileID ?? this.profileID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tokenKey': tokenKey,
      'group': group,
      'accountID': accountID,
      'profileID': profileID,
    };
  }

  factory AuthModel.fromAPIResponse(Map<String, dynamic> map) {
    return AuthModel(
      tokenKey: map['key'] ?? '',
      group: map['group'] ?? '',
      accountID: map['account_id']?.toInt() ?? 0,
      profileID: map['profile_id']?.toInt() ?? 0,
    );
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      tokenKey: map['tokenKey'] ?? '',
      group: map['group'] ?? '',
      accountID: map['accountID']?.toInt() ?? 0,
      profileID: map['profileID']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Auth(tokenKey: $tokenKey, group: $group, accountID: $accountID, profileID: $profileID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthModel &&
        other.tokenKey == tokenKey &&
        other.group == group &&
        other.accountID == accountID &&
        other.profileID == profileID;
  }

  @override
  int get hashCode {
    return tokenKey.hashCode ^
        group.hashCode ^
        accountID.hashCode ^
        profileID.hashCode;
  }
}

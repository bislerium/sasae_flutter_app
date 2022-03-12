import 'dart:convert';

class Auth {
  final String tokenKey;
  final String group;
  final int accountID;
  final int profileID;

  Auth({
    required this.tokenKey,
    required this.group,
    required this.accountID,
    required this.profileID,
  });

  Auth copyWith({
    String? tokenKey,
    String? group,
    int? accountID,
    int? profileID,
  }) {
    return Auth(
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

  factory Auth.fromAPIResponse(Map<String, dynamic> map) {
    return Auth(
      tokenKey: map['key'] ?? '',
      group: map['group'] ?? '',
      accountID: map['account_id']?.toInt() ?? 0,
      profileID: map['profile_id']?.toInt() ?? 0,
    );
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      tokenKey: map['tokenKey'] ?? '',
      group: map['group'] ?? '',
      accountID: map['accountID']?.toInt() ?? 0,
      profileID: map['profileID']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Auth.fromJson(String source) => Auth.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Auth(tokenKey: $tokenKey, group: $group, accountID: $accountID, profileID: $profileID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Auth &&
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

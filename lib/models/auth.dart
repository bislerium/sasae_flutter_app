// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthModel {
  final String tokenKey;
  final UserGroup group;
  final int accountID;
  final int profileID;
  bool isVerified;
  AuthModel({
    required this.tokenKey,
    required this.group,
    required this.accountID,
    required this.profileID,
    required this.isVerified,
  });

  AuthModel copyWith({
    String? tokenKey,
    UserGroup? group,
    int? accountID,
    int? profileID,
    bool? isVerified,
  }) {
    return AuthModel(
      tokenKey: tokenKey ?? this.tokenKey,
      group: group ?? this.group,
      accountID: accountID ?? this.accountID,
      profileID: profileID ?? this.profileID,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokenKey': tokenKey,
      'group': group.name,
      'accountID': accountID,
      'profileID': profileID,
      'isVerified': isVerified,
    };
  }

  factory AuthModel.fromAPIResponse(Map<String, dynamic> map) {
    return AuthModel(
      tokenKey: map['key'] ?? '',
      group: getUserGroupFromString(map['group'] ?? ''),
      accountID: map['account_id']?.toInt() ?? 0,
      profileID: map['profile_id']?.toInt() ?? 0,
      isVerified: map['is_verified'] ?? false,
    );
  }

  static UserGroup getUserGroupFromString(String group) {
    return UserGroup.values.byName(group.toLowerCase());
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      tokenKey: map['tokenKey'] as String,
      group: getUserGroupFromString(map['group'] ?? ''),
      accountID: map['accountID'] as int,
      profileID: map['profileID'] as int,
      isVerified: map['isVerified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthModel(tokenKey: $tokenKey, group: $group, accountID: $accountID, profileID: $profileID, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant AuthModel other) {
    if (identical(this, other)) return true;

    return other.tokenKey == tokenKey &&
        other.group == group &&
        other.accountID == accountID &&
        other.profileID == profileID &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return tokenKey.hashCode ^
        group.hashCode ^
        accountID.hashCode ^
        profileID.hashCode ^
        isVerified.hashCode;
  }
}

enum UserGroup { general, ngo }

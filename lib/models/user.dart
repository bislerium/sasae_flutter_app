import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final int id;
  final bool isVerified;
  final String displayPicture;
  final String userName;
  final String fullName;
  final String gender;
  final DateTime birthDate;
  final String address;
  final String phoneNumber;
  final String email;
  final List<int> postedPosts;
  final DateTime joinedDate;
  final String? citizenshipPhoto;

  User({
    required this.id,
    required this.isVerified,
    required this.displayPicture,
    required this.userName,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.postedPosts,
    required this.joinedDate,
    this.citizenshipPhoto,
  });

  User copyWith({
    int? id,
    bool? isVerified,
    String? displayPicture,
    String? userName,
    String? fullName,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? phoneNumber,
    String? email,
    List<int>? postedPosts,
    DateTime? joinedDate,
    String? citizenshipPhoto,
  }) {
    return User(
      id: id ?? this.id,
      isVerified: isVerified ?? this.isVerified,
      displayPicture: displayPicture ?? this.displayPicture,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      postedPosts: postedPosts ?? this.postedPosts,
      joinedDate: joinedDate ?? this.joinedDate,
      citizenshipPhoto: citizenshipPhoto ?? this.citizenshipPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isVerified': isVerified,
      'displayPicture': displayPicture,
      'userName': userName,
      'fullName': fullName,
      'gender': gender,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'postedPosts': postedPosts,
      'joinedDate': joinedDate.millisecondsSinceEpoch,
      'citizenshipPhoto': citizenshipPhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      isVerified: map['isVerified'] ?? false,
      displayPicture: map['displayPicture'] ?? '',
      userName: map['userName'] ?? '',
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['posted_post']),
      joinedDate: DateTime.fromMillisecondsSinceEpoch(map['joinedDate']),
      citizenshipPhoto: map['citizenshipPhoto'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, isVerified: $isVerified, displayPicture: $displayPicture, userName: $userName, fullName: $fullName, gender: $gender, birthDate: $birthDate, address: $address, phoneNumber: $phoneNumber, email: $email, postedPosts: $postedPosts, joinedDate: $joinedDate, citizenshipPhoto: $citizenshipPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.isVerified == isVerified &&
        other.displayPicture == displayPicture &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        listEquals(other.postedPosts, postedPosts) &&
        other.joinedDate == joinedDate &&
        other.citizenshipPhoto == citizenshipPhoto;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isVerified.hashCode ^
        displayPicture.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        gender.hashCode ^
        birthDate.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        postedPosts.hashCode ^
        joinedDate.hashCode ^
        citizenshipPhoto.hashCode;
  }
}

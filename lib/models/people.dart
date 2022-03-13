import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/user.dart';

class People extends User {
  final String fullname;
  final String gender;
  final DateTime birthDate;
  final String address;
  final String? citizenshipPhoto;

  People({
    required int id,
    required bool isVerified,
    required String displayPicture,
    required String username,
    required this.fullname,
    required this.gender,
    required this.birthDate,
    required this.address,
    required String phone,
    required String email,
    required List<int> postedPosts,
    required DateTime joinedDate,
    this.citizenshipPhoto,
  }) : super(
          id: id,
          isVerified: isVerified,
          displayPicture: displayPicture,
          username: username,
          phone: phone,
          email: email,
          postedPosts: postedPosts,
          joinedDate: joinedDate,
        );

  People copyWith({
    int? id,
    bool? isVerified,
    String? displayPicture,
    String? username,
    String? fullname,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? phone,
    String? email,
    List<int>? postedPosts,
    DateTime? joinedDate,
    String? citizenshipPhoto,
  }) {
    return People(
      id: id ?? this.id,
      isVerified: isVerified ?? this.isVerified,
      displayPicture: displayPicture ?? this.displayPicture,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phone: phone ?? this.phone,
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
      'username': username,
      'fullname': fullname,
      'gender': gender,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'address': address,
      'phone': phone,
      'email': email,
      'postedPosts': postedPosts,
      'joinedDate': joinedDate.millisecondsSinceEpoch,
      'citizenshipPhoto': citizenshipPhoto,
    };
  }

  factory People.fromAPIResponse(Map<String, dynamic> map) {
    return People(
      id: map['id']?.toInt() ?? 0,
      isVerified: map['is_verified'] ?? false,
      displayPicture: map['display_picture'] ?? '',
      username: map['username'] ?? '',
      fullname: map['full_name'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: Jiffy(map['date_of_birth'], 'yyyy-MM-dd').dateTime,
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['posted_post']),
      joinedDate: Jiffy(map['date_joined'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
      citizenshipPhoto: map['citizenship_photo'],
    );
  }

  factory People.fromMap(Map<String, dynamic> map) {
    return People(
      id: map['id']?.toInt() ?? 0,
      isVerified: map['isVerified'] ?? false,
      displayPicture: map['displayPicture'] ?? '',
      username: map['username'] ?? '',
      fullname: map['fullname'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['postedPosts']),
      joinedDate: DateTime.fromMillisecondsSinceEpoch(map['joinedDate']),
      citizenshipPhoto: map['citizenshipPhoto'],
    );
  }

  String toJson() => json.encode(toMap());

  factory People.fromJson(String source) => People.fromMap(json.decode(source));

  @override
  String toString() {
    return 'People(id: $id, isVerified: $isVerified, displayPicture: $displayPicture, username: $username, fullname: $fullname, gender: $gender, birthDate: $birthDate, address: $address, phone: $phone, email: $email, postedPosts: $postedPosts, joinedDate: $joinedDate, citizenshipPhoto: $citizenshipPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is People &&
        other.id == id &&
        other.isVerified == isVerified &&
        other.displayPicture == displayPicture &&
        other.username == username &&
        other.fullname == fullname &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.address == address &&
        other.phone == phone &&
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
        username.hashCode ^
        fullname.hashCode ^
        gender.hashCode ^
        birthDate.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        postedPosts.hashCode ^
        joinedDate.hashCode ^
        citizenshipPhoto.hashCode;
  }
}

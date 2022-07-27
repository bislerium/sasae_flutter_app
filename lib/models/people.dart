import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/user.dart';

class PeopleModel extends UserModel {
  final String fullname;
  final String gender;
  final DateTime birthDate;
  final String address;
  final String? citizenshipPhoto;

  PeopleModel({
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

  PeopleModel copyWith({
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
    return PeopleModel(
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

  factory PeopleModel.fromAPIResponse(Map<String, dynamic> map) {
    return PeopleModel(
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

  factory PeopleModel.fromMap(Map<String, dynamic> map) {
    return PeopleModel(
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

  factory PeopleModel.fromJson(String source) =>
      PeopleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'People(id: $id, isVerified: $isVerified, displayPicture: $displayPicture, username: $username, fullname: $fullname, gender: $gender, birthDate: $birthDate, address: $address, phone: $phone, email: $email, postedPosts: $postedPosts, joinedDate: $joinedDate, citizenshipPhoto: $citizenshipPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PeopleModel &&
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

class PeopleUpdateModel {
  String? _fullname;
  String? _gender;
  DateTime? _birthDate;
  String? _address;
  String? _phone;
  String? _email;
  bool? _isVerified;
  XFile? _citizenshipPhoto;
  XFile? _displayPicture;
  String? _citizenshipPhotoLink;
  String? _displayPictureLink;

  String? get getFullname => _fullname;
  String? get getGender => _gender;
  DateTime? get getBirthDate => _birthDate;
  String? get getAddress => _address;
  String? get getPhone => _phone;
  String? get getEmail => _email;
  bool? get getIsverified => _isVerified;
  XFile? get getCitizenshipPhoto => _citizenshipPhoto;
  XFile? get getDisplayPicture => _displayPicture;
  String? get getCitizenshipPhotoLink => _citizenshipPhotoLink;
  String? get getDisplayPictureLink => _displayPictureLink;

  PeopleUpdateModel();

  set setFullname(String? fullName) => _fullname = fullName;
  set setGender(String? gender) => _gender = gender;
  set setBirthDate(DateTime? birthDate) => _birthDate = birthDate;
  set setAddress(String? address) => _address = address;
  set setPhone(String? phone) => _phone = phone;
  set setEmail(String? email) => _email = email;
  set setCitizenshipPhoto(XFile? citizenshipPhoto) =>
      _citizenshipPhoto = citizenshipPhoto;
  set setDisplayPicture(XFile? displayPicture) =>
      _displayPicture = displayPicture;
  set setIsVerified(bool? isVerified) => _isVerified = isVerified;

  void nullifyAll() {
    _fullname = null;
    _gender = null;
    _birthDate = null;
    _address = null;
    _phone = null;
    _email = null;
    _citizenshipPhoto = null;
    _displayPicture = null;
    _isVerified = null;
  }

  factory PeopleUpdateModel.fromAPIResponse(Map<String, dynamic> map) {
    return PeopleUpdateModel()
      .._fullname = map['full_name'] ?? ''
      .._gender = map['gender'] ?? ''
      .._birthDate = Jiffy(map['date_of_birth'], 'yyyy-MM-dd').dateTime
      .._address = map['address'] ?? ''
      .._phone = map['phone'] ?? ''
      .._email = map['email'] ?? ''
      .._isVerified = map['is_verified'] ?? false
      .._displayPictureLink = map['display_picture']
      .._citizenshipPhotoLink = map['citizenship_photo'];
  }

  @override
  String toString() {
    return 'PeopleUpdate(_fullname: $_fullname, _gender: $_gender, _birthDate: $_birthDate, _address: $_address, _phone: $_phone, _email: $_email, _citizenshipPhoto: $_citizenshipPhoto, _displayPicture: $_displayPicture, _citizenshipPhotoLink: $_citizenshipPhotoLink, _displayPictureLink: $_displayPictureLink)';
  }
}

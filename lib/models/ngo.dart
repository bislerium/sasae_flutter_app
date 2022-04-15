import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'package:sasae_flutter_app/models/user.dart';

import 'bank.dart';

class NGOModel extends UserModel {
  final double latitude;
  final double longitude;
  final String orgName;
  final DateTime estDate;
  final List<String> fieldOfWork;
  final String address;

  final String? epayAccount;
  final BankModel? bank;
  final String? swcCertificateURL;
  final String? panCertificateURL;

  NGOModel({
    required int id,
    required this.latitude,
    required this.longitude,
    required String username,
    required this.orgName,
    required String displayPicture,
    required bool isVerified,
    required this.estDate,
    required this.fieldOfWork,
    required this.address,
    required String phone,
    required String email,
    required List<int> postedPosts,
    required DateTime joinedDate,
    this.epayAccount,
    this.bank,
    this.swcCertificateURL,
    this.panCertificateURL,
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

  NGOModel copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? username,
    String? orgName,
    String? displayPicture,
    bool? isVerified,
    DateTime? estDate,
    List<String>? fieldOfWork,
    String? address,
    String? phone,
    String? email,
    List<int>? postedPosts,
    DateTime? joinedDate,
    String? epayAccount,
    BankModel? bank,
    String? swcCertificateURL,
    String? panCertificateURL,
  }) {
    return NGOModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      username: username ?? this.username,
      orgName: orgName ?? this.orgName,
      displayPicture: displayPicture ?? this.displayPicture,
      isVerified: isVerified ?? this.isVerified,
      estDate: estDate ?? this.estDate,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      postedPosts: postedPosts ?? this.postedPosts,
      joinedDate: joinedDate ?? this.joinedDate,
      epayAccount: epayAccount ?? this.epayAccount,
      bank: bank ?? this.bank,
      swcCertificateURL: swcCertificateURL ?? this.swcCertificateURL,
      panCertificateURL: panCertificateURL ?? this.panCertificateURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'username': username,
      'orgName': orgName,
      'displayPicture': displayPicture,
      'isVerified': isVerified,
      'estDate': estDate.millisecondsSinceEpoch,
      'fieldOfWork': fieldOfWork,
      'address': address,
      'phone': phone,
      'email': email,
      'postedPosts': postedPosts,
      'joinedDate': joinedDate.millisecondsSinceEpoch,
      'epayAccount': epayAccount,
      'bank': bank?.toMap(),
      'swcCertificateURL': swcCertificateURL,
      'panCertificateURL': panCertificateURL,
    };
  }

  factory NGOModel.fromAPIResponse(Map<String, dynamic> map) {
    return NGOModel(
      id: map['id']?.toInt() ?? 0,
      latitude: map['latitude'] == null ? 0.0 : double.parse(map['latitude']),
      longitude:
          map['longitude'] == null ? 0.0 : double.parse(map['longitude']),
      username: map['username'] ?? '',
      orgName: map['full_name'] ?? '',
      displayPicture: map['display_picture'] ?? '',
      isVerified: map['is_verified'] ?? false,
      estDate: Jiffy(map['establishment_date'], 'yyyy-MM-dd').dateTime,
      fieldOfWork: List<String>.from(map['field_of_work']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['posted_post']),
      joinedDate: Jiffy(map['date_joined'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
      epayAccount: map['epay_account'],
      bank: map['bank'] != null ? BankModel.fromAPIResponse(map['bank']) : null,
      swcCertificateURL: map['swc_affl_cert'],
      panCertificateURL: map['pan_cert'],
    );
  }

  factory NGOModel.fromMap(Map<String, dynamic> map) {
    return NGOModel(
      id: map['id']?.toInt() ?? 0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      username: map['username'] ?? '',
      orgName: map['orgName'] ?? '',
      displayPicture: map['displayPicture'] ?? '',
      isVerified: map['isVerified'] ?? false,
      estDate: DateTime.fromMillisecondsSinceEpoch(map['estDate']),
      fieldOfWork: List<String>.from(map['fieldOfWork']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['postedPosts']),
      joinedDate: DateTime.fromMillisecondsSinceEpoch(map['joinedDate']),
      epayAccount: map['epayAccount'],
      bank: map['bank'] != null ? BankModel.fromAPIResponse(map['bank']) : null,
      swcCertificateURL: map['swcCertificateURL'],
      panCertificateURL: map['panCertificateURL'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NGOModel.fromJson(String source) =>
      NGOModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NGO(id: $id, latitude: $latitude, longitude: $longitude, username: $username, orgName: $orgName, displayPicture: $displayPicture, isVerified: $isVerified, estDate: $estDate, fieldOfWork: $fieldOfWork, address: $address, phone: $phone, email: $email, postedPosts: $postedPosts, joinedDate: $joinedDate, epayAccount: $epayAccount, bank: $bank, swcCertificateURL: $swcCertificateURL, panCertificateURL: $panCertificateURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGOModel &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.username == username &&
        other.orgName == orgName &&
        other.displayPicture == displayPicture &&
        other.isVerified == isVerified &&
        other.estDate == estDate &&
        listEquals(other.fieldOfWork, fieldOfWork) &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        listEquals(other.postedPosts, postedPosts) &&
        other.joinedDate == joinedDate &&
        other.epayAccount == epayAccount &&
        other.bank == bank &&
        other.swcCertificateURL == swcCertificateURL &&
        other.panCertificateURL == panCertificateURL;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        username.hashCode ^
        orgName.hashCode ^
        displayPicture.hashCode ^
        isVerified.hashCode ^
        estDate.hashCode ^
        fieldOfWork.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        postedPosts.hashCode ^
        joinedDate.hashCode ^
        epayAccount.hashCode ^
        bank.hashCode ^
        swcCertificateURL.hashCode ^
        panCertificateURL.hashCode;
  }
}

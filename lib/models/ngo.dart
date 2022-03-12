import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

import 'bank.dart';

class NGO {
  final int ngoID;
  final double latitude;
  final double longitude;
  final String orgName;
  final String orgPhoto;
  final DateTime estDate;
  final List<String> fieldOfWork;
  final String address;
  final String phone;
  final String email;
  final List<int> postedPosts;
  final bool isVerified;
  final String? epayAccount;
  final Bank? bank;
  final String? swcCertificateURL;
  final String? panCertificateURL;

  NGO({
    required this.ngoID,
    required this.latitude,
    required this.longitude,
    required this.orgName,
    required this.orgPhoto,
    required this.estDate,
    required this.fieldOfWork,
    required this.address,
    required this.phone,
    required this.email,
    required this.postedPosts,
    required this.isVerified,
    this.epayAccount,
    this.bank,
    this.swcCertificateURL,
    this.panCertificateURL,
  });

  NGO copyWith({
    int? ngoID,
    double? latitude,
    double? longitude,
    String? orgName,
    String? orgPhoto,
    DateTime? estDate,
    List<String>? fieldOfWork,
    String? address,
    String? phone,
    String? email,
    List<int>? postedPosts,
    bool? isVerified,
    String? epayAccount,
    Bank? bank,
    String? swcCertificateURL,
    String? panCertificateURL,
  }) {
    return NGO(
      ngoID: ngoID ?? this.ngoID,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
      estDate: estDate ?? this.estDate,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      postedPosts: postedPosts ?? this.postedPosts,
      isVerified: isVerified ?? this.isVerified,
      epayAccount: epayAccount ?? this.epayAccount,
      bank: bank ?? this.bank,
      swcCertificateURL: swcCertificateURL ?? this.swcCertificateURL,
      panCertificateURL: panCertificateURL ?? this.panCertificateURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ngoID': ngoID,
      'latitude': latitude,
      'longitude': longitude,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
      'estDate': estDate.millisecondsSinceEpoch,
      'fieldOfWork': fieldOfWork,
      'address': address,
      'phone': phone,
      'email': email,
      'postedPosts': postedPosts,
      'isVerified': isVerified,
      'epayAccount': epayAccount,
      'bank': bank?.toMap(),
      'swcCertificateURL': swcCertificateURL,
      'panCertificateURL': panCertificateURL,
    };
  }

  factory NGO.fromAPIResponse(Map<String, dynamic> map) {
    return NGO(
      ngoID: map['id']?.toInt() ?? 0,
      latitude: map['latitude'] == null ? 0.0 : double.parse(map['latitude']),
      longitude:
          map['longitude'] == null ? 0.0 : double.parse(map['longitude']),
      orgName: map['full_name'] ?? '',
      orgPhoto: map['display_picture'] ?? '',
      estDate: Jiffy(map['establishment_date'], 'yyyy-MM-dd').dateTime,
      fieldOfWork: List<String>.from(map['field_of_work']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['posted_post']),
      isVerified: map['is_verified'] ?? false,
      epayAccount: map['epay_account'],
      bank: map['bank'] != null ? Bank.fromMap(map['bank']) : null,
      swcCertificateURL: map['swc_affl_cert'],
      panCertificateURL: map['pan_cert'],
    );
  }

  factory NGO.fromMap(Map<String, dynamic> map) {
    return NGO(
      ngoID: map['ngoID']?.toInt() ?? 0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      orgName: map['orgName'] ?? '',
      orgPhoto: map['orgPhoto'] ?? '',
      estDate: DateTime.fromMillisecondsSinceEpoch(map['estDate']),
      fieldOfWork: List<String>.from(map['fieldOfWork']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      postedPosts: List<int>.from(map['postedPosts']),
      isVerified: map['isVerified'] ?? false,
      epayAccount: map['epayAccount'],
      bank: map['bank'] != null ? Bank.fromMap(map['bank']) : null,
      swcCertificateURL: map['swcCertificateURL'],
      panCertificateURL: map['panCertificateURL'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO.fromJson(String source) => NGO.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NGO(ngoID: $ngoID, latitude: $latitude, longitude: $longitude, orgName: $orgName, orgPhoto: $orgPhoto, estDate: $estDate, fieldOfWork: $fieldOfWork, address: $address, phone: $phone, email: $email, postedPosts: $postedPosts, isVerified: $isVerified, epayAccount: $epayAccount, bank: $bank, swcCertificateURL: $swcCertificateURL, panCertificateURL: $panCertificateURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO &&
        other.ngoID == ngoID &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto &&
        other.estDate == estDate &&
        listEquals(other.fieldOfWork, fieldOfWork) &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        listEquals(other.postedPosts, postedPosts) &&
        other.isVerified == isVerified &&
        other.epayAccount == epayAccount &&
        other.bank == bank &&
        other.swcCertificateURL == swcCertificateURL &&
        other.panCertificateURL == panCertificateURL;
  }

  @override
  int get hashCode {
    return ngoID.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        orgName.hashCode ^
        orgPhoto.hashCode ^
        estDate.hashCode ^
        fieldOfWork.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        postedPosts.hashCode ^
        isVerified.hashCode ^
        epayAccount.hashCode ^
        bank.hashCode ^
        swcCertificateURL.hashCode ^
        panCertificateURL.hashCode;
  }
}

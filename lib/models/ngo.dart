import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'bank.dart';

class NGO {
  final int id;
  final double latitude;
  final double longitude;
  final String orgName;
  final String orgPhoto;
  final DateTime estDate;
  final List<String> fieldOfWork;
  final String address;
  final String phone;
  final String email;
  final bool isVerified;
  final String? epayAccount;
  final Bank? bank;
  final String? swcCertificateURL;
  final String? panCertificateURL;
  NGO({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.orgName,
    required this.orgPhoto,
    required this.estDate,
    required this.fieldOfWork,
    required this.address,
    required this.phone,
    required this.email,
    required this.isVerified,
    this.epayAccount,
    this.bank,
    this.swcCertificateURL,
    this.panCertificateURL,
  });

  NGO copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? orgName,
    String? orgPhoto,
    DateTime? estDate,
    List<String>? fieldOfWork,
    String? address,
    String? phone,
    String? email,
    bool? isVerified,
    String? epayAccount,
    Bank? bank,
    String? swcCertificateURL,
    String? panCertificateURL,
  }) {
    return NGO(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
      estDate: estDate ?? this.estDate,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
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
      'orgName': orgName,
      'orgPhoto': orgPhoto,
      'estDate': estDate.millisecondsSinceEpoch,
      'fieldOfWork': fieldOfWork,
      'address': address,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'epayAccount': epayAccount,
      'bank': bank?.toMap(),
      'swcCertificateURL': swcCertificateURL,
      'panCertificateURL': panCertificateURL,
    };
  }

  factory NGO.fromMap(Map<String, dynamic> map) {
    return NGO(
      id: map['id']?.toInt() ?? 0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      orgName: map['orgName'] ?? '',
      orgPhoto: map['orgPhoto'] ?? '',
      estDate: DateTime.fromMillisecondsSinceEpoch(map['estDate']),
      fieldOfWork: List<String>.from(map['fieldOfWork']),
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
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
    return 'NGO(id: $id, latitude: $latitude, longitude: $longitude, orgName: $orgName, orgPhoto: $orgPhoto, estDate: $estDate, fieldOfWork: $fieldOfWork, address: $address, phone: $phone, email: $email, isVerified: $isVerified, epayAccount: $epayAccount, bank: $bank, swcCertificateURL: $swcCertificateURL, panCertificateURL: $panCertificateURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto &&
        other.estDate == estDate &&
        listEquals(other.fieldOfWork, fieldOfWork) &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.isVerified == isVerified &&
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
        orgName.hashCode ^
        orgPhoto.hashCode ^
        estDate.hashCode ^
        fieldOfWork.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        isVerified.hashCode ^
        epayAccount.hashCode ^
        bank.hashCode ^
        swcCertificateURL.hashCode ^
        panCertificateURL.hashCode;
  }
}

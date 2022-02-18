import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore: camel_case_types
class NGO_ {
  final int id;
  final String ngoURL;
  final String orgName;
  final String orgPhoto;
  final DateTime estDate;
  final List<String> fieldOfWork;
  final String address;

  NGO_({
    required this.id,
    required this.ngoURL,
    required this.orgName,
    required this.orgPhoto,
    required this.estDate,
    required this.fieldOfWork,
    required this.address,
  });

  NGO_ copyWith({
    int? id,
    String? ngoURL,
    String? orgName,
    String? orgPhoto,
    DateTime? estDate,
    List<String>? fieldOfWork,
    String? address,
  }) {
    return NGO_(
      id: id ?? this.id,
      ngoURL: ngoURL ?? this.ngoURL,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
      estDate: estDate ?? this.estDate,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ngoURL': ngoURL,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
      'estDate': estDate.millisecondsSinceEpoch,
      'fieldOfWork': fieldOfWork,
      'address': address,
    };
  }

  factory NGO_.fromMap(Map<String, dynamic> map) {
    return NGO_(
      id: map['id']?.toInt() ?? 0,
      ngoURL: map['ngoURL'] ?? '',
      orgName: map['orgName'] ?? '',
      orgPhoto: map['orgPhoto'] ?? '',
      estDate: DateTime.fromMillisecondsSinceEpoch(map['estDate']),
      fieldOfWork: List<String>.from(map['fieldOfWork']),
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO_.fromJson(String source) => NGO_.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NGO_(id: $id, ngoURL: $ngoURL, orgName: $orgName, orgPhoto: $orgPhoto, estDate: $estDate, fieldOfWork: $fieldOfWork, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO_ &&
        other.id == id &&
        other.ngoURL == ngoURL &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto &&
        other.estDate == estDate &&
        listEquals(other.fieldOfWork, fieldOfWork) &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ngoURL.hashCode ^
        orgName.hashCode ^
        orgPhoto.hashCode ^
        estDate.hashCode ^
        fieldOfWork.hashCode ^
        address.hashCode;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

// ignore: camel_case_types
class NGO_ {
  final int ngoID;
  final String orgName;
  final String orgPhoto;
  final DateTime estDate;
  final List<String> fieldOfWork;
  final String address;

  NGO_({
    required this.ngoID,
    required this.orgName,
    required this.orgPhoto,
    required this.estDate,
    required this.fieldOfWork,
    required this.address,
  });

  NGO_ copyWith({
    int? ngoID,
    String? orgName,
    String? orgPhoto,
    DateTime? estDate,
    List<String>? fieldOfWork,
    String? address,
  }) {
    return NGO_(
      ngoID: ngoID ?? this.ngoID,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
      estDate: estDate ?? this.estDate,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ngoID': ngoID,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
      'estDate': estDate.millisecondsSinceEpoch,
      'fieldOfWork': fieldOfWork,
      'address': address,
    };
  }

  factory NGO_.fromAPIResponse(Map<String, dynamic> map) {
    return NGO_(
      ngoID: map['id']?.toInt() ?? 0,
      orgName: map['full_name'] ?? '',
      orgPhoto: map['display_picture'] ?? '',
      estDate: Jiffy(map['establishment_date'], 'yyyy-MM-dd').dateTime,
      fieldOfWork: List<String>.from(map['field_of_work']),
      address: map['address'] ?? '',
    );
  }

  factory NGO_.fromMap(Map<String, dynamic> map) {
    return NGO_(
      ngoID: map['ngoID']?.toInt() ?? 0,
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
    return 'NGO_(ngoID: $ngoID, orgName: $orgName, orgPhoto: $orgPhoto, estDate: $estDate, fieldOfWork: $fieldOfWork, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO_ &&
        other.ngoID == ngoID &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto &&
        other.estDate == estDate &&
        listEquals(other.fieldOfWork, fieldOfWork) &&
        other.address == address;
  }

  @override
  int get hashCode {
    return ngoID.hashCode ^
        orgName.hashCode ^
        orgPhoto.hashCode ^
        estDate.hashCode ^
        fieldOfWork.hashCode ^
        address.hashCode;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore: camel_case_types
class NGO__Model {
  final int id;
  final String orgName;
  final String orgPhoto;
  final List<String> fieldOfWork;
  NGO__Model({
    required this.id,
    required this.orgName,
    required this.orgPhoto,
    required this.fieldOfWork,
  });

  NGO__Model copyWith({
    int? id,
    String? orgName,
    String? orgPhoto,
    List<String>? fieldOfWork,
  }) {
    return NGO__Model(
      id: id ?? this.id,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
      'fieldOfWork': fieldOfWork,
    };
  }

  factory NGO__Model.fromAPIResponse(Map<String, dynamic> map) {
    return NGO__Model(
      id: map['id']?.toInt() ?? 0,
      orgName: map['full_name'] ?? '',
      orgPhoto: map['display_picture'] ?? '',
      fieldOfWork: List<String>.from(map['field_of_work']),
    );
  }

  factory NGO__Model.fromMap(Map<String, dynamic> map) {
    return NGO__Model(
      id: map['id'] as int,
      orgName: map['orgName'] as String,
      orgPhoto: map['orgPhoto'] as String,
      fieldOfWork: List<String>.from(
        (map['fieldOfWork'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO__Model.fromJson(String source) =>
      NGO__Model.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NGO__Model(id: $id, orgName: $orgName, orgPhoto: $orgPhoto, fieldOfWork: $fieldOfWork)';
  }

  @override
  bool operator ==(covariant NGO__Model other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto &&
        listEquals(other.fieldOfWork, fieldOfWork);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orgName.hashCode ^
        orgPhoto.hashCode ^
        fieldOfWork.hashCode;
  }
}

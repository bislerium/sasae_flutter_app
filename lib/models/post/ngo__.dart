import 'dart:convert';

// ignore: camel_case_types
class NGO__Model {
  final int id;
  final String orgName;
  final String orgPhoto;

  NGO__Model({
    required this.id,
    required this.orgName,
    required this.orgPhoto,
  });

  NGO__Model copyWith({
    int? id,
    String? orgName,
    String? orgPhoto,
  }) {
    return NGO__Model(
      id: id ?? this.id,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
    };
  }

  factory NGO__Model.fromAPIResponse(Map<String, dynamic> map) {
    return NGO__Model(
      id: map['id']?.toInt() ?? 0,
      orgName: map['full_name'] ?? '',
      orgPhoto: map['display_picture'] ?? '',
    );
  }

  factory NGO__Model.fromMap(Map<String, dynamic> map) {
    return NGO__Model(
      id: map['id']?.toInt() ?? 0,
      orgName: map['orgName'] ?? '',
      orgPhoto: map['orgPhoto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO__Model.fromJson(String source) =>
      NGO__Model.fromMap(json.decode(source));

  @override
  String toString() => 'NGO__(id: $id, orgName: $orgName, orgPhoto: $orgPhoto)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO__Model &&
        other.id == id &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto;
  }

  @override
  int get hashCode => id.hashCode ^ orgName.hashCode ^ orgPhoto.hashCode;
}

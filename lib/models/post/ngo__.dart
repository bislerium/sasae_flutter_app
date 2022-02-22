import 'dart:convert';

// ignore: camel_case_types
class NGO__ {
  final int id;
  final String ngoURL;
  final String orgName;
  final String orgPhoto;

  NGO__({
    required this.id,
    required this.ngoURL,
    required this.orgName,
    required this.orgPhoto,
  });

  NGO__ copyWith({
    int? id,
    String? ngoURL,
    String? orgName,
    String? orgPhoto,
  }) {
    return NGO__(
      id: id ?? this.id,
      ngoURL: ngoURL ?? this.ngoURL,
      orgName: orgName ?? this.orgName,
      orgPhoto: orgPhoto ?? this.orgPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ngoURL': ngoURL,
      'orgName': orgName,
      'orgPhoto': orgPhoto,
    };
  }

  factory NGO__.fromMap(Map<String, dynamic> map) {
    return NGO__(
      id: map['id']?.toInt() ?? 0,
      ngoURL: map['ngoURL'] ?? '',
      orgName: map['orgName'] ?? '',
      orgPhoto: map['orgPhoto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NGO__.fromJson(String source) => NGO__.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NGO__(id: $id, ngoURL: $ngoURL, orgName: $orgName, orgPhoto: $orgPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NGO__ &&
        other.id == id &&
        other.ngoURL == ngoURL &&
        other.orgName == orgName &&
        other.orgPhoto == orgPhoto;
  }

  @override
  int get hashCode {
    return id.hashCode ^ ngoURL.hashCode ^ orgName.hashCode ^ orgPhoto.hashCode;
  }
}

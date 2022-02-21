import 'dart:convert';

class User {
  final int id;
  final bool isVerified;
  final String displayPicture;
  final int numOfPosts;
  final String userName;
  final String fullName;
  final String gender;
  final DateTime birthDate;
  final String address;
  final String phoneNumber;
  final String email;
  final DateTime joinedDate;
  final String? citizenshipPhoto;
  User({
    required this.id,
    required this.isVerified,
    required this.displayPicture,
    required this.numOfPosts,
    required this.userName,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.joinedDate,
    this.citizenshipPhoto,
  });

  User copyWith({
    int? id,
    bool? isVerified,
    String? displayPicture,
    int? numOfPosts,
    String? userName,
    String? fullName,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? phoneNumber,
    String? email,
    DateTime? joinedDate,
    String? citizenshipPhoto,
  }) {
    return User(
      id: id ?? this.id,
      isVerified: isVerified ?? this.isVerified,
      displayPicture: displayPicture ?? this.displayPicture,
      numOfPosts: numOfPosts ?? this.numOfPosts,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      joinedDate: joinedDate ?? this.joinedDate,
      citizenshipPhoto: citizenshipPhoto ?? this.citizenshipPhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isVerified': isVerified,
      'displayPicture': displayPicture,
      'numOfPosts': numOfPosts,
      'userName': userName,
      'fullName': fullName,
      'gender': gender,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'joinedDate': joinedDate.millisecondsSinceEpoch,
      'citizenshipPhoto': citizenshipPhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      isVerified: map['isVerified'] ?? false,
      displayPicture: map['displayPicture'] ?? '',
      numOfPosts: map['numOfPosts']?.toInt() ?? 0,
      userName: map['userName'] ?? '',
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      joinedDate: DateTime.fromMillisecondsSinceEpoch(map['joinedDate']),
      citizenshipPhoto: map['citizenshipPhoto'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, isVerified: $isVerified, displayPicture: $displayPicture, numOfPosts: $numOfPosts, userName: $userName, fullName: $fullName, gender: $gender, birthDate: $birthDate, address: $address, phoneNumber: $phoneNumber, email: $email, joinedDate: $joinedDate, citizenshipPhoto: $citizenshipPhoto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.isVerified == isVerified &&
        other.displayPicture == displayPicture &&
        other.numOfPosts == numOfPosts &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.joinedDate == joinedDate &&
        other.citizenshipPhoto == citizenshipPhoto;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isVerified.hashCode ^
        displayPicture.hashCode ^
        numOfPosts.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        gender.hashCode ^
        birthDate.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        joinedDate.hashCode ^
        citizenshipPhoto.hashCode;
  }
}
import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> json;
  late PeopleModel peopleModel;

  setUpAll(() {
    bool isVerified = faker.randomGenerator.boolean();
    json = {
      'id': faker.randomGenerator.integer(1000),
      'is_verified': isVerified,
      'display_picture': faker.image.image(),
      'username': faker.internet.userName(),
      'full_name': faker.person.name(),
      'gender': faker.randomGenerator.element(['Male', 'Female', 'LGBTQ+']),
      'date_of_birth': Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
          .format('yyyy-MM-dd'),
      'address': faker.address.streetAddress(),
      'phone': faker.phoneNumber.us(),
      'email': faker.internet.email(),
      'posted_post': Set<int>.of(List.generate(
          faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      'date_joined': Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
          .format("yyyy-MM-dd'T'HH:mm:ss"),
      'citizenship_photo': isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    };
  });

  test('JSON deserialized to PeopleModel Instance', () {
    peopleModel = PeopleModel.fromAPIResponse(json);
    expect(peopleModel, isA<PeopleModel>());
  });

  test('Account ID casted', () {
    expect(peopleModel.id, json['id']);
  });

  test('Is-verified casted', () {
    expect(peopleModel.isVerified, json['is_verified']);
  });

  test('Display picture casted', () {
    expect(peopleModel.displayPicture, json['display_picture']);
  });

  test('Username casted', () {
    expect(peopleModel.username, json['username']);
  });

  test('Fullname casted', () {
    expect(peopleModel.fullName, json['full_name']);
  });

  test('Gender casted', () {
    expect(peopleModel.gender, json['gender']);
  });

  test('Birthdate casted', () {
    expect(peopleModel.birthDate,
        Jiffy(json['date_of_birth'], 'yyyy-MM-dd').dateTime);
  });

  test('Address casted', () {
    expect(peopleModel.address, json['address']);
  });

  test('Phone casted', () {
    expect(peopleModel.phone, json['phone']);
  });

  test('Email casted', () {
    expect(peopleModel.email, json['email']);
  });

  test('Posted posts casted', () {
    expect(peopleModel.postedPosts, json['posted_post']);
  });

  test('Joined date casted', () {
    expect(
      peopleModel.joinedDate,
      Jiffy(json['date_joined'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
    );
  });

  test('Citizenship photo casted', () {
    expect(peopleModel.citizenshipPhoto, json['citizenship_photo']);
  });
}

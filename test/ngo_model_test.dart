import 'dart:math';

import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> json;
  late NGOModel ngoModel;

  setUpAll(() {
    var isVerified = faker.randomGenerator.boolean();
    json = {
      "id": faker.randomGenerator.integer(1000),
      "field_of_work": List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      "latitude": faker.randomGenerator
          .decimal(scale: (90 - (-90)), min: -90)
          .toString(),
      "longitude": faker.randomGenerator
          .decimal(scale: (180 - (-180)), min: -180)
          .toString(),
      "phone": getRandPhoneNumber(),
      "address": faker.address.city(),
      "is_verified": isVerified,
      "full_name": faker.company.name(),
      "establishment_date":
          Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
              .format('yyyy-MM-dd'),
      "display_picture":
          faker.image.image(width: 600, height: 600, random: true),
      "epay_account": isVerified ? getRandPhoneNumber() : null,
      "swc_affl_cert": isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      "pan_cert": isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      "bank": isVerified
          ? {
              'bank_name': faker.company.name(),
              'bank_branch': faker.address.city(),
              'bank_BSB':
                  int.parse(faker.randomGenerator.numberOfLength(6)).toString(),
              'bank_account_name': faker.company.name(),
              'bank_account_number': int.parse(faker.randomGenerator
                      .numberOfLength(
                          faker.randomGenerator.integer(16, min: 9)))
                  .toString()
            }
          : null,
      "posted_post": Set<int>.of(List.generate(
          faker.randomGenerator.integer(250),
          (index) => faker.randomGenerator.integer(3000))).toList(),
      "username": faker.person.firstName(),
      "email": faker.internet.email(),
      "date_joined": Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
          .format("yyyy-MM-dd'T'HH:mm:ss"),
    };
  });

  test('JSON deserialized to NGOModel Instance', () {
    ngoModel = NGOModel.fromAPIResponse(json);
    expect(ngoModel, isA<NGOModel>());
  });

  test('Account ID casted', () {
    expect(ngoModel.id, json['id']);
  });

  test('Field of work casted', () {
    expect(ngoModel.fieldOfWork, json['field_of_work']);
  });

  test('Latitude casted', () {
    expect(ngoModel.latitude, double.parse(json['latitude']));
  });

  test('Longitude casted', () {
    expect(ngoModel.longitude, double.parse(json['longitude']));
  });

  test('Phone casted', () {
    expect(ngoModel.phone, json['phone']);
  });

  test('Address casted', () {
    expect(ngoModel.address, json['address']);
  });

  test('Is-verified casted', () {
    expect(ngoModel.isVerified, json['is_verified']);
  });

  test('Fullname casted', () {
    expect(ngoModel.orgName, json['full_name']);
  });

  test('Establishment date casted', () {
    expect(
      ngoModel.estDate,
      Jiffy(json['establishment_date'], 'yyyy-MM-dd').dateTime,
    );
  });

  test('Display picture casted', () {
    expect(ngoModel.displayPicture, json['display_picture']);
  });

  test('Epay account number casted', () {
    expect(ngoModel.epayAccount, json['epay_account']);
  });
  test('SWC affilation certificate casted', () {
    expect(ngoModel.swcCertificateURL, json['swc_affl_cert']);
  });
  test('PAN certificate casted', () {
    expect(ngoModel.panCertificateURL, json['pan_cert']);
  });
  test('Bank casted', () {
    expect(ngoModel.bank,
        json['bank'] == null ? null : BankModel.fromAPIResponse(json['bank']));
  });

  test('Posted posts casted', () {
    expect(ngoModel.postedPosts, json['posted_post']);
  });

  test('Username casted', () {
    expect(ngoModel.username, json['username']);
  });

  test('Email casted', () {
    expect(ngoModel.email, json['email']);
  });

  test('Date joined casted', () {
    expect(
      ngoModel.joinedDate,
      Jiffy(json['date_joined'], "yyyy-MM-dd'T'HH:mm:ss").dateTime,
    );
  });
}

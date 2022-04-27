import 'package:faker/faker.dart';
import 'package:sasae_flutter_app/models/auth.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late AuthModel authModel;

  setUpAll(() {
    json = {
      'key': faker.jwt.secret,
      'group': faker.randomGenerator.element(['NGO', 'General']),
      'account_id': faker.randomGenerator.integer(2000),
      'profile_id': faker.randomGenerator.integer(2000)
    };
  });

  test('JSON de-serialized to AuthModel Instance', () {
    authModel = AuthModel.fromAPIResponse(json);
    expect(authModel, isA<AuthModel>());
  });

  test('TokenKey casted', () {
    expect(authModel.tokenKey, json['key']);
  });

  test('Group casted', () {
    expect(authModel.group, json['group']);
  });

  test('AccountID casted', () {
    expect(authModel.accountID, json['account_id']);
  });

  test('ProfileID casted', () {
    expect(authModel.profileID, json['profile_id']);
  });
}

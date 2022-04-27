import 'package:faker/faker.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late BankModel bankModel;

  setUpAll(() {
    json = {
      'bank_name': faker.company.name(),
      'bank_branch': faker.address.city(),
      'bank_BSB': int.parse(faker.randomGenerator.numberOfLength(6)).toString(),
      'bank_account_name': faker.company.name(),
      'bank_account_number': int.parse(faker.randomGenerator
              .numberOfLength(faker.randomGenerator.integer(16, min: 9)))
          .toString()
    };
  });

  test('JSON deserialized to BankModel Instance', () {
    bankModel = BankModel.fromAPIResponse(json);
    expect(bankModel, isA<BankModel>());
  });

  test('Bank name casted', () {
    expect(bankModel.bankName, json['bank_name']);
  });

  test('Bank branch casted', () {
    expect(bankModel.bankBranch, json['bank_branch']);
  });

  test('Bank BSB casted', () {
    expect(bankModel.bankBSB, json['bank_BSB']);
  });

  test('Account name casted', () {
    expect(bankModel.bankAccountName, json['bank_account_name']);
  });

  test('Account number casted', () {
    expect(bankModel.bankAccountNumber, json['bank_account_number']);
  });
}

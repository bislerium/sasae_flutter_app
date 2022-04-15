import 'dart:convert';

class BankModel {
  final String bankName;
  final String bankBranch;
  final String bankBSB;
  final String bankAccountName;
  final String bankAccountNumber;

  BankModel({
    required this.bankName,
    required this.bankBranch,
    required this.bankBSB,
    required this.bankAccountName,
    required this.bankAccountNumber,
  });

  BankModel copyWith({
    String? bankName,
    String? bankBranch,
    String? bankBSB,
    String? bankAccountName,
    String? bankAccountNumber,
  }) {
    return BankModel(
      bankName: bankName ?? this.bankName,
      bankBranch: bankBranch ?? this.bankBranch,
      bankBSB: bankBSB ?? this.bankBSB,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'bankBranch': bankBranch,
      'bankBSB': bankBSB,
      'bankAccountName': bankAccountName,
      'bankAccountNumber': bankAccountNumber,
    };
  }

  factory BankModel.fromAPIResponse(Map<String, dynamic> map) {
    return BankModel(
      bankName: map['bank_name'] ?? '',
      bankBranch: map['bank_branch'] ?? '',
      bankBSB: map['bank_BSB'] ?? '',
      bankAccountName: map['bank_account_name'] ?? '',
      bankAccountNumber: map['bank_account_number'] ?? '',
    );
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      bankName: map['bankName'] ?? '',
      bankBranch: map['bankBranch'] ?? '',
      bankBSB: map['bankBSB'] ?? '',
      bankAccountName: map['bankAccountName'] ?? '',
      bankAccountNumber: map['bankAccountNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BankModel.fromJson(String source) =>
      BankModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankModel(bankName: $bankName, bankBranch: $bankBranch, bankBSB: $bankBSB, bankAccountName: $bankAccountName, bankAccountNumber: $bankAccountNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankModel &&
        other.bankName == bankName &&
        other.bankBranch == bankBranch &&
        other.bankBSB == bankBSB &&
        other.bankAccountName == bankAccountName &&
        other.bankAccountNumber == bankAccountNumber;
  }

  @override
  int get hashCode {
    return bankName.hashCode ^
        bankBranch.hashCode ^
        bankBSB.hashCode ^
        bankAccountName.hashCode ^
        bankAccountNumber.hashCode;
  }
}

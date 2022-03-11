import 'dart:convert';

class Bank {
  final String bankName;
  final String bankBranch;
  final String bankBSB;
  final String bankAccountName;
  final String bankAccountNumber;

  Bank({
    required this.bankName,
    required this.bankBranch,
    required this.bankBSB,
    required this.bankAccountName,
    required this.bankAccountNumber,
  });

  Bank copyWith({
    String? bankName,
    String? bankBranch,
    String? bankBSB,
    String? bankAccountName,
    String? bankAccountNumber,
  }) {
    return Bank(
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

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      bankName: map['bank_name'] ?? '',
      bankBranch: map['bank_branch'] ?? '',
      bankBSB: map['bank_BSB'] ?? '',
      bankAccountName: map['bank_account_name'] ?? '',
      bankAccountNumber: map['bank_account_number'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Bank.fromJson(String source) => Bank.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Bank(bankName: $bankName, bankBranch: $bankBranch, bankBSB: $bankBSB, bankAccountName: $bankAccountName, bankAccountNumber: $bankAccountNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bank &&
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

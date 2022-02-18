import 'dart:convert';

class Bank {
  final String bankName;
  final String bankBranch;
  final int bankBSB;
  final String bankAccountName;
  final int bankAccountNumber;

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
    int? bankBSB,
    String? bankAccountName,
    int? bankAccountNumber,
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
      bankName: map['bankName'] ?? '',
      bankBranch: map['bankBranch'] ?? '',
      bankBSB: map['bankBSB']?.toInt() ?? 0,
      bankAccountName: map['bankAccountName'] ?? '',
      bankAccountNumber: map['bankAccountNumber']?.toInt() ?? 0,
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

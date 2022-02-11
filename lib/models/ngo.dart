import 'bank.dart';

class NGO {
  int? id;
  String? latitude;
  String? longitude;
  String? ngoURL;
  String? orgName;
  String? orgPhoto;
  DateTime? estDate;
  List<String>? fieldOfWork;
  String? address;
  String? phone;
  String? email;
  bool? isVerified;
  String? epayAccount;
  Bank? bank;
  String? swcCertificateURL;
  String? panCertificateURL;

  NGO({
    this.id,
    this.latitude,
    this.longitude,
    this.ngoURL,
    this.orgName,
    this.orgPhoto,
    this.estDate,
    this.fieldOfWork,
    this.address,
    this.phone,
    this.email,
    this.isVerified,
    this.epayAccount,
    this.bank,
    this.swcCertificateURL,
    this.panCertificateURL,
  });
}

import 'package:faker/faker.dart';

// const demo = true;
const hostingMode = HostingMode.internet;
const limit = 10;
const timeOutDuration = Duration(seconds: 10);

Future<dynamic> delay({int min = 1, int max = 4, bool random = false}) =>
    Future.delayed(Duration(
        seconds: random ? faker.randomGenerator.integer(max, min: min) : min));

//-------------For Deployment-------------------
const Map _internetHost = {
  'host': 'asasae.herokuapp.com',
  'port': '',
};

//-------------For Testing--------------------
const Map _localHost = {
  'host': '10.0.2.2',
  'port': '8000',
};
const Map _ipHost = {
  'host': '192.168.1.163',
  'port': '8000',
};
//----------------------------------------------

String getHostName() {
  late Map config;
  switch (hostingMode) {
    case HostingMode.local:
      config = _localHost;
      break;
    case HostingMode.ip:
      config = _ipHost;
      break;
    case HostingMode.internet:
      return 'https://${_internetHost['host']}/';
  }
  return 'http://${config['host']}:${config['port']}/';
}

const String verifyUserEndpoint = 'api/user/verify/';
const String loginEndpoint = 'api/login/';
const String logoutEndpoint = 'api/logout/';
const String passwordResetEndpoint = 'api/password/reset/';
const String passwordChangeEndpoint = 'api/password/change/';

const String ngosEndpoint = 'api/ngos/';
const String ngoEndpoint = 'api/ngo/';

const String peopleEndpoint = 'api/people/';
const String peopleDetailEndpoint = 'api/people/detail/';
const String peopleAddEndpoint = 'api/people/add/';
const String peopleUpdateEndpoint = 'api/people/update/';
const String peopleDeleteEndpoint = 'api/people/delete/';

const String postsEndpoint = 'api/posts/?limit=$limit';
const String postEndpoint = 'api/post/';
const String postNormalPostEndpoint = 'api/post/normal/';
const String postPollPostEndpoint = 'api/post/poll/';
const String postRequestPostEndpoint = 'api/post/request/';
const String postRelatedToEndpoint = 'api/post/relatedto/';
const String postNGOsEndpoint = 'api/post/ngos/';

enum HostingMode { local, ip, internet }

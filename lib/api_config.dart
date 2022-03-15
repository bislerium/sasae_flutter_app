//-------------For Deployment-------------------
const Map _internetHost = {
  'host': '',
  'port': '',
};

//-------------For Testing--------------------
const Map _localHost = {
  'host': '10.0.2.2',
  'port': '8000',
};
const Map _ipHost = {
  'host': '192.168.1.126',
  'port': '8000',
};
//----------------------------------------------

String getHostName({HostingMode hostingMode = HostingMode.local}) {
  late Map config;
  switch (hostingMode) {
    case HostingMode.local:
      config = _localHost;
      break;
    case HostingMode.ip:
      config = _ipHost;
      break;
    case HostingMode.internet:
      config = _internetHost;
      break;
  }
  return 'http://${config['host']}:${config['port']}/';
}

const String loginEndpoint = 'api/login/';
const String logoutEndpoint = 'api/logout/';
const String passwordResetEndpoint = 'api/password/reset/';

const String ngosEndpoint = 'api/ngos/';
const String ngoEndpoint = 'api/ngo/';

const String peopleEndpoint = 'api/people/';
const String peopleAddEndpoint = 'api/people/add/';

enum HostingMode { local, ip, internet }

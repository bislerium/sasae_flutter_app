const String _hostName = '';
const String _host = '10.0.2.2';
const String _port = '8000';

String getHostName([bool debug = true]) =>
    debug ? 'http://$_host:$_port/' : _hostName;

const String loginEndpoint = 'api/login/';
const String logoutEndpoint = 'api/logout/';
const String passwordResetEndpoint = 'api/password/reset/';

import 'package:http/http.dart' as http;

class HTTPClientService {
  static HTTPClientService? _httpcLientService;
  final http.Client _client;

  HTTPClientService._(this._client);

  void init() {}

  factory HTTPClientService.getInstace() =>
      _httpcLientService ??= HTTPClientService._(http.Client());

  http.Client getClient() => _client;

  void closeClient() => _client.close();
}

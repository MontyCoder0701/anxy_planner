import 'package:http/http.dart';

class GoogleAuthClient extends BaseClient {
  final Map<String, String> _header;
  final _client = Client();

  GoogleAuthClient({required Map<String, String> header}) : _header = header;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(_header);
    return _client.send(request);
  }
}

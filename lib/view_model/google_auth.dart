import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> header;
  final client = http.Client();

  GoogleAuthClient({required this.header});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(header);
    return client.send(request);
  }
}

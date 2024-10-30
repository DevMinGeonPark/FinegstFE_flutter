import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'kt_shop_key.dart';
import 'dart:convert';

class NetworkClient {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'KTShopKey': getKTShopKey(),
  };

  Future<http.Response> get(String endpoint) async {
    final response =
        await http.get(Uri.parse('$baseUrl$endpoint'), headers: _headers);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${baseUrl}${endpoint}');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'KTShopKey': getKTShopKey(),
      },
      body: jsonEncode(body),
    );
  }

  void updateKTShopKey() {
    _headers['KTShopKey'] = getKTShopKey();
  }

  void startUpdatingKTShopKey() {
    // 30초마다 KTShopKey 업데이트
    Future.delayed(Duration(seconds: 30), () {
      updateKTShopKey();
      startUpdatingKTShopKey();
    });
  }
}

final networkClient = NetworkClient();

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Replace this URL with your generated Mocky URL from STEP 1.
  static const String _eventsUrl =
      'https://run.mocky.io/v3/REPLACE-WITH-YOUR-MOCKY-ID';

  Future<List<Event>> fetchEvents() async {
    final uri = Uri.parse(_eventsUrl);
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded
            .map((item) => Event.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Invalid response format: expected a list of events.');
    }

    throw Exception(
      'Failed to fetch events. Status code: ${response.statusCode}',
    );
  }
}
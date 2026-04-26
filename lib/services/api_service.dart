import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  ApiService({http.Client? client, String? eventsUrl})
      : _client = client ?? http.Client(),
        _eventsUrl = eventsUrl ?? _defaultEventsUrl;

  final http.Client _client;
  final String _eventsUrl;

  static const String _defaultEventsUrl =
      'https://run.mocky.io/v3/REPLACE-WITH-YOUR-MOCKY-ID';

  Future<List<Event>> fetchEvents() async {
    if (_eventsUrl.contains('REPLACE-WITH-YOUR-MOCKY-ID')) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return _bundledEvents;
    }

    final response = await _client
        .get(Uri.parse(_eventsUrl))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to fetch events. Status code: ${response.statusCode}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException(
        'Invalid response format: expected a list of events.',
      );
    }
    return decoded
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static final List<Event> _bundledEvents = _seedJson
      .map((json) => Event.fromJson(json))
      .toList(growable: false);

  static const List<Map<String, dynamic>> _seedJson = [
    {
      'id': '1',
      'title': 'Sunset Indie Music Fest',
      'category': 'Music',
      'date': 'Sat, May 9',
      'time': '6:00 PM',
      'location': 'Riverside Amphitheatre',
      'distance': '1.2 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?auto=format&fit=crop&w=1200&q=80',
      'description':
          'An open-air evening of indie acts, food trucks, and local art. Bring a blanket, grab a drink from the pop-up bar, and watch the city skyline light up as the headliners take the stage.',
    },
    {
      'id': '2',
      'title': 'Founders Coffee & Code',
      'category': 'Tech',
      'date': 'Sun, May 10',
      'time': '9:30 AM',
      'location': 'North Loop Coworking',
      'distance': '0.6 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1200&q=80',
      'description':
          'A relaxed Sunday meetup for early-stage founders and engineers. Pair-program, swap feedback on side-projects, or just trade tips over flat whites.',
    },
    {
      'id': '3',
      'title': 'Weekend Farmers Market',
      'category': 'Lifestyle',
      'date': 'Sat, May 9',
      'time': '8:00 AM',
      'location': 'Central Square',
      'distance': '2.4 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&w=1200&q=80',
      'description':
          'Fresh produce, artisan bread, and small-batch coffee from over 40 local vendors. Live acoustic sets every hour from 9 AM.',
    },
    {
      'id': '4',
      'title': 'City Skyline 5K Run',
      'category': 'Fitness',
      'date': 'Sun, May 10',
      'time': '7:00 AM',
      'location': 'Harborfront Park',
      'distance': '3.0 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1483721310020-03333e577078?auto=format&fit=crop&w=1200&q=80',
      'description':
          'A scenic 5K loop around the harbor with chip timing, finisher medals, and a recovery brunch from local cafes.',
    },
    {
      'id': '5',
      'title': 'Open-Air Cinema: Cult Classics',
      'category': 'Film',
      'date': 'Fri, May 8',
      'time': '8:30 PM',
      'location': 'Rooftop Garden, Building 7',
      'distance': '1.8 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=1200&q=80',
      'description':
          'A double-feature of cult classics under the stars. Bean bags, popcorn, and craft sodas included with every ticket.',
    },
    {
      'id': '6',
      'title': 'Modern Watercolor Workshop',
      'category': 'Art',
      'date': 'Sun, May 10',
      'time': '2:00 PM',
      'location': 'The Studio on 5th',
      'distance': '4.1 km',
      'imageUrl':
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=1200&q=80',
      'description':
          'A beginner-friendly workshop covering color theory, brush control, and loose botanical sketches. All materials included.',
    },
  ];
}

class HttpException implements Exception {
  HttpException(this.message);
  final String message;

  @override
  String toString() => message;
}

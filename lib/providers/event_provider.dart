import 'package:flutter/foundation.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';

enum EventLoadStatus { idle, loading, success, error }

class EventProvider extends ChangeNotifier {
  EventProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  List<Event> _events = const <Event>[];
  EventLoadStatus _status = EventLoadStatus.idle;
  Object? _error;

  List<Event> get events => _events;
  EventLoadStatus get status => _status;
  Object? get error => _error;
  bool get isLoading => _status == EventLoadStatus.loading;
  bool get hasError => _status == EventLoadStatus.error;
  bool get isEmpty =>
      _status == EventLoadStatus.success && _events.isEmpty;

  Future<void> loadEvents({bool force = false}) async {
    if (_status == EventLoadStatus.loading) return;
    if (!force && _status == EventLoadStatus.success) return;

    _status = EventLoadStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchEvents();
      _events = _mergeFavorites(fetched, _events);
      _status = EventLoadStatus.success;
    } catch (err) {
      _error = err;
      _status = EventLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => loadEvents(force: true);

  void toggleFavorite(String eventId) {
    var changed = false;
    _events = _events.map((event) {
      if (event.id != eventId) return event;
      changed = true;
      return event.copyWith(isFavorite: !event.isFavorite);
    }).toList();
    if (changed) notifyListeners();
  }

  Event? eventById(String id) {
    for (final event in _events) {
      if (event.id == id) return event;
    }
    return null;
  }

  List<Event> _mergeFavorites(List<Event> incoming, List<Event> previous) {
    if (previous.isEmpty) return incoming;
    final favoriteIds = <String>{
      for (final e in previous)
        if (e.isFavorite) e.id,
    };
    if (favoriteIds.isEmpty) return incoming;
    return incoming
        .map((e) => favoriteIds.contains(e.id)
            ? e.copyWith(isFavorite: true)
            : e)
        .toList();
  }
}

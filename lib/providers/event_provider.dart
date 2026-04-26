import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';

enum EventLoadStatus { idle, loading, success, error }

class EventProvider extends ChangeNotifier {
  EventProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  static const String _favoritesKey = 'event_finder.favorite_ids';

  final ApiService _apiService;

  List<Event> _events = const <Event>[];
  EventLoadStatus _status = EventLoadStatus.idle;
  Object? _error;
  Set<String> _favoriteIds = <String>{};
  bool _favoritesLoaded = false;
  String _searchQuery = '';

  List<Event> get events => _events;
  EventLoadStatus get status => _status;
  Object? get error => _error;
  bool get isLoading => _status == EventLoadStatus.loading;
  bool get hasError => _status == EventLoadStatus.error;
  String get searchQuery => _searchQuery;

  List<Event> get filteredEvents {
    if (_searchQuery.trim().isEmpty) return _events;
    final query = _searchQuery.trim().toLowerCase();
    return _events.where((event) {
      return event.title.toLowerCase().contains(query) ||
          event.category.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  bool get hasNoResults =>
      _status == EventLoadStatus.success &&
      _events.isNotEmpty &&
      filteredEvents.isEmpty;

  bool get isEmpty =>
      _status == EventLoadStatus.success && _events.isEmpty;

  Future<void> loadEvents({bool force = false}) async {
    if (_status == EventLoadStatus.loading) return;
    if (!force && _status == EventLoadStatus.success) return;

    if (!_favoritesLoaded) {
      await _loadFavoritesFromDisk();
    }

    _status = EventLoadStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchEvents();
      _events = _applyFavorites(fetched);
      _status = EventLoadStatus.success;
    } catch (err) {
      _error = err;
      _status = EventLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => loadEvents(force: true);

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavorite(String eventId) async {
    var changed = false;
    _events = _events.map((event) {
      if (event.id != eventId) return event;
      changed = true;
      return event.copyWith(isFavorite: !event.isFavorite);
    }).toList();
    if (!changed) return;

    if (_favoriteIds.contains(eventId)) {
      _favoriteIds.remove(eventId);
    } else {
      _favoriteIds.add(eventId);
    }
    notifyListeners();
    await _persistFavorites();
  }

  Event? eventById(String id) {
    for (final event in _events) {
      if (event.id == id) return event;
    }
    return null;
  }

  List<Event> _applyFavorites(List<Event> incoming) {
    if (_favoriteIds.isEmpty) return incoming;
    return incoming
        .map((e) => _favoriteIds.contains(e.id)
            ? e.copyWith(isFavorite: true)
            : e)
        .toList();
  }

  Future<void> _loadFavoritesFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_favoritesKey) ?? const <String>[];
      _favoriteIds = stored.toSet();
    } catch (_) {
      _favoriteIds = <String>{};
    }
    _favoritesLoaded = true;
  }

  Future<void> _persistFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    } catch (_) {
      // Persistence failures are non-fatal — in-memory state remains correct.
    }
  }
}

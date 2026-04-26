import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Event>> _eventsFuture;
  List<Event> _events = <Event>[];

  @override
  void initState() {
    super.initState();
    _eventsFuture = _loadEvents();
  }

  Future<List<Event>> _loadEvents() async {
    final fetched = await _apiService.fetchEvents();
    _events = fetched;
    return _events;
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _eventsFuture = _loadEvents();
    });
    await _eventsFuture;
  }

  void _toggleFavorite(Event event) {
    setState(() {
      _events = _events
          .map(
            (item) => item.id == event.id
                ? item.copyWith(isFavorite: !item.isFavorite)
                : item,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Finder'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSearchBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 6),
            child: Text(
              'Nearby Events',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2F2A42),
                  ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _events.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError && _events.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Something went wrong:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final events = _events;

                if (events.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshEvents,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 180),
                        Center(child: Text('No events found right now.')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshEvents,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        event: event,
                        onFavoriteTap: () => _toggleFavorite(event),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              transitionDuration:
                                  const Duration(milliseconds: 420),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder: (_, animation, __) {
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                );
                                return FadeTransition(
                                  opacity: curved,
                                  child: EventDetailScreen(event: event),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

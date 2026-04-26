import 'package:flutter/material.dart';

import '../main.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/search_bar.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = EventProviderScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover Events',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
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
            child: RefreshIndicator(
              onRefresh: provider.refresh,
              child: _EventListBody(provider: provider),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventListBody extends StatelessWidget {
  const _EventListBody({required this.provider});

  final EventProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading && provider.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError && provider.events.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 140),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  size: 48,
                  color: Color(0xFF8A8A99),
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not load events',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${provider.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF8A8A99)),
                ),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: provider.refresh,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (provider.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 180),
          Center(child: Text('No events found right now.')),
        ],
      );
    }

    final events = provider.events;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          onFavoriteTap: () => provider.toggleFavorite(event.id),
          onTap: () => _openDetail(context, event),
        );
      },
    );
  }

  void _openDetail(BuildContext context, Event event) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, __) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: EventDetailScreen(eventId: event.id),
          );
        },
      ),
    );
  }
}

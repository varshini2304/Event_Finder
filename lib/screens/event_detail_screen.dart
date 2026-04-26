import 'package:flutter/material.dart';

import '../main.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final provider = EventProviderScope.of(context);
    final event = provider.eventById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Event no longer available.')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.black38,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => provider.toggleFavorite(event.id),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      event.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey<bool>(event.isFavorite),
                      color: event.isFavorite
                          ? const Color(0xFFFF4D6D)
                          : Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailHero(event: event),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _CategoryChip(label: event.category),
                  const SizedBox(height: 18),
                  _MetaRow(
                    icon: Icons.event_outlined,
                    label: '${event.date}  -  ${event.time}',
                  ),
                  const SizedBox(height: 10),
                  _MetaRow(
                    icon: Icons.location_on_outlined,
                    label: '${event.location}  (${event.distance})',
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'About this event',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _GetTicketsButton(),
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'event-image-${event.id}',
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, _) {
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 350),
                  child: child,
                );
              },
              errorBuilder: (context, _, __) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 40),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66000000), Color(0x00000000)],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE85D75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B6B7B)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _GetTicketsButton extends StatelessWidget {
  const _GetTicketsButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
          gradient: const LinearGradient(
            colors: [Color(0xFF5C4DFF), Color(0xFFE85D75)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket booking coming soon.')),
            );
          },
          child: const Text(
            'Get Tickets',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

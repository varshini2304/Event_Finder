import 'package:flutter/material.dart';

import 'providers/event_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EventFinderApp());
}

class EventFinderApp extends StatefulWidget {
  const EventFinderApp({super.key});

  @override
  State<EventFinderApp> createState() => _EventFinderAppState();
}

class _EventFinderAppState extends State<EventFinderApp> {
  late final EventProvider _eventProvider;

  @override
  void initState() {
    super.initState();
    _eventProvider = EventProvider()..loadEvents();
  }

  @override
  void dispose() {
    _eventProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventProviderScope(
      provider: _eventProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Finder',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: const Color(0xFF3F51B5),
            secondary: const Color(0xFFE85D75),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F5F5),
            foregroundColor: Color(0xFF1E1A2E),
            centerTitle: false,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontSize: 16, height: 1.45),
            bodyMedium: TextStyle(fontSize: 14),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class EventProviderScope extends InheritedNotifier<EventProvider> {
  const EventProviderScope({
    super.key,
    required EventProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static EventProvider of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<EventProviderScope>();
    assert(scope != null, 'EventProviderScope not found in widget tree.');
    return scope!.notifier!;
  }
}

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Search events, places, vibes...',
          hintStyle: const TextStyle(color: Color(0xFF8A8A99)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B6B7B)),
          filled: true,
          fillColor: const Color(0xFFF0F0F3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

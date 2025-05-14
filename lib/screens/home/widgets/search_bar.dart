import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;

  const HomeSearchBar({
    Key? key,
    required this.controller,
    required this.onSearchChanged,
    required this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
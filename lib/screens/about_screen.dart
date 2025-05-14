import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Todo App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Todo App is a powerful task management application designed to help you organize your daily tasks efficiently. With a clean and intuitive interface, you can easily add, edit, and track your tasks.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(context, 'Task Management', 'Add, edit, and delete tasks with ease'),
            _buildFeatureItem(context, 'Search', 'Quickly find tasks with the search feature'),
            _buildFeatureItem(context, 'Persistence', 'Tasks are saved locally using SQLite'),
            _buildFeatureItem(context, 'Dark Mode', 'Switch between light and dark themes'),
            _buildFeatureItem(context, 'Custom Progress Bar', 'Visualize progress with custom animations'),
            const SizedBox(height: 24),
            const Text(
              'Contact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(context, Icons.email, 'Email', 'support@todoapp.com'),
            _buildContactItem(context, Icons.language, 'Website', 'www.todoapp.com'),
            _buildContactItem(context, Icons.phone, 'Phone', '+1 (123) 456-7890'),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© 2025 Todo App. All rights reserved.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
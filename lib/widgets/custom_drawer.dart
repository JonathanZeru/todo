import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/article/article_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';
import '../utils/drawer_utils.dart'; // Contains `navigateTo` and `showLogoutConfirmationDialog`

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in animation
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: Drawer(
          child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Todo App User'),
                accountEmail: const Text('user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => navigateTo(context, const HomeScreen()),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Article'),
                onTap: () => navigateTo(context, const ArticleScreen()),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => navigateTo(context, const SettingsScreen()),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () => navigateTo(context, const AboutScreen()),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
     ) );
  }
}

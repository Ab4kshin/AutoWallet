// Заглушка для main_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/screens/home_screen.dart';
import 'package:auto_wallet2/screens/expenses_screen.dart';
import 'package:auto_wallet2/screens/calendar_screen.dart';
import 'package:auto_wallet2/screens/profile_screen.dart';
import 'package:auto_wallet2/widgets/app_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ExpensesScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
} 
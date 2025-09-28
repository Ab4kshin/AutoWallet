import 'package:flutter/material.dart';
import 'package:auto_wallet2/l10n/l10n.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.main,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.attach_money),
            label: context.l10n.expenses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: context.l10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
} 
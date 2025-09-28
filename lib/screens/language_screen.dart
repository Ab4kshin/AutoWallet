// Заглушка для language_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/user_provider.dart';
import 'package:auto_wallet2/screens/profile_creation_screen.dart';
import 'package:auto_wallet2/screens/main_screen.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_logo.dart';
import 'package:auto_wallet2/widgets/app_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'ru'; // Default to Russian
  String _selectedCurrency = '₽'; // Default to Ruble
  
  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }
  
  Future<void> _initializeSettings() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      _selectedLanguage = appProvider.language;
      _selectedCurrency = appProvider.currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 120),
              const SizedBox(height: AppTheme.paddingLarge),
              Text(
                'AutoWallet',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.paddingLarge * 2),
              
              // Language selection
              _buildSectionTitle(context, 'Выбрать язык'),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildLanguageSelection(),
              
              const SizedBox(height: AppTheme.paddingLarge),
              
              // Currency selection
              _buildSectionTitle(context, 'Выбрать валюту'),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildCurrencySelection(),
              
              const Spacer(),
              
              // Next button
              AppButton(
                text: 'Далее',
                onPressed: () {
                  _saveSettings(userProvider.isUserRegistered);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
  
  Widget _buildLanguageSelection() {
    return Row(
      children: [
        _buildLanguageOption('ru', 'Русский'),
        const SizedBox(width: AppTheme.paddingMedium),
        _buildLanguageOption('en', 'English'),
      ],
    );
  }
  
  Widget _buildLanguageOption(String code, String name) {
    final isSelected = _selectedLanguage == code;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrencySelection() {
    return Row(
      children: [
        _buildCurrencyOption('₽', 'RUB'),
        const SizedBox(width: AppTheme.paddingMedium),
        _buildCurrencyOption('\$', 'USD'),
        const SizedBox(width: AppTheme.paddingMedium),
        _buildCurrencyOption('€', 'EUR'),
      ],
    );
  }
  
  Widget _buildCurrencyOption(String symbol, String code) {
    final isSelected = _selectedCurrency == symbol;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCurrency = symbol;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Text(
            symbol,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Future<void> _saveSettings(bool isUserRegistered) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Save language and currency settings
    await appProvider.setLanguage(_selectedLanguage);
    await appProvider.setCurrency(_selectedCurrency);
    if (!mounted) return;
    // Navigate to appropriate screen
    if (isUserRegistered) {
      // Go to main screen if user is registered
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // Go to profile creation screen if user is not registered
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileCreationScreen()),
      );
    }
  }
} 
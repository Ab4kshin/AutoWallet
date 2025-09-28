import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  Locale get locale => const Locale('ru');
  String get currency => '₽';
  String get language => 'ru';
  String formatCurrency(double amount) => '$amount $currency';

  Future<void> setLanguage(String languageCode) async {}
  Future<void> setCurrency(String currencySymbol) async {}
}


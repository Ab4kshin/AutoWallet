// Заглушка для l10n.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

class L10n {
  static final supportedLocales = [
    const Locale('en'),
    const Locale('ru'),
  ];

  static const supportedLanguages = {
    'en': 'English',
    'ru': 'Русский',
  };

  static const currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'RUB': '₽',
    'GBP': '£',
  };
} 
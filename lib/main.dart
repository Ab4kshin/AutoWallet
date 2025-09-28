import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/user_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/providers/expense_provider.dart';
import 'package:auto_wallet2/providers/event_provider.dart';
import 'package:auto_wallet2/screens/language_screen.dart';
import 'package:auto_wallet2/screens/main_screen.dart';
import 'package:auto_wallet2/services/hive_service.dart';
import 'package:auto_wallet2/services/notification_service.dart';
import 'package:auto_wallet2/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await HiveService.init();
  await NotificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return MaterialApp(
                title: 'Auto Wallet',
                theme: AppTheme.getTheme(),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: L10n.supportedLocales,
                locale: appProvider.locale,
                home: userProvider.isUserRegistered
                    ? const MainScreen()
                    : const LanguageScreen(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}


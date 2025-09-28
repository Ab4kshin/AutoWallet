// Заглушка для user_provider.dart

import 'package:flutter/material.dart';
import 'package:auto_wallet2/models/user_model.dart';
import 'package:auto_wallet2/services/hive_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  
  UserProvider() {
    _loadUser();
  }
  
  User? get currentUser => _currentUser;
  
  bool get isUserRegistered => _currentUser != null;
  
  void _loadUser() {
    _currentUser = HiveService.getCurrentUser();
    notifyListeners();
  }
  
  Future<void> createUser({
    required String name,
    String? photoPath,
    required String language,
    required String currency,
  }) async {
    final user = User(
      name: name,
      photoPath: photoPath,
      language: language,
      currency: currency,
    );
    
    await HiveService.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }
  
  Future<void> updateUser({
    String? name,
    String? photoPath,
    String? language,
    String? currency,
  }) async {
    if (_currentUser == null) return;
    
    if (name != null) _currentUser!.name = name;
    if (photoPath != null) _currentUser!.photoPath = photoPath;
    if (language != null) _currentUser!.language = language;
    if (currency != null) _currentUser!.currency = currency;
    
    await HiveService.saveUser(_currentUser!);
    notifyListeners();
  }
} 
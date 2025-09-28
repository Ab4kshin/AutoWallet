import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/user_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_logo.dart';
import 'package:auto_wallet2/widgets/photo_picker.dart';
import 'package:auto_wallet2/widgets/app_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isEditing = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    final user = userProvider.currentUser;
    final selectedVehicle = vehicleProvider.selectedVehicle;
    
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Set the name controller value when not editing
    if (!_isEditing) {
      _nameController.text = user.name;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(size: 40),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile(userProvider);
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          children: [
            // User photo
            Center(
              child: PhotoPicker(
                currentPhotoPath: user.photoPath,
                onPhotoSelected: (path) {
                  userProvider.updateUser(photoPath: path);
                },
                buttonText: context.l10n.changePhoto,
                size: 150,
              ),
            ),
            const SizedBox(height: AppTheme.paddingLarge),
            
            // User name
            _isEditing
                ? TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя пользователя',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                    ),
                  )
                : Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Имя пользователя'),
                      subtitle: Text(
                        user.name,
                        style: AppTheme.subtitleStyle,
                      ),
                    ),
                  ),
            const SizedBox(height: AppTheme.paddingMedium),
            
            // Current vehicle
            if (selectedVehicle != null)
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text(context.l10n.vehicleName),
                      subtitle: Text(
                        selectedVehicle.fullName,
                        style: AppTheme.subtitleStyle,
                      ),
                    ),
                    if (selectedVehicle.mileage != null)
                      ListTile(
                        leading: const Icon(Icons.speed),
                        title: Text(context.l10n.mileage),
                        subtitle: Text(
                          '${selectedVehicle.mileage} км',
                          style: AppTheme.subtitleStyle,
                        ),
                      ),
                    if (selectedVehicle.licensePlate != null)
                      ListTile(
                        leading: const Icon(Icons.confirmation_number),
                        title: Text(context.l10n.licensePlate),
                        subtitle: Text(
                          selectedVehicle.licensePlate!,
                          style: AppTheme.subtitleStyle,
                        ),
                      ),
                  ],
                ),
              ),
            
            const SizedBox(height: AppTheme.paddingLarge),
            
            // App settings card
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(context.l10n.language),
                    subtitle: Text(
                      _getLanguageName(appProvider.language),
                      style: AppTheme.subtitleStyle,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLanguageDialog(context, appProvider),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: Text(context.l10n.currency),
                    subtitle: Text(
                      appProvider.currency,
                      style: AppTheme.subtitleStyle,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showCurrencyDialog(context, appProvider),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.paddingLarge),
            
            // Vehicle selection
            if (vehicleProvider.vehicles.length > 1)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      child: Text(
                        'Выбрать транспортное средство',
                        style: AppTheme.subtitleStyle,
                      ),
                    ),
                    const Divider(height: 1),
                    ...vehicleProvider.vehicles.map((vehicle) {
                      final isSelected = selectedVehicle?.key == vehicle.key;
                      return ListTile(
                        leading: isSelected
                            ? const Icon(Icons.check_circle, color: AppTheme.successColor)
                            : const Icon(Icons.directions_car),
                        title: Text(vehicle.fullName),
                        subtitle: vehicle.licensePlate != null
                            ? Text(vehicle.licensePlate!)
                            : null,
                        selected: isSelected,
                        onTap: () {
                          vehicleProvider.selectVehicle(vehicle);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
  
  void _showLanguageDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              leading: Radio<String>(
                value: 'ru',
                groupValue: appProvider.language,
                onChanged: (value) {
                  appProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: appProvider.language,
                onChanged: (value) {
                  appProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );
  }
  
  void _showCurrencyDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.currency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Рубль (₽)'),
              leading: Radio<String>(
                value: '₽',
                groupValue: appProvider.currency,
                onChanged: (value) {
                  appProvider.setCurrency(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Dollar (\$)'),
              leading: Radio<String>(
                value: '\$',
                groupValue: appProvider.currency,
                onChanged: (value) {
                  appProvider.setCurrency(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Euro (€)'),
              leading: Radio<String>(
                value: '€',
                groupValue: appProvider.currency,
                onChanged: (value) {
                  appProvider.setCurrency(value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );
  }
  
  void _saveProfile(UserProvider userProvider) {
    userProvider.updateUser(
      name: _nameController.text.trim(),
    );
    
    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранен')),
    );
  }
}


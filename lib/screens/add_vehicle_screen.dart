import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_button.dart';
import 'package:auto_wallet2/widgets/photo_picker.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _mileageController = TextEditingController();
  
  String? _photoPath;
  String _selectedFuelType = 'gasoline';
  bool _isLoading = false;
  
  final List<String> _fuelTypes = [
    'gasoline',
    'diesel',
    'electric',
    'hybrid',
    'other',
  ];
  
  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.addVehicle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle photo picker
                Center(
                  child: PhotoPicker(
                    currentPhotoPath: _photoPath,
                    onPhotoSelected: (path) {
                      setState(() {
                        _photoPath = path;
                      });
                    },
                    buttonText: context.l10n.selectPhoto,
                    icon: Icons.directions_car,
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                
                // Vehicle make
                TextFormField(
                  controller: _makeController,
                  decoration: InputDecoration(
                    labelText: context.l10n.make,
                    prefixIcon: const Icon(Icons.car_rental),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите марку автомобиля';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Vehicle model
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: context.l10n.model,
                    prefixIcon: const Icon(Icons.model_training),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите модель автомобиля';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Vehicle year
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: context.l10n.year,
                    prefixIcon: const Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final year = int.tryParse(value);
                      if (year == null || year < 1900 || year > DateTime.now().year) {
                        return 'Неверный год';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Vehicle license plate
                TextFormField(
                  controller: _licensePlateController,
                  decoration: InputDecoration(
                    labelText: context.l10n.licensePlate,
                    prefixIcon: const Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Vehicle mileage
                TextFormField(
                  controller: _mileageController,
                  decoration: InputDecoration(
                    labelText: context.l10n.mileage,
                    prefixIcon: const Icon(Icons.speed),
                    suffixText: 'км',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final mileage = int.tryParse(value);
                      if (mileage == null || mileage < 0) {
                        return 'Неверный пробег';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Fuel type dropdown
                DropdownButtonFormField<String>(
                  value: _selectedFuelType,
                  decoration: InputDecoration(
                    labelText: context.l10n.fuelType,
                    prefixIcon: const Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  items: _fuelTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(_getFuelTypeName(context, type)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFuelType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                
                // Save button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: context.l10n.save,
                        onPressed: _saveVehicle,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getFuelTypeName(BuildContext context, String type) {
    switch (type) {
      case 'gasoline':
        return context.l10n.gasoline;
      case 'diesel':
        return context.l10n.diesel;
      case 'electric':
        return context.l10n.electric;
      case 'hybrid':
        return context.l10n.hybrid;
      case 'other':
      default:
        return context.l10n.other;
    }
  }
  
  Future<void> _saveVehicle() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
        
        final vehicle = Vehicle(
          make: _makeController.text.trim(),
          model: _modelController.text.trim(),
          year: _yearController.text.isNotEmpty ? int.parse(_yearController.text) : null,
          licensePlate: _licensePlateController.text.trim().isNotEmpty ? _licensePlateController.text.trim() : null,
          mileage: _mileageController.text.isNotEmpty ? int.parse(_mileageController.text) : null,
          photoPath: _photoPath,
          fuelType: _selectedFuelType,
        );
        
        await vehicleProvider.addVehicle(vehicle);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${vehicle.make} ${vehicle.model} добавлен')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
} 
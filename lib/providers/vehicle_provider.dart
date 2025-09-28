// Заглушка для vehicle_provider.dart

import 'package:flutter/material.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/services/hive_service.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  
  VehicleProvider() {
    _loadVehicles();
  }
  
  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get hasVehicles => _vehicles.isNotEmpty;
  
  void _loadVehicles() {
    _vehicles = HiveService.getAllVehicles();
    
    if (_vehicles.isNotEmpty && _selectedVehicle == null) {
      _selectedVehicle = _vehicles.first;
    }
    
    notifyListeners();
  }
  
  Future<void> addVehicle(Vehicle vehicle) async {
    await HiveService.saveVehicle(vehicle);
    _loadVehicles();
    
    // If this is the first vehicle, select it automatically
    if (_vehicles.length == 1) {
      _selectedVehicle = vehicle;
    }
    
    notifyListeners();
  }
  
  Future<void> updateVehicle(Vehicle vehicle) async {
    await HiveService.updateVehicle(vehicle);
    
    // Update the selected vehicle if it was the one being updated
    if (_selectedVehicle != null && _selectedVehicle!.key == vehicle.key) {
      _selectedVehicle = vehicle;
    }
    
    _loadVehicles();
    notifyListeners();
  }
  
  Future<void> deleteVehicle(Vehicle vehicle) async {
    await HiveService.deleteVehicle(vehicle);
    
    // If we deleted the selected vehicle, select another one or set to null
    if (_selectedVehicle != null && _selectedVehicle!.key == vehicle.key) {
      _loadVehicles();
      _selectedVehicle = _vehicles.isNotEmpty ? _vehicles.first : null;
    } else {
      _loadVehicles();
    }
    
    notifyListeners();
  }
  
  void selectVehicle(Vehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }
  
  Vehicle? getVehicleByKey(dynamic key) {
    try {
      return _vehicles.firstWhere((vehicle) => vehicle.key == key);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> updateMileage(Vehicle vehicle, int newMileage) async {
    vehicle.mileage = newMileage;
    await HiveService.updateVehicle(vehicle);
    if (_selectedVehicle != null && _selectedVehicle!.key == vehicle.key) {
      _selectedVehicle = vehicle;
    }
    _loadVehicles();
    notifyListeners();
  }
} 
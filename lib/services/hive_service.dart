// Заглушка для hive_service.dart

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_wallet2/models/user_model.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/models/expense_model.dart';

class HiveService {
  static const String vehicleBoxName = 'vehicles';
  static const String userBoxName = 'user';
  static const String expenseBoxName = 'expenses';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(VehicleAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    await Hive.openBox<Vehicle>(vehicleBoxName);
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox<Expense>(expenseBoxName);
  }

  // --- User ---
  static Box<User> getUserBox() => Hive.box<User>(userBoxName);

  static User? getCurrentUser() {
    final box = getUserBox();
    return box.isNotEmpty ? box.getAt(0) : null;
  }

  static Future<void> saveUser(User user) async {
    final box = getUserBox();
    if (box.isEmpty) {
      await box.add(user);
    } else {
      await box.putAt(0, user);
    }
  }

  // --- Vehicles ---
  static Box<Vehicle> getVehicleBox() => Hive.box<Vehicle>(vehicleBoxName);

  static List<Vehicle> getAllVehicles() {
    return getVehicleBox().values.toList();
  }

  static Future<void> saveVehicle(Vehicle vehicle) async {
    await getVehicleBox().add(vehicle);
  }

  static Future<void> updateVehicle(Vehicle vehicle) async {
    await vehicle.save();
  }

  static Future<void> deleteVehicle(Vehicle vehicle) async {
    await vehicle.delete();
  }

  // --- Expenses ---
  static Box<Expense> getExpenseBox() => Hive.box<Expense>(expenseBoxName);

  static List<Expense> getAllExpenses() {
    return getExpenseBox().values.toList();
  }

  static List<Expense> getExpensesByVehicle(String vehicleId) {
    return getAllExpenses().where((e) => e.vehicleId == vehicleId).toList();
  }

  static Future<void> saveExpense(Expense expense) async {
    await getExpenseBox().add(expense);
  }

  static Future<void> updateExpense(Expense expense) async {
    await expense.save();
  }

  static Future<void> deleteExpense(Expense expense) async {
    await expense.delete();
  }
}


// Заглушка для expense_provider.dart

import 'package:flutter/material.dart';
import 'package:auto_wallet2/models/expense_model.dart';
import 'package:auto_wallet2/services/hive_service.dart';

class ExpenseProvider extends ChangeNotifier {
  Future<void> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required String vehicleId,
    required String category,
    String? notes,
  }) async {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: date,
      vehicleId: vehicleId,
      category: category,
      notes: notes,
    );
    await HiveService.saveExpense(expense);
    notifyListeners();
  }

  Future<List<Expense>> getExpensesForDay(DateTime date, String vehicleId) async {
    final allExpenses = await HiveService.getAllExpenses();
    return allExpenses
        .where((e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day &&
            e.vehicleId == vehicleId)
        .toList();
  }

  Future<List<Expense>> getExpensesForWeek(DateTime date, String vehicleId) async {
    final allExpenses = await HiveService.getAllExpenses();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return allExpenses
        .where((e) =>
            e.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            e.date.isBefore(endOfWeek.add(const Duration(days: 1))) &&
            e.vehicleId == vehicleId)
        .toList();
  }

  Future<List<Expense>> getExpensesForMonth(DateTime date, String vehicleId) async {
    final allExpenses = await HiveService.getAllExpenses();
    return allExpenses
        .where((e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.vehicleId == vehicleId)
        .toList();
  }

  Future<List<Expense>> getExpensesForYear(int year, String vehicleId) async {
    final allExpenses = await HiveService.getAllExpenses();
    return allExpenses
        .where((e) => e.date.year == year && e.vehicleId == vehicleId)
        .toList();
  }

  Future<List<Expense>> getExpensesByVehicle(String vehicleId) async {
    final allExpenses = await HiveService.getAllExpenses();
    return allExpenses.where((e) => e.vehicleId == vehicleId).toList();
  }

  double getTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<String, double> getExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  Future<void> updateExpense(Expense expense) async {
    await HiveService.updateExpense(expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String expenseId) async {
    final allExpenses = await HiveService.getAllExpenses();
    final expense = allExpenses.firstWhere((e) => e.id == expenseId);
    await HiveService.deleteExpense(expense);
    notifyListeners();
  }
}


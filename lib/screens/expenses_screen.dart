import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/models/expense_model.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/expense_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/screens/add_expense_screen.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_logo.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _selectedPeriod = 'month';
  final DateTime _selectedDate = DateTime.now();
  
  Future<List<Expense>> _getFilteredExpenses(ExpenseProvider expenseProvider, Vehicle selectedVehicle) {
    switch (_selectedPeriod) {
      case 'today':
        return expenseProvider.getExpensesForDay(_selectedDate, selectedVehicle.key.toString());
      case 'week':
        return expenseProvider.getExpensesForWeek(_selectedDate, selectedVehicle.key.toString());
      case 'month':
        return expenseProvider.getExpensesForMonth(_selectedDate, selectedVehicle.key.toString());
      case 'year':
        return expenseProvider.getExpensesForYear(_selectedDate.year, selectedVehicle.key.toString());
      case 'all':
      default:
        return expenseProvider.getExpensesByVehicle(selectedVehicle.key.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    final selectedVehicle = vehicleProvider.selectedVehicle;
    
    if (selectedVehicle == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.expenses),
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppLogo(size: 40),
          ),
        ),
        body: const Center(
          child: Text('Нет доступных транспортных средств'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.expenses),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(size: 40),
        ),
      ),
      body: FutureBuilder<List<Expense>>(
        future: _getFilteredExpenses(expenseProvider, selectedVehicle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: \\${snapshot.error}'));
          }
          final filteredExpenses = snapshot.data ?? [];
          filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
          final totalExpenses = expenseProvider.getTotalExpenses(filteredExpenses);
          return Column(
            children: [
              // Period selector
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingSmall),
                    child: Column(
                      children: [
                        // Period tabs
                        Row(
                          children: [
                            _buildPeriodTab('today', context.l10n.today),
                            _buildPeriodTab('week', context.l10n.week),
                            _buildPeriodTab('month', context.l10n.month),
                            _buildPeriodTab('year', context.l10n.year),
                            _buildPeriodTab('all', context.l10n.all),
                          ],
                        ),
                        const SizedBox(height: AppTheme.paddingMedium),
                        // Total expenses for period
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingMedium,
                            vertical: AppTheme.paddingSmall,
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.l10n.totalExpenses,
                                style: AppTheme.subtitleStyle,
                              ),
                              const Spacer(),
                              Text(
                                appProvider.formatCurrency(totalExpenses),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Expenses list
              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(
                        child: Text('Нет расходов за выбранный период'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.paddingSmall),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return _buildExpenseItem(expense, appProvider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildPeriodTab(String period, String label) {
    final isSelected = _selectedPeriod == period;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildExpenseItem(Expense expense, AppProvider appProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      child: ListTile(
        leading: _getCategoryIcon(expense.category),
        title: Text(expense.title),
        subtitle: Text(DateFormat('dd.MM.yyyy').format(expense.date)),
        trailing: Text(
          appProvider.formatCurrency(expense.amount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Navigate to expense details
        },
      ),
    );
  }
  
  Widget _getCategoryIcon(String category) {
    IconData iconData;
    Color color;
    
    switch (category) {
      case 'fuel':
        iconData = Icons.local_gas_station;
        color = Colors.green;
        break;
      case 'service':
        iconData = Icons.build;
        color = Colors.orange;
        break;
      case 'repair':
        iconData = Icons.handyman;
        color = Colors.red;
        break;
      case 'maintenance':
        iconData = Icons.settings;
        color = Colors.blue;
        break;
      case 'insurance':
        iconData = Icons.security;
        color = Colors.purple;
        break;
      case 'tax':
        iconData = Icons.account_balance;
        color = Colors.brown;
        break;
      default:
        iconData = Icons.attach_money;
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.2).toInt()),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Icon(
        iconData,
        color: color,
      ),
    );
  }
  
  void _showAddExpenseScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddExpenseScreen(),
      ),
    );
  }
}


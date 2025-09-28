import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/models/expense_model.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/expense_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/screens/add_expense_screen.dart';
import 'package:auto_wallet2/screens/add_vehicle_screen.dart';
import 'package:auto_wallet2/screens/edit_vehicle_screen.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_logo.dart';
import 'package:auto_wallet2/widgets/app_button.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(size: 40),
        ),
      ),
      body: vehicleProvider.hasVehicles
          ? _buildHomeContent(context, vehicleProvider, expenseProvider, appProvider)
          : _buildNoVehiclesContent(context),
      floatingActionButton: vehicleProvider.hasVehicles
          ? FloatingActionButton(
              onPressed: () => _showAddExpenseScreen(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
  
  Widget _buildHomeContent(
    BuildContext context,
    VehicleProvider vehicleProvider,
    ExpenseProvider expenseProvider,
    AppProvider appProvider,
  ) {
    final selectedVehicle = vehicleProvider.selectedVehicle;
    
    if (selectedVehicle == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return FutureBuilder<List<Expense>>(
      future: expenseProvider.getExpensesByVehicle(selectedVehicle.key.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: \\${snapshot.error}'));
        }
        final expenses = snapshot.data ?? [];
        final totalExpenses = expenseProvider.getTotalExpenses(expenses);
        return Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle info card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                elevation: AppTheme.elevationMedium,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            selectedVehicle.fullName,
                            style: AppTheme.titleStyle,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditVehicleScreen(vehicle: selectedVehicle),
                                ),
                              );
                            },
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      if (selectedVehicle.licensePlate != null)
                        Text(
                          selectedVehicle.licensePlate!,
                          style: AppTheme.subtitleStyle,
                        ),
                      const SizedBox(height: AppTheme.paddingSmall),
                      if (selectedVehicle.mileage != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${context.l10n.mileage}: ${selectedVehicle.mileage} км',
                              style: AppTheme.bodyStyle,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              tooltip: context.l10n.edit,
                              onPressed: () => _showEditMileageDialog(context, selectedVehicle),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              // Total expenses card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                elevation: AppTheme.elevationMedium,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.totalExpenses,
                        style: AppTheme.titleStyle,
                      ),
                      const SizedBox(height: AppTheme.paddingSmall),
                      Text(
                        appProvider.formatCurrency(totalExpenses),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              // Recent expenses list
              Text(
                'Последние расходы',
                style: AppTheme.subtitleStyle,
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              Expanded(
                child: expenses.isEmpty
                    ? Center(
                        child: Text(
                          'Нет расходов',
                          style: AppTheme.bodyStyle,
                        ),
                      )
                    : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return _buildExpenseItem(context, expense, appProvider);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildExpenseItem(
    BuildContext context,
    Expense expense,
    AppProvider appProvider,
  ) {
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
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Icon(
        iconData,
        color: color,
      ),
    );
  }
  
  Widget _buildNoVehiclesContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 100),
            const SizedBox(height: AppTheme.paddingLarge),
            Text(
              'Добавьте транспортное средство',
              style: AppTheme.titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Text(
              'Для начала работы с приложением необходимо добавить транспортное средство',
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.paddingLarge),
            AppButton(
              text: context.l10n.addVehicle,
              onPressed: () => _showAddVehicleScreen(context),
              icon: Icons.directions_car,
            ),
          ],
        ),
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
  
  void _showAddVehicleScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddVehicleScreen(),
      ),
    );
  }

  void _showEditMileageDialog(BuildContext context, vehicle) {
    final controller = TextEditingController(text: vehicle.mileage?.toString() ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить пробег'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Пробег (км)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () {
              final newMileage = int.tryParse(controller.text);
              if (newMileage != null && newMileage >= 0) {
                Provider.of<VehicleProvider>(context, listen: false)
                    .updateMileage(vehicle, newMileage);
                Navigator.pop(context);
              }
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }
}


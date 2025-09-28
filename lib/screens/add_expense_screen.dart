import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/expense_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_button.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'fuel';
  bool _isLoading = false;
  
  final List<String> _categories = [
    'fuel',
    'service',
    'repair',
    'maintenance',
    'insurance',
    'tax',
    'other',
  ];
  
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    // Check if there's a selected vehicle
    if (!vehicleProvider.hasVehicles) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.addExpense),
        ),
        body: Center(
          child: Text('Нет доступных транспортных средств'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.addExpense),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selected vehicle info
                if (vehicleProvider.selectedVehicle != null)
                  Card(
                    margin: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_car, size: 36),
                          const SizedBox(width: AppTheme.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicleProvider.selectedVehicle!.fullName,
                                  style: AppTheme.subtitleStyle,
                                ),
                                if (vehicleProvider.selectedVehicle!.licensePlate != null)
                                  Text(
                                    vehicleProvider.selectedVehicle!.licensePlate!,
                                    style: AppTheme.captionStyle,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Expense title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите название';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Expense amount
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: context.l10n.amount,
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: appProvider.currency,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите сумму';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Неверная сумма';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Expense date
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.l10n.date,
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                    ),
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Expense category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: context.l10n.category,
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(_getCategoryName(context, category)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Примечания',
                    prefixIcon: const Icon(Icons.note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                
                // Save button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: context.l10n.add,
                        onPressed: _saveExpense,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getCategoryName(BuildContext context, String category) {
    switch (category) {
      case 'fuel':
        return context.l10n.fuel;
      case 'service':
        return context.l10n.service;
      case 'maintenance':
        return context.l10n.maintenance;
      case 'repair':
        return context.l10n.repair;
      case 'insurance':
        return context.l10n.insurance;
      case 'tax':
        return context.l10n.tax;
      case 'other':
      default:
        return context.l10n.other;
    }
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _saveExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
        final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
        
        if (vehicleProvider.selectedVehicle == null) {
          throw Exception('No vehicle selected');
        }
        
        await expenseProvider.addExpense(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text),
          date: _selectedDate,
          vehicleId: vehicleProvider.selectedVehicle!.key.toString(),
          category: _selectedCategory,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Расход добавлен')),
        );
        Navigator.of(context).pop();
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
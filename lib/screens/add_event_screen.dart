import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/providers/event_provider.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  
  const AddEventScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _notificationEnabled = true;
  String? _selectedVehicleId;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedTime = TimeOfDay.now();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicles = vehicleProvider.vehicles;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.newEvent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.eventName,
                    prefixIcon: const Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите название события';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Event date
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
                
                // Event time
                InkWell(
                  onTap: _selectTime,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.l10n.eventTime,
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                    ),
                    child: Text(
                      _selectedTime.format(context),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Vehicle selection
                if (vehicles.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    decoration: InputDecoration(
                      labelText: context.l10n.vehicleName,
                      prefixIcon: const Icon(Icons.directions_car),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Без привязки к ТС'),
                      ),
                      ...vehicles.map((vehicle) {
                        return DropdownMenuItem<String>(
                          value: vehicle.key.toString(),
                          child: Text(vehicle.fullName),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _selectedVehicleId = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                ],
                
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Описание',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Notification toggle
                SwitchListTile(
                  title: Text(context.l10n.notifications),
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                  secondary: const Icon(Icons.notifications),
                ),
                
                const SizedBox(height: AppTheme.paddingLarge),
                
                // Add event button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: context.l10n.addEvent,
                        onPressed: _saveEvent,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _selectTime() async {
    DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      currentTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      onConfirm: (time) {
        setState(() {
          _selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
        });
      },
    );
  }
  
  Future<void> _saveEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final eventProvider = Provider.of<EventProvider>(context, listen: false);
        
        // Combine date and time
        final eventDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
        
        await eventProvider.addEvent(
          title: _titleController.text.trim(),
          dateTime: eventDateTime,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          vehicleId: _selectedVehicleId,
          notificationEnabled: _notificationEnabled,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Событие добавлено')),
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
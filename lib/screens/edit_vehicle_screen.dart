import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/models/vehicle_model.dart';
import 'package:auto_wallet2/providers/vehicle_provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;
  const EditVehicleScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late TextEditingController makeController;
  late TextEditingController modelController;
  late TextEditingController licensePlateController;
  late TextEditingController mileageController;

  @override
  void initState() {
    super.initState();
    makeController = TextEditingController(text: widget.vehicle.make);
    modelController = TextEditingController(text: widget.vehicle.model);
    licensePlateController = TextEditingController(text: widget.vehicle.licensePlate ?? '');
    mileageController = TextEditingController(text: widget.vehicle.mileage?.toString() ?? '');
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    licensePlateController.dispose();
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать автомобиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: makeController,
              decoration: const InputDecoration(labelText: 'Марка'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(labelText: 'Модель'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: licensePlateController,
              decoration: const InputDecoration(labelText: 'Госномер'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: mileageController,
              decoration: const InputDecoration(labelText: 'Пробег (км)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                widget.vehicle.make = makeController.text;
                widget.vehicle.model = modelController.text;
                widget.vehicle.licensePlate = licensePlateController.text;
                widget.vehicle.mileage = int.tryParse(mileageController.text) ?? 0;
                await Provider.of<VehicleProvider>(context, listen: false).updateVehicle(widget.vehicle);
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  Future<void> addEvent({
    required String title,
    required DateTime dateTime,
    String? description,
    String? vehicleId,
    bool notificationEnabled = true,
  }) async {
    // Заглушка для добавления события
    await Future.delayed(Duration(milliseconds: 100));
  }

  List getEventsByDate(DateTime date) {
    // Вернуть пустой список или тестовые данные
    return [];
  }

  Future<void> deleteEvent(dynamic event) async {
    // Заглушка для удаления события
    await Future.delayed(Duration(milliseconds: 100));
  }
}


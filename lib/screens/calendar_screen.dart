import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/models/event_model.dart';
import 'package:auto_wallet2/providers/event_provider.dart';
import 'package:auto_wallet2/screens/add_event_screen.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_logo.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.getEventsByDate(_selectedDay);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.calendar),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(size: 40),
        ),
      ),
      body: Column(
        children: [
          // Calendar
          Card(
            margin: const EdgeInsets.all(AppTheme.paddingSmall),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              
              // Calendar display settings
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: AppTheme.subtitleStyle,
                headerPadding: const EdgeInsets.symmetric(vertical: AppTheme.paddingSmall),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.primary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              // Day display settings
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                defaultTextStyle: AppTheme.bodyStyle,
                weekendTextStyle: AppTheme.bodyStyle.copyWith(color: Colors.red),
                holidayTextStyle: AppTheme.bodyStyle.copyWith(color: Colors.red),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.3).toInt()),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              
              // Day selection
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              
              // Calendar format
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              
              // Page changed
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              
              // Event markers
              eventLoader: (day) {
                return eventProvider.getEventsByDate(day);
              },
            ),
          ),
          
          // Format selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFormatButton(CalendarFormat.month, context.l10n.month),
                const SizedBox(width: AppTheme.paddingSmall),
                _buildFormatButton(CalendarFormat.week, context.l10n.week),
              ],
            ),
          ),
          
          // Selected date events
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Row(
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(_selectedDay),
                  style: AppTheme.subtitleStyle,
                ),
                const Spacer(),
                Text(
                  '${events.length} события',
                  style: AppTheme.bodyStyle,
                ),
              ],
            ),
          ),
          
          // Events list
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'Нет событий на выбранный день',
                      style: AppTheme.bodyStyle,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _buildEventItem(event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildFormatButton(CalendarFormat format, String label) {
    final isSelected = _calendarFormat == format;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _calendarFormat = format;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEventItem(Event event) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.2).toInt()),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              DateFormat('HH:mm').format(event.dateTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          event.title,
          style: AppTheme.subtitleStyle,
        ),
        subtitle: event.description != null ? Text(event.description!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteEvent(event),
        ),
        onTap: () {
          // Navigate to event details
        },
      ),
    );
  }
  
  void _showAddEventScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEventScreen(selectedDate: _selectedDay),
      ),
    );
  }
  
  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить событие'),
        content: const Text('Вы уверены, что хотите удалить это событие?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final eventProvider = Provider.of<EventProvider>(context, listen: false);
              eventProvider.deleteEvent(event);
              Navigator.of(context).pop();
            },
            child: Text(
              context.l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class DateTimePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  const DateTimePickerWidget({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? formattedTime;

  void _selectDate(BuildContext context) {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2101),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
        widget.onDateSelected(date);
      },
      currentTime: selectedDate ?? DateTime.now(),
      locale: picker.LocaleType.en,
    );
  }

  void _selectTime(BuildContext context) {
    picker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (dateTime) {
        final timeOfDay =
            TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
        setState(() {
          selectedTime = timeOfDay;
          formattedTime = _formatTime12Hour(timeOfDay);
        });
        widget.onTimeSelected(timeOfDay);
      },
      currentTime: DateTime.now(),
      locale: picker.LocaleType.en,
    );
  }

  String _formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          style: _buttonStyle(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select Date',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _selectTime(context),
          style: _buttonStyle(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                formattedTime ?? 'Select Time',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 0,
      side: BorderSide(color: Colors.grey.shade200, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

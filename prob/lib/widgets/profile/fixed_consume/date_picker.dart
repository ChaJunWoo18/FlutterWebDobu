import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class DatePickerWithTextField extends StatefulWidget {
  const DatePickerWithTextField({super.key, required this.provider});

  final dynamic provider;
  @override
  State<DatePickerWithTextField> createState() =>
      _DatePickerWithTextFieldState();
}

class _DatePickerWithTextFieldState extends State<DatePickerWithTextField> {
  List<DateTime?> _dialogCalendarPickerValue = [DateTime.now()];
  final primaryColor = const Color(0xFFC19F64);

  final DateTime lastDay =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  final DateTime firstDay =
      DateTime(DateTime.now().year, DateTime.now().month - 2, 1);

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    return values.isNotEmpty && values[0] != null
        ? values[0].toString().replaceAll('00:00:00.000', '')
        : 'null';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.provider.dateController;
    return TextField(
      controller: controller,
      readOnly: true,
      cursorColor: const Color(0xFF707070),
      cursorWidth: 1,
      style: const TextStyle(fontSize: 15, color: Color(0xFF3B2304)),
      decoration: InputDecoration(
        errorText: widget.provider.dateError,
        errorStyle: const TextStyle(fontSize: 10),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 136, 81, 10), width: 1.5)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF707070))),
      ),
      onTap: () async {
        final config = CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: primaryColor,
          lastDate: lastDay,
          firstDate: firstDay,
          // dialogBackgroundColor: Colors.white,
          controlsTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );

        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 370),
          borderRadius: BorderRadius.circular(15),
          value: _dialogCalendarPickerValue,
        );

        if (values != null && values.isNotEmpty) {
          setState(() {
            _dialogCalendarPickerValue = values;
            controller.text = _getValueText(config.calendarType, values);
          });
        }
      },
    );
  }
}

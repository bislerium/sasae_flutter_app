import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({Key? key}) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return '';
    } else {
      return DateFormat('MM/dd/yyyy').format(date!);
    }
  }

  @override
  void dispose() {
    dateField.dispose();
    super.dispose();
  }

  var dateField = TextEditingController();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: dateField..text = getText(),
              decoration: const InputDecoration(
                label: Text('Birthdate'),
                icon: Icon(Icons.calendar_today_rounded),
              ),
              readOnly: true,
              onTap: () => pickDate(context),
            ),
          ),
        ],
      );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }
}

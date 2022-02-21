import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_widgets.dart';

class DatePickerField extends StatefulWidget {
  final void Function(DateTime) setDateHandler;

  const DatePickerField({Key? key, required this.setDateHandler})
      : super(key: key);

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
              controller: dateField,
              decoration: const InputDecoration(
                label: Text('Birthdate'),
                icon: Icon(Icons.calendar_today_rounded),
              ),
              readOnly: true,
              onTap: () => pickDate(context),
              validator: (value) {
                return checkValue(
                  value: value,
                  checkEmptyOnly: true,
                );
              },
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
      // builder: (BuildContext ctx, Widget? child) {
      //   return Theme(
      //     data: ThemeData.light(),
      //     child: child!,
      //   );
      // },
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
      dateField.text = getText();
      widget.setDateHandler(date!);
    });
  }
}

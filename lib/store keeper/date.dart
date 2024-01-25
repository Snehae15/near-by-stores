import 'package:flutter/material.dart';

class DatePickers extends StatefulWidget {
  const DatePickers({required Key key}) : super(key: key);

  @override
  _DatePickersState createState() => _DatePickersState();
}

class _DatePickersState extends State<DatePickers> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Date Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selected Date:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '${selectedDate.toLocal()}'.split(' ')[0],
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:financialmanagement_app/helpers/database_helper.dart';

class Pemasukan extends StatefulWidget {
  @override
  _PemasukanState createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _resetFields() {
    _dateController.text = '01/01/2021';
    _amountController.text = '';
    _descriptionController.text = '';
  }

  void _saveIncome() async {
    String date = _dateController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;
    String description = _descriptionController.text;

    if (date.isEmpty || amount <= 0 || description.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter valid date, amount, and description.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      await _databaseHelper.insertPemasukan(date, amount, description);
      _resetFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Income saved successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tambah Pemasukan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    setState(() {
                      _dateController.text = formattedDate;
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Tanggal'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveIncome,
                child: Text('Simpan'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _resetFields();
                },
                child: Text('Reset'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

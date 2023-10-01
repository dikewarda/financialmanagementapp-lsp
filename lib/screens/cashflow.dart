import 'package:flutter/material.dart';
import 'package:financialmanagement_app/helpers/database_helper.dart';

class CashFlow extends StatefulWidget {
  @override
  _CashFlowState createState() => _CashFlowState();
}

class _CashFlowState extends State<CashFlow> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transaksi = [];

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  void _loadTransaksi() async {
    List<Map<String, dynamic>> transaksi =
        await _databaseHelper.queryAllTransaksi();
    setState(() {
      _transaksi = transaksi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cash Flow'),
      ),
      body: ListView.builder(
        itemCount: _transaksi.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> transaksi = _transaksi[index];
          IconData icon;
          Color iconColor;
          if (transaksi['type'] == 'income') {
            icon = Icons.arrow_downward;
            iconColor = Colors.green;
          } else {
            icon = Icons.arrow_upward;
            iconColor = Colors.red;
          }
          return ListTile(
            title: Text('Nominal: Rp.${transaksi['amount']}0'),
            subtitle: Text(
                'Tanggal: ${transaksi['date']}\nKeterangan: ${transaksi['description']}'),
            trailing: Icon(
              icon,
              color: iconColor,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:financialmanagement_app/helpers/user_provider.dart';
import 'package:financialmanagement_app/helpers/database_helper.dart';
import 'package:financialmanagement_app/screens/login.dart';
import 'package:financialmanagement_app/screens/pemasukan.dart';
import 'package:financialmanagement_app/screens/pengeluaran.dart';
import 'package:financialmanagement_app/screens/cashflow.dart';
import 'package:financialmanagement_app/screens/pengaturan.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  double totalPemasukan = 0;
  double totalPengeluaran = 0;

  @override
  void initState() {
    super.initState();
    _loadTotal();
  }

  void _loadTotal() async {
    double pemasukan = await _databaseHelper.getTotalPemasukan() ?? 0;
    double pengeluaran = await _databaseHelper.getTotalPengeluaran() ?? 0;
    setState(() {
      totalPemasukan = pemasukan;
      totalPengeluaran = pengeluaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    String loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Financial Management App'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rangkuman Bulan ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Pengeluaran: Rp.${totalPengeluaran}0',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              SizedBox(height: 5),
              Text(
                'Pemasukan: Rp.${totalPemasukan}0',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/icon/graph.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton(context, 'Pemasukan', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pemasukan()));
                  }, 'assets/icon/income.png', true),
                  _buildMenuButton(context, 'Pengeluaran', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pengeluaran()));
                  }, 'assets/icon/outcome.png', true),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton(context, 'Detail Cash Flow', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CashFlow()));
                  }, 'assets/icon/cashflow.png', true),
                  _buildMenuButton(context, 'Pengaturan', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Pengaturan(
                                  username: loggedInUser,
                                )));
                  }, 'assets/icon/settings.png', true),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildMenuButton(BuildContext context, String text,
      VoidCallback onPressed, String iconPath, bool isPemasukanButton) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          margin:
              isPemasukanButton ? EdgeInsets.only(right: 12) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 75, 171, 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Image.asset(iconPath, height: 36),
          ),
        ),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}

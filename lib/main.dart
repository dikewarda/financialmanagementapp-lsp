import 'package:flutter/material.dart';
import 'package:financialmanagement_app/screens/login.dart';
import 'package:financialmanagement_app/screens/home.dart';
import 'package:financialmanagement_app/screens/pemasukan.dart';
import 'package:financialmanagement_app/screens/pengeluaran.dart';
import 'package:financialmanagement_app/screens/cashflow.dart';
import 'package:financialmanagement_app/screens/pengaturan.dart';
import 'package:provider/provider.dart';
import 'package:financialmanagement_app/helpers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request(); // Meminta izin akses penyimpanan

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Management App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/income': (context) => Pemasukan(),
        '/outcome': (context) => Pengeluaran(),
        '/cashflow': (context) => CashFlow(),
        '/settings': (context) => Pengaturan(
              username: Provider.of<UserProvider>(context).loggedInUser,
            )
      },
    );
  }
}

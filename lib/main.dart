import 'package:crypto_calc/screens/loading.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF212244),
          scaffoldBackgroundColor: Color(0xFF161730)),
      home: Loading(),
    );
  }
}

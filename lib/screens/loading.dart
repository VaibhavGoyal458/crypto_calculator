import 'package:crypto_calc/screens/price_screen.dart';
import 'package:crypto_calc/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  final String currency;

  Loading({this.currency});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future getData() async {
    var response;
    if (widget.currency == null) {
      response = await NetworkHelper().getData('USD');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PriceScreen(
            response: response,
          ),
        ),
      );
    } else {
      response = await NetworkHelper().getData(widget.currency);
      Navigator.pop(context, response);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}

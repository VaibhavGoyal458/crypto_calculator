import 'package:crypto_calc/screens/loading.dart';
import 'package:crypto_calc/services/networking.dart';
import 'package:crypto_calc/utils/coin_data.dart';
import 'package:crypto_calc/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//'show' Only imports the Platform class from the io package
//similar to 'show', we have 'hide' which only hides the specified class and imports all the rest of the class form the package
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  final dynamic response;
  PriceScreen({this.response});
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  String selectedCurrency = 'USD';
  bool isWaiting = false;
  var cryptoResponse;
  var cryptValue;

  // TODO: Complete the cupertino dropdown functionality
  CupertinoPicker cupertinoDropdown() {
    List<Text> dropDown = [];
    for (String currency in currenciesList) {
      dropDown.add(Text(
        '$currency',
        style: TextStyle(
          color: Colors.white,
        ),
      ));
    }
    return CupertinoPicker(
      itemExtent: 24.0,
      onSelectedItemChanged: (value) {
        print('value : $value');
      },
      children: dropDown,
    );
  }

  ListView currencyHorizontalList() {
    List<Widget> paddingWidgetList = [];
    for (String currency in currenciesList) {
      Padding paddingWidget = Padding(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          color: Color(0xFF2C2C53),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '$currency',
              style: kBottomContainerTextStyle,
            ),
          ),
          onPressed: () {
            setState(() {
              selectedCurrency = currency;
              isWaiting = true;
            });
            getCryptoData();
          },
        ),
      );
      paddingWidgetList.add(paddingWidget);
    }

    ListView horizontalList = ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          height: 100,
          child: Row(
            children: paddingWidgetList,
          ),
        )
      ],
    );
    return horizontalList;
  }

  void getCryptoData() async {
    cryptValue = {};
    if (cryptoResponse != null) {
      for (dynamic crypt in cryptoList) {
        var key = crypt['crypto'];
        cryptValue[key] =
            cryptoResponse[key]['response']['rate'].toStringAsFixed(2);
      }
      cryptoResponse = null;
    } else {
      var response = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Loading(
            currency: selectedCurrency,
          ),
        ),
      );
      setState(() {
        isWaiting = false;
        for (dynamic crypt in cryptoList) {
          var key = crypt['crypto'];
          cryptValue[key] =
              response[key]['response']['rate'].toStringAsFixed(2);
        }
      });
    }
  }

  List<Widget> cryptoWidget() {
    List<Widget> paddingWidgets = [];
    for (dynamic crypt in cryptoList) {
      var key = crypt['crypto'];
      var iconData = crypt[IconData];
      paddingWidgets.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Card(
          color: Color(0xFF2C2C53),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      iconData,
                      size: 80,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${isWaiting == true ? '' : cryptValue[key]} ',
                      style: kTextStyle.copyWith(fontWeight: FontWeight.w200),
                    ),
                    Text(
                      '$selectedCurrency',
                      style: kTextStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));
    }
    return paddingWidgets;
  }

  @override
  void initState() {
    cryptoResponse = widget.response;
    getCryptoData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        100;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.attach_money),
        title: Text(
          'Crypto Calculator',
          style: kAppBarTextStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(minHeight: containerHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cryptoWidget(),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 100.0,
              alignment: Alignment.center,
              color: Color(0xFF212244),
              child: Container(
                child: Platform.isIOS
                    ? cupertinoDropdown()
                    : currencyHorizontalList(),
              ))
        ],
      ),
    );
  }
}

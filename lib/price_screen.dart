import 'package:crypto_calc/services/networking.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//'show' Only imports the Platform class from the io package
//similar to 'show', we have 'hide' which only hides the specified class and imports all the rest of the class form the package
import 'dart:io' show Platform;

import 'coin_data.dart';
import 'constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  String selectedCurrency = 'USD';
  var cryptValue;
  bool isWaiting = false;

  DropdownButton<String> materialDropdown() {
    List<DropdownMenuItem<String>> dropdownList = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> dropdownMenuItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
      dropdownList.add(dropdownMenuItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      underline: SizedBox(),
      items: dropdownList,
      style: kBottomContainerTextStyle,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          isWaiting = true;
          cryptValue = '';
        });
        getCryptoData();
      },
    );
  }

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

  void getCryptoData() async {
    cryptValue = {};
    var response = await networkHelper.getData(selectedCurrency);
    isWaiting = false;
    setState(() {
      for (dynamic crypt in cryptoList) {
        var key = crypt['crypto'];
        cryptValue[key] = response[key]['response']['rate'].toStringAsFixed(2);
      }
    });
  }

  List<Widget> returnPaddingWidget() {
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
    isWaiting = true;
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
                    children: returnPaddingWidget(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            color: Color(0xFF212244),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Currency :  ',
                  style: kBottomContainerTextStyle.copyWith(
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  child:
                      Platform.isIOS ? cupertinoDropdown() : materialDropdown(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

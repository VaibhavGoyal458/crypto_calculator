import 'dart:convert';
import 'package:http/http.dart' as http;
import '../credentials.dart';

const url = 'https://rest.coinapi.io/v1/exchangerate';
const crypto = ['BTC', 'ETH', 'LTC'];

class NetworkHelper {
  Future getData(String currency) async {
    Map cryptoData = {};
    for (String cryptoCurr in crypto) {
      Map cryptoResponse;
      var response = await http.get('$url/$cryptoCurr/$currency$apiKey');
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        cryptoResponse = {
          cryptoCurr: {'response': responseBody, 'statusCode': 200}
        };
      } else {
        cryptoResponse = {
          cryptoCurr: {'response': null, 'statusCode': response.statusCode}
        };
      }
      cryptoData.addAll(cryptoResponse);
    }
    return cryptoData;
  }
}

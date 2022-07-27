import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class DataHolder {
  late  SharedPreferences _prefs;

  List<dynamic> data = [];

  Future<void> loadDataFromSP() async {
    _prefs=await SharedPreferences.getInstance();
    var result = _prefs.getString('DATA');
    data = json.decode(result ?? '[]');

  }
  Future<void> saveDataToSP() async {
    String readyToSaveData = json.encode(data);
    _prefs.setString('DATA', readyToSaveData);
  }

}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'settings_localizations.dart';
export 'types.dart';
export 'choice.dart';
export 'settings_page_route.dart';
export 'settings_menu_item.dart';
export 'settings_menu.dart';
export 'settings_search_delegate.dart';
//export 'single_choice.dart';
//export 'slider_list_tile.dart';
//export 'time_picker_list_tile.dart';
//export 'section.dart';
//export 'multiple_choice_list_tile.dart';
//export 'multiple_choice.dart';
//export 'master_switch.dart';
//export 'master_switch_list_tile.dart';
//export 'individual_switch.dart';
//export 'dependency.dart';
//export 'date_picker_list_tile.dart';
//export 'time_picker_list_tile.dart';
//export 'date_time_picker_list_tile.dart';

class Settings {
  Settings.initWith(this.preferences);

  final SharedPreferences preferences;

  static Future<Settings> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Settings.initWith(preferences);
  }

  bool getBool(Key key) => preferences.getBool('$key');
  Future<bool> setBool(Key key, bool value) {
    _setValueType(key, value);
    return preferences.setBool('$key', value);
  }

  double getDouble(Key key) => preferences.getDouble('$key');
  Future<bool> setDouble(Key key, double value) {
    _setValueType(key, value);
    return preferences.setDouble('$key', value);
  }

  int getInt(Key key) => preferences.getInt('$key');
  Future<bool> setInt(Key key, int value) {
    _setValueType(key, value);
    return preferences.setInt('$key', value);
  }

  String getString(Key key) => preferences.getString(key.toString());
  Future<bool> setString(Key key, String value) {
    _setValueType(key, value);
    return preferences.setString('$key', value);
  }

  List<String> getStringList(Key key) => preferences.getStringList('$key');
  Future<bool> setStringList(Key key, List<String> value) {
    _setValueType(key, value);
    return preferences.setStringList('$key', value);
  }

  DateTime getDateTime(Key key) => DateTime.fromMillisecondsSinceEpoch(
      preferences.getInt('$key')
  );
  Future<bool> setDateTime(Key key, DateTime value) {
    _setValueType(key, value);
    return preferences.setInt('$key', value.millisecondsSinceEpoch);
  }

  TimeOfDay getTimeOfDay(Key key) => _timeFromMinutes(
      preferences.getInt('$key')
  );
  Future<bool> setTimeOfDay(Key key, TimeOfDay value) {
    _setValueType(key, value);
    return preferences.setInt('$key', _timeToMinutes(value));
  }

  String _getValueType(Key key) => preferences.getString('_TYPE_OF_$key');
  Future<bool> _setValueType(Key key, dynamic value)
    => preferences.setString('_TYPE_OF_$key', '${value.runtimeType}');

  dynamic get(Key key) {
    String type = _getValueType(key);

    switch(type) {
      case 'bool': return getBool(key);
      case 'double': return getDouble(key);
      case 'int': return getInt(key);
      case 'String': return getString(key);
      case 'List<String>': return getStringList(key);
      case 'DateTime': return getDateTime(key);
      case 'TimeOfDay': return getTimeOfDay(key);
    }
  }

  Future<bool> set(Key key, dynamic value) {
    _setValueType(key, value);

    return (value is bool) ? setBool(key, value)
        : (value is double) ? setDouble(key, value)
        : (value is int) ? setInt(key, value)
        : (value is String) ? setString(key, value)
        : (value is List<String>) ? setStringList(key, value)
        : (value is DateTime) ? setDateTime(key, value)
        : (value is TimeOfDay) ? setTimeOfDay(key, value)
        : false;
  }

  static int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static TimeOfDay _timeFromMinutes(int minutes) => TimeOfDay(
      hour: (minutes / 60).floor(),
      minute: minutes % 60
  );
}
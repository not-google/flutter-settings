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
  Settings.createWith(this.preferences);

  final SharedPreferences preferences;

  static Future<Settings> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Settings.createWith(preferences);
  }

  _get(Key key) {
    String _key = key.toString();
    String valueType = preferences.getString('_TYPE_OF_$_key');

    switch(valueType) {
      case 'bool': return preferences.getBool(_key);
      case 'double': return preferences.getDouble(_key);
      case 'int': return preferences.getInt(_key);
      case 'String': return preferences.getString(_key);
      case 'List<String>': return preferences.getStringList(_key);
      case 'DateTime':
        int millisecondsSinceEpoch = preferences.getInt(_key);
        return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
      case 'TimeOfDay':
        int timeInMinutes = preferences.getInt(_key);
        return _timeFromMinutes(timeInMinutes);
    }
  }

  dynamic getLoaded(Key key) {
    return _get(key);
  }

  Future<dynamic> get(Key key) async {
    return _get(key);
  }

  Future<bool> set(Key key, value) async {
    String _key = key.toString();
    preferences.setString('_TYPE_OF_$key', value.runtimeType.toString());

    return (value is bool) ? preferences.setBool(_key, value)
        : (value is double) ? preferences.setDouble(_key, value)
        : (value is int) ? preferences.setInt(_key, value)
        : (value is String) ? preferences.setString(_key, value)
        : (value is List<String>) ? preferences.setStringList(_key, value)
        : (value is DateTime) ? preferences.setInt(_key, value.millisecondsSinceEpoch)
        : (value is TimeOfDay) ? preferences.setInt(_key, _timeToMinutes(value))
        : false;
  }

  static int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static TimeOfDay _timeFromMinutes(int minutes) => TimeOfDay(
      hour: (minutes / 60).floor(),
      minute: minutes % 60
  );
}
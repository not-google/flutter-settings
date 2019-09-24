import 'package:flutter/material.dart';
export 'settings_localizations.dart';
export 'types.dart';
export 'choice.dart';
export 'settings_page.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static getWithInstance(String key, SharedPreferences preferences) {
    String valueType = preferences.getString('_TYPE_OF_$key');

    switch(valueType) {
      case 'bool': return preferences.getBool(key);
      case 'double': return preferences.getDouble(key);
      case 'int': return preferences.getInt(key);
      case 'String': return preferences.getString(key);
      case 'List<String>': return preferences.getStringList(key);
      case 'DateTime':
        int millisecondsSinceEpoch = preferences.getInt(key);
        return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
      case 'TimeOfDay':
        int timeInMinutes = preferences.getInt(key);
        return _timeFromMinutes(timeInMinutes);
    }
  }

  static get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return getWithInstance(key, preferences);
  }

  static Future<bool> set(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return setWithInstance(key, value, preferences);
  }

  static setWithInstance(String key, value, SharedPreferences preferences) {
    preferences.setString('_TYPE_OF_$key', value.runtimeType.toString());

    return (value is bool) ? preferences.setBool(key, value)
        : (value is double) ? preferences.setDouble(key, value)
        : (value is int) ? preferences.setInt(key, value)
        : (value is String) ? preferences.setString(key, value)
        : (value is List<String>) ? preferences.setStringList(key, value)
        : (value is DateTime) ? preferences.setInt(key, value.millisecondsSinceEpoch)
        : (value is TimeOfDay) ? preferences.setInt(key, _timeToMinutes(value))
        : false;
  }

  static int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static TimeOfDay _timeFromMinutes(int minutes) => TimeOfDay(
      hour: (minutes / 60).floor(),
      minute: minutes % 60
  );
}
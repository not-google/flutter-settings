import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  _generateSettings({ int currentDepthLevel = 1, String keyPostfix = '' }) {
    const int maxDepthLevel = 3;
    return Iterable.generate(10 * currentDepthLevel, (i) {
      String itemKeyPostfix = '$keyPostfix${keyPostfix.isEmpty ? '' : '_'}$i';
      String itemPostfix = itemKeyPostfix.replaceAll('_', '.');

      return (i % 5 == 0) ? SettingsPattern.listSubscreen(
          label: 'Настройки $itemPostfix',
          secondaryText: 'Страница настроек',
          group: currentDepthLevel > maxDepthLevel ? null : _generateSettings(
            currentDepthLevel: currentDepthLevel + 1,
            keyPostfix: itemKeyPostfix
          )
      ) :
      (i % 4 == 0) ? SettingsPattern.multipleChoice(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        options: [
          SelectionOption(label: 'Опция 1', value: 1),
          SelectionOption(label: 'Опция 2', value: 2),
          SelectionOption(label: 'Опция 3', value: 3),
          SelectionOption(label: 'Опция 4', value: 4),
        ],
        defaultValue: [1, 3],
        secondaryText: 'Несколько из списка',
      ) :
      (i % 3 == 0) ? SettingsPattern.singleChoice(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        options: [
          SelectionOption(label: 'Опция 1', value: 1),
          SelectionOption(label: 'Опция 2', value: 2),
          SelectionOption(label: 'Опция 3', value: 3),
          SelectionOption(label: 'Опция 4', value: 4),
        ],
        defaultValue: 1,
        secondaryText: 'Один из списка',
      ) :
      (i % 2 == 0) ? SettingsPattern.dateTime(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        defaultValue: DateTime(2020),
        secondaryText: 'Дата и время',
      ) : SettingsPattern.toggleSwitch(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        defaultValue: i % 2 == 0,
        secondaryText: 'Описание настройки',
      );
    });
  }

  Iterable<SettingsPattern> get _settings => _generateSettings();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(
        title: 'Settings',
        group: _settings,
        helpBuilder: (context) => Text('Help Message'),
      ),
    );
  }
}
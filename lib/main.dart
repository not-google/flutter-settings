import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  _generateSettings({ int currentDepthLevel = 1, String keyPostfix = '' }) {
    const int maxDepthLevel = 3;
    return List.generate(12 * currentDepthLevel, (i) {
      String itemKeyPostfix = '$keyPostfix${keyPostfix.isEmpty ? '' : '_'}$i';
      String itemPostfix = itemKeyPostfix.replaceAll('_', '.');

      return (i % 11 == 0) ? SettingsMenuItem.individualSwitch(
          id: 'SETTING$itemKeyPostfix',
          label: 'Группа $itemPostfix',
          secondaryText: 'IndividualSwitch',
          defaultValue: true,
          //enabled: true,
          activeBuilder: (context) => Text('АКТИВНО'),
          inactiveBuilder: (context) => Text('НЕАКТИВНО')
      ) :
      (i % 10 == 0) ? SettingsMenuItem.masterSwitch(
          id: 'SETTING$itemKeyPostfix',
          label: 'Группа $itemPostfix',
          secondaryText: 'MasterSwitch',
          defaultValue: true,
          //enabled: true,
          group: <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING$itemKeyPostfix.1',
              label: 'Зависимая настройка $itemPostfix.1',
              defaultValue: i % 2 == 0,
              secondaryText: 'Описание настройки',
            ),
            SettingsMenuItem.listSubscreen(
                label: 'Зависимая настройка $itemPostfix.2',
                secondaryText: 'Страница настроек',
                group: currentDepthLevel > maxDepthLevel ? null : _generateSettings(
                    currentDepthLevel: currentDepthLevel + 1,
                    keyPostfix: itemKeyPostfix
                )
            )
          ],
          inactiveBuilder: (context) => Text('Текст неактивного состояния')
      ) :
      (i % 9 == 0) ? SettingsMenuItem.dependency(
        id: 'SETTING$itemKeyPostfix',
        label: 'Группа $itemPostfix',
        secondaryText: 'Состояние зависимостей',
        defaultValue: true,
        group: <SettingsMenuItem>[
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING$itemKeyPostfix.1',
            label: 'Зависимая настройка $itemPostfix.1',
            defaultValue: i % 2 == 0,
            secondaryText: 'Описание настройки',
          ),
          SettingsMenuItem.listSubscreen(
              label: 'Зависимая настройка $itemPostfix.2',
              secondaryText: 'Страница настроек',
              group: currentDepthLevel > maxDepthLevel ? null : _generateSettings(
                  currentDepthLevel: currentDepthLevel + 1,
                  keyPostfix: itemKeyPostfix
              )
          )
        ],
      ) :
      (i % 8 == 0 || i % 7 == 0) ? SettingsMenuItem.section(
          title: 'Секция $itemPostfix',
          group: <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING$itemKeyPostfix.1',
              label: 'Настройка $itemPostfix.1',
              defaultValue: i % 2 == 0,
              secondaryText: 'Описание настройки',
            ),
            SettingsMenuItem.listSubscreen(
                label: 'Настройки $itemPostfix.2',
                secondaryText: 'Страница настроек',
                group: currentDepthLevel > maxDepthLevel ? null : _generateSettings(
                    currentDepthLevel: currentDepthLevel + 1,
                    keyPostfix: itemKeyPostfix
                )
            )
          ],
          enabled: false
      ) :
      (i % 6 == 0) ? SettingsMenuItem.slider(
          id: 'SETTING$itemKeyPostfix',
          label: 'Настройки $itemPostfix',
          secondaryText: 'Страница настроек',
          enabled: false
      ) :
      (i % 5 == 0) ? SettingsMenuItem.listSubscreen(
          label: 'Настройки $itemPostfix',
          secondaryText: 'Страница настроек',
          group: currentDepthLevel > maxDepthLevel ? null : _generateSettings(
              currentDepthLevel: currentDepthLevel + 1,
              keyPostfix: itemKeyPostfix
          ),
          enabled: false
      ) :
      (i % 4 == 0) ? SettingsMenuItem.multipleChoice(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        secondaryText: 'Несколько из списка',
        options: <SelectionOption>[
          SelectionOption(label: 'Опция 1', value: 1),
          SelectionOption(label: 'Опция 2', value: 2),
          SelectionOption(label: 'Опция 3', value: 3),
          SelectionOption(label: 'Опция 4', value: 4),
        ],
        defaultValue: [1, 3],
        //enabled: false
      ) :
      (i % 3 == 0) ? SettingsMenuItem.singleChoice(
        id: 'SETTING$itemKeyPostfix',
        label: 'Настройка $itemPostfix',
        options: <SelectionOption>[
          SelectionOption(label: 'Опция 1', value: 1),
          SelectionOption(label: 'Опция 2', value: 2),
          SelectionOption(label: 'Опция 3', value: 3),
          SelectionOption(label: 'Опция 4', value: 4),
        ],
        defaultValue: 1,
        secondaryText: 'Один из списка',
        //enabled: false
      ) :
      (i % 2 == 0) ? SettingsMenuItem.dateTime(
          id: 'SETTING$itemKeyPostfix',
          label: 'Настройка $itemPostfix',
          defaultValue: DateTime(2020),
          secondaryText: 'Дата и время',
          enabled: false
      ) : SettingsMenuItem.toggleSwitch(
          id: 'SETTING$itemKeyPostfix',
          label: 'Настройка $itemPostfix',
          defaultValue: i % 2 == 0,
          secondaryText: 'Описание настройки',
          enabled: false
      );
    });
  }

  List<SettingsMenuItem> get _settings => _generateSettings();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsScaffold(
        title: Text('Settings'),
        body: Settings(_settings),
        helpBuilder: (context) => Text('Help Message'),
      ),
    );
  }
}
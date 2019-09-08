import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  List<SettingsMenuItem> _getSettings(BuildContext context) {
    return [
    SettingsMenuItem.individualSwitch(
      id: 'SETTING_1',
      leading: Icon(Icons.settings),
      label: 'Individual Switch',
      secondaryText: Text('Очень длинное описание, которое разьясняет назначение данной настройки'),
      defaultValue: true,
      //enabled: true,
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.masterSwitch(
        id: 'SETTING_2',
        leading: Icon(Icons.settings),
        label: 'Master Switch',
        masterSwitchTitle: Text('Use Master Switch'),
        activeSecondaryTextBuilder: (context) => Text('On'),
        inactiveSecondaryTextBuilder: (context) => Text('Turned Off'),
        inactiveTextBuilder: (context) => Text('Текст неактивного состояния'),
        defaultValue: true,
        onChanged: (value) => print('value: $value'),
        //enabled: true,
        group: <SettingsMenuItem>[
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.1',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch 1',
            defaultValue: true,
            secondaryText: Text('Описание настройки'),
          ),
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.2',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch 2',
            defaultValue: false,
            secondaryText: Text('Описание настройки'),
          ),
          SettingsMenuItem.section(
            title: 'Section',
            group: <SettingsMenuItem>[
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.1',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch 3',
                defaultValue: true,
                secondaryText: Text('Описание настройки'),
              ),
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.2',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch 4',
                defaultValue: false,
                secondaryText: Text('Описание настройки'),
              ),
            ],
          )
        ],
    ),
    SettingsMenuItem.dependency(
      id: 'SETTING_3',
      leading: Icon(Icons.settings),
      label: 'Dependency',
      secondaryText: Text('Состояние зависимостей'),
      defaultValue: true,
      onChanged: (value) => print('value: $value'),
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 5',
          defaultValue: true,
          secondaryText: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 6',
          defaultValue: true,
          secondaryText: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.section(
          title: 'Section 1',
          group: <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 7',
              defaultValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 8',
              defaultValue: false,
              secondaryText: Text('Описание настройки'),
            ),
          ],
        )
      ],
    ),
//    SettingsMenuItem.toggleSwitch(
//      id: 'SETTING_3.3.1',
//      leading: Icon(Icons.settings),
//      label: 'Toggle Switch 9',
//      defaultValue: true,
//      secondaryText: Text('Описание настройки'),
//    ),
    SettingsMenuItem.section(
      title: 'Section 2',
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 10',
          defaultValue: true,
          secondaryText: Text('Описание настройки'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 11',
          defaultValue: false,
          secondaryText: Text('Описание настройки'),
        ),
      ],
    ),
    SettingsMenuItem.slider(
      id: 'SETTING_5',
      leading: Icon(Icons.settings),
      label: 'Slider',
      secondaryText: Text('Страница настроек'),
      defaultValue: 0,
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.listSubscreen(
      label: 'List Subscreen',
      leading: Icon(Icons.settings),
      secondaryText: Text('Страница настроек'),
      group: [
        SettingsMenuItem.listSubscreen(
          label: 'List Subscreen Item 1',
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          group: [
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 12',
              defaultValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 13',
              defaultValue: false,
              secondaryText: Text('Описание настройки'),
            ),
          ],
        ),
        SettingsMenuItem.listSubscreen(
          label: 'List Subscreen Item 2',
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          group: [
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 14',
              defaultValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 15',
              defaultValue: false,
              secondaryText: Text('Описание настройки'),
            ),
          ],
        )
      ],
    ),
    SettingsMenuItem.multipleChoice(
      id: 'SETTING_8',
      leading: Icon(Icons.settings),
      label: 'Multiple Choice',
      secondaryText: Text('Несколько из списка'),
      choices: <Choice>[
        Choice(label: 'Опция 1', value: 1),
        Choice(label: 'Опция 2', value: 2),
        Choice(label: 'Опция 3', value: 3),
        Choice(label: 'Опция 4', value: 4),
      ],
      defaultValue: [1, 3],
      onChanged: (value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.singleChoice(
      id: 'SETTING_9',
      leading: Icon(Icons.settings),
      label: 'Single Choice',
      secondaryText: Text('Один из списка'),
      choices: <Choice>[
        Choice(label: 'Опция 1', value: 1),
        Choice(label: 'Опция 2', value: 2),
        Choice(label: 'Опция 3', value: 3),
        Choice(label: 'Опция 4', value: 4),
      ],
      defaultValue: 1,
      onChanged: (value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.dateTime(
      id: 'SETTINGS_10',
      leading: Icon(Icons.settings),
      label: 'DateTime',
      defaultValue: DateTime(2020),
      secondaryText: Text('Дата и время'),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.toggleSwitch(
      id: 'SETTING_11',
      leading: Icon(Icons.settings),
      label: 'Toggle Switch 16',
      defaultValue: true,
      secondaryText: Text('Описание настройки'),
      onChanged: (value) => print('value: $value'),
    )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SettingsScaffold(
        title: Text('Settings'),
        settings: _getSettings(context),
        helpBuilder: (context) => Text('Help Message'),
      ),
    );
  }
}
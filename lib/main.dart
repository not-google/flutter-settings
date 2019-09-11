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
      initialValue: true,
      //enabled: true,
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.masterSwitch(
        id: 'SETTING_2',
        leading: Icon(Icons.settings),
        label: 'Master Switch',
        masterSwitchTitle: Text('Use Master Switch'),
        //statusTextBuilder: (_, isActive) => isActive ? Text('On') : Text('Status Off'),
        inactiveTextBuilder: (_) => Text('Текст неактивного состояния'),
        initialValue: true,
        duplicateSwitchInMenuItem: true,
        onChanged: (bool value) => print('value: $value'),
        //enabled: true,
        group: <SettingsMenuItem>[
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.1',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch 1',
            initialValue: true,
            secondaryText: Text('Описание настройки'),
            onChanged: (value) => print(value),
          ),
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.2',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch 2',
            initialValue: false,
            secondaryText: Text('Описание настройки'),
          ),
          SettingsMenuItem.section(
            title: 'Section',
            group: <SettingsMenuItem>[
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.1',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch 3',
                initialValue: true,
                secondaryText: Text('Описание настройки'),
              ),
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.2',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch 4',
                initialValue: false,
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
      initialValue: true,
      onChanged: (value) => print('value: $value'),
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 5',
          initialValue: true,
          secondaryText: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 6',
          initialValue: true,
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
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 8',
              initialValue: false,
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
//      initialValue: true,
//      secondaryText: Text('Описание настройки'),
//    ),
    SettingsMenuItem.section(
      title: 'Section 2',
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 10',
          initialValue: true,
          secondaryText: Text('Описание настройки'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch 11',
          initialValue: false,
          secondaryText: Text('Описание настройки'),
        ),
      ],
    ),
    SettingsMenuItem.slider(
      id: 'SETTING_5',
      leading: Icon(Icons.settings),
      label: 'Slider',
      secondaryText: Text('Страница настроек'),
      initialValue: 0,
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
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 13',
              initialValue: false,
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
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch 15',
              initialValue: false,
              secondaryText: Text('Описание настройки'),
            ),
          ],
        )
      ],
    ),
    SettingsMenuItem<int>.multipleChoice(
      id: 'SETTING_8',
      leading: Icon(Icons.settings),
      label: 'Multiple Choice',
//      statusTextBuilder: (context, List<Choice<int>> choices) {
//        if (choices.isEmpty) return Text('Not Chosen');
//        String labels = choices.map((choice) => choice.label).join(', ');
//        return Text('$labels');
//      },
      choices: <Choice<int>>[
        Choice(label: 'Опция 1', value: 1),
        Choice(label: 'Опция 2', value: 2),
        Choice(label: 'Опция 3', value: 3),
        Choice(label: 'Опция 4', value: 4),
      ],
      initialValue: [1, 3],
      onChanged: (List<int> value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem<int>.singleChoice(
      id: 'SETTING_9',
      leading: Icon(Icons.settings),
      label: 'Single Choice',
      //statusTextBuilder: (context, Choice<int> choice) => Text('${choice.label}'),
      choices: <Choice<int>>[
        Choice(label: 'Опция 1', value: 1),
        Choice(label: 'Опция 2', value: 2),
        Choice(label: 'Опция 3', value: 3),
        Choice(label: 'Опция 4', value: 4),
      ],
      initialValue: 1,
      onChanged: (int value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.dateTime(
      id: 'SETTINGS_10',
      leading: Icon(Icons.settings),
      label: 'DateTime',
      initialValue: DateTime(2020),
      //statusTextBuilder: (context, value) => Text(value.toIso8601String()),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.toggleSwitch(
      id: 'SETTING_11',
      leading: Icon(Icons.settings),
      label: 'Toggle Switch 16',
      initialValue: true,
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
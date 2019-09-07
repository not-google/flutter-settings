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
      secondaryText: 'IndividualSwitch',
      defaultValue: true,
      //enabled: true,
      activeBuilder: (context) => Text('АКТИВНО'),
      inactiveBuilder: (context) => Text('НЕАКТИВНО'),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.masterSwitch(
        id: 'SETTING_2',
        leading: Icon(Icons.settings),
        label: 'Master Switch',
        secondaryText: 'MasterSwitch',
        defaultValue: true,
        onChanged: (value) => print('value: $value'),
        //enabled: true,
        group: <SettingsMenuItem>[
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.1',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch',
            defaultValue: true,
            secondaryText: 'Описание настройки',
          ),
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.2',
            leading: Icon(Icons.settings),
            label: 'Toggle Switch',
            defaultValue: false,
            secondaryText: 'Описание настройки',
          ),
          SettingsMenuItem.section(
            title: 'Section',
            group: <SettingsMenuItem>[
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.1',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch',
                defaultValue: true,
                secondaryText: 'Описание настройки',
              ),
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.2',
                leading: Icon(Icons.settings),
                label: 'Toggle Switch',
                defaultValue: false,
                secondaryText: 'Описание настройки',
              ),
            ],
          )
        ],
        inactiveBuilder: (context) => Text('Текст неактивного состояния')
    ),
    SettingsMenuItem.dependency(
      id: 'SETTING_3',
      leading: Icon(Icons.settings),
      label: 'Dependency',
      secondaryText: 'Состояние зависимостей',
      defaultValue: true,
      onChanged: (value) => print('value: $value'),
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch',
          defaultValue: true,
          secondaryText: 'Описание настройки',
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch',
          defaultValue: true,
          secondaryText: 'Описание настройки',
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.section(
          title: 'Section 1',
          group: <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: true,
              secondaryText: 'Описание настройки',
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: false,
              secondaryText: 'Описание настройки',
            ),
          ],
        )
      ],
    ),
//    SettingsMenuItem.toggleSwitch(
//      id: 'SETTING_3.3.1',
//      leading: Icon(Icons.settings),
//      label: 'Toggle Switch',
//      defaultValue: true,
//      secondaryText: 'Описание настройки',
//    ),
    SettingsMenuItem.section(
      title: 'Section 2',
      group: <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.1',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch',
          defaultValue: true,
          secondaryText: 'Описание настройки',
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.2',
          leading: Icon(Icons.settings),
          label: 'Toggle Switch',
          defaultValue: false,
          secondaryText: 'Описание настройки',
        ),
      ],
    ),
    SettingsMenuItem.slider(
      id: 'SETTING_5',
      leading: Icon(Icons.settings),
      label: 'Slider',
      secondaryText: 'Страница настроек',
      defaultValue: 0,
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.listSubscreen(
      label: 'List Subscreen',
      leading: Icon(Icons.settings),
      secondaryText: 'Страница настроек',
      group: [
        SettingsMenuItem.listSubscreen(
          label: 'List Subscreen Item 1',
          leading: Icon(Icons.settings),
          secondaryText: 'Страница настроек',
          group: [
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: true,
              secondaryText: 'Описание настройки',
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: false,
              secondaryText: 'Описание настройки',
            ),
          ],
        ),
        SettingsMenuItem.listSubscreen(
          label: 'List Subscreen Item 2',
          leading: Icon(Icons.settings),
          secondaryText: 'Страница настроек',
          group: [
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.1',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: true,
              secondaryText: 'Описание настройки',
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.2',
              leading: Icon(Icons.settings),
              label: 'Toggle Switch',
              defaultValue: false,
              secondaryText: 'Описание настройки',
            ),
          ],
        )
      ],
    ),
    SettingsMenuItem.multipleChoice(
      id: 'SETTING_8',
      leading: Icon(Icons.settings),
      label: 'Multiple Choice',
      secondaryText: 'Несколько из списка',
      options: <SelectionOption>[
        SelectionOption(label: 'Опция 1', value: 1),
        SelectionOption(label: 'Опция 2', value: 2),
        SelectionOption(label: 'Опция 3', value: 3),
        SelectionOption(label: 'Опция 4', value: 4),
      ],
      defaultValue: [1, 3],
      onChanged: (value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.singleChoice(
      id: 'SETTING_9',
      leading: Icon(Icons.settings),
      label: 'Single Choice',
      secondaryText: 'Один из списка',
      options: <SelectionOption>[
        SelectionOption(label: 'Опция 1', value: 1),
        SelectionOption(label: 'Опция 2', value: 2),
        SelectionOption(label: 'Опция 3', value: 3),
        SelectionOption(label: 'Опция 4', value: 4),
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
      secondaryText: 'Дата и время',
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.toggleSwitch(
      id: 'SETTING_11',
      leading: Icon(Icons.settings),
      label: 'Toggle Switch',
      defaultValue: true,
      secondaryText: 'Описание настройки',
      onChanged: (value) => print('value: $value'),
    )
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<SettingsMenuItem> settings = _getSettings(context);

    return MaterialApp(
      home: SettingsScaffold(
        title: Text('Settings'),
        settings: settings,
        helpBuilder: (context) => Text('Help Message'),
      ),
    );
  }
}
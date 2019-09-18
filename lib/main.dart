import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  List<SettingsMenuItem> _itemBuilder(BuildContext context) => [
    SettingsMenuItem.individualSwitch(
      id: 'SETTING_1',
      leading: Icon(Icons.settings),
      label: 'Individual Switch',
      description: Text('Очень длинное описание, которое разьясняет назначение данной настройки'),
      initialValue: true,
      enabled: true,
      onChanged: (value) => print('value: $value'),
      pageBuilder: _buildPage,
    ),
    SettingsMenuItem.masterSwitch(
        id: 'SETTING_2',
        leading: Icon(Icons.settings),
        label: 'Master Switch',
        masterSwitchTitle: Text('Use Master Switch'),
        //statusTextBuilder: (_, isActive) => isActive ? Text('On') : Text('Status Off'),
        inactiveTextBuilder: (context) => Text('Текст неактивного состояния'),
        initialValue: true,
        duplicateSwitchInMenuItem: true,
        onChanged: (bool value) => print('value: $value'),
        //enabled: true,
        //pageBuilder: _buildPage,
        itemBuilder: (context) => <SettingsMenuItem>[
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
            title: Text('Section'),
            itemBuilder: (context) =>  <SettingsMenuItem>[
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
      itemBuilder: (context) => <SettingsMenuItem>[
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
          title: Text('Section 1'),
          itemBuilder: (context) => <SettingsMenuItem>[
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
      title: Text('Section 2'),
      itemBuilder: (context) => <SettingsMenuItem>[
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
      min: 0,
      max: 100,
      onChangeEnd: (double value) => print('value: $value'),
    ),
    SettingsMenuItem.listSubscreen(
      label: 'List Subpage',
      leading: Icon(Icons.settings),
      secondaryText: Text('Страница настроек'),
      pageBuilder: _buildPage,
      itemBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.listSubscreen(
          label: 'List Subpage Item 1',
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          pageBuilder: _buildPage,
          itemBuilder: (context) => <SettingsMenuItem>[
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
          label: 'List Subpage Item 2',
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          pageBuilder: _buildPage,
          itemBuilder: (context) => <SettingsMenuItem>[
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
      initialValue: <int>[1, 3],
      onChanged: (List<int> value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem<int>.singleChoice(
      id: 'SETTING_9',
      leading: Icon(Icons.settings),
      label: 'Single Choice',
      //statusTextBuilder: (context, Choice<int> choice) => Text('${choice.label}'),
      pageBuilder: _buildPage,
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
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
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
    ),
  ];

  Widget _buildPage(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => null
          )
        ],
      ),
      body: body
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: SettingsPage(
        title: Text('Settings'),
        itemBuilder: _itemBuilder,
        builder: _buildPage,
      ),
    );
  }
}
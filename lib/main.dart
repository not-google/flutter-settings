import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  List<SettingsMenuItem> _groupBuilder(BuildContext context) => [
    SettingsMenuItem.individualSwitch(
      id: 'SETTING_1',
      leading: Icon(Icons.settings),
      label: Text('Individual Switch'),
      description: Text('Очень длинное описание, которое разьясняет назначение данной настройки'),
      initialValue: true,
      enabled: true,
      onChanged: (value) => print('value: $value'),
      //pageBuilder: _buildPage,
    ),
    SettingsMenuItem.masterSwitch(
        id: 'SETTING_2',
        leading: Icon(Icons.settings),
        label: Text('Master Switch'),
        //masterSwitchTitle: Text('Use Master Switch'),
        //statusTextBuilder: (_, isActive) => isActive ? Text('On') : Text('Status Off'),
        inactiveTextBuilder: (context) => Text('Текст неактивного состояния'),
        initialValue: false,
        showDuplicateSwitch: true,
        onChanged: (bool value) => print('value: $value'),
        //enabled: true,
        //pageBuilder: _buildPage,
        groupBuilder: (context) => <SettingsMenuItem>[
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.1',
            leading: Icon(Icons.settings),
            label: Text('Toggle Switch 1'),
            initialValue: true,
            secondaryText: Text('Описание настройки'),
            onChanged: (value) => print(value),
          ),
          SettingsMenuItem.toggleSwitch(
            id: 'SETTING_2.2',
            leading: Icon(Icons.settings),
            label: Text('Toggle Switch 2'),
            initialValue: false,
            secondaryText: Text('Описание настройки'),
          ),
          SettingsMenuItem.section(
            title: Text('Section'),
            groupBuilder: (context) =>  <SettingsMenuItem>[
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.1',
                leading: Icon(Icons.settings),
                label: Text('Toggle Switch 3'),
                initialValue: true,
                secondaryText: Text('Описание настройки'),
              ),
              SettingsMenuItem.toggleSwitch(
                id: 'SETTING_3.3.2',
                leading: Icon(Icons.settings),
                label: Text('Toggle Switch 4'),
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
      label: Text('Dependency'),
      secondaryTextBuilder: (context, enabled) => enabled
          ? Text('Зависимости доступны')
          : Text('Зависимости не доступны'),
      initialValue: true,
      onChanged: (value) => print('value: $value'),
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.1',
          leading: Icon(Icons.settings),
          label: Text('Toggle Switch 5'),
          initialValue: true,
          secondaryText: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_3.2',
          leading: Icon(Icons.settings),
          label: Text('Toggle Switch 6'),
          initialValue: true,
          secondaryText: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.section(
          title: Text('Section 1'),
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.1',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 7'),
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_3.3.2',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 8'),
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
//      label: Text('Toggle Switch 9'),
//      initialValue: true,
//      secondaryText: Text('Описание настройки'),
//    ),
    SettingsMenuItem.section(
      title: Text('Section 2'),
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.1',
          leading: Icon(Icons.settings),
          label: Text('Toggle Switch 10'),
          initialValue: true,
          secondaryText: Text('Описание настройки'),
        ),
        SettingsMenuItem.toggleSwitch(
          id: 'SETTING_4.2',
          leading: Icon(Icons.settings),
          label: Text('Toggle Switch 11'),
          initialValue: false,
          secondaryText: Text('Описание настройки'),
        ),
      ],
    ),
    SettingsMenuItem.slider(
      id: 'SETTING_5',
      leading: Icon(Icons.settings),
      label: Text('Slider'),
      secondaryText: Text('Страница настроек'),
      initialValue: 0,
      min: 0,
      max: 100,
      onChangeEnd: (double value) => print('value: $value'),
    ),
    SettingsMenuItem.listSubpage(
      id: 'ListSubpage',
      label: Text('List Subpage'),
      leading: Icon(Icons.settings),
      secondaryText: Text('Страница настроек'),
      pageBuilder: _buildPage,
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.listSubpage(
          id: 'ListSubpageItem1',
          label: Text('List Subpage Item 1'),
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          pageBuilder: _buildPage,
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.1',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 12'),
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_6.2',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 13'),
              initialValue: false,
              secondaryText: Text('Описание настройки'),
            ),
          ],
        ),
        SettingsMenuItem.listSubpage(
          id: 'ListSubpageItem2',
          label: Text('List Subpage Item 2'),
          leading: Icon(Icons.settings),
          secondaryText: Text('Страница настроек'),
          pageBuilder: _buildPage,
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.1',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 14'),
              initialValue: true,
              secondaryText: Text('Описание настройки'),
            ),
            SettingsMenuItem.toggleSwitch(
              id: 'SETTING_7.2',
              leading: Icon(Icons.settings),
              label: Text('Toggle Switch 15'),
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
      label: Text('Multiple Choice'),
//      statusTextBuilder: (context, List<Choice<int>> choices) {
//        if (choices.isEmpty) return Text('Not Chosen');
//        String labels = choices.map((choice) => choice.label).join(', ');
//        return Text('$labels');
//      },
      choices: <Choice<int>>[
        Choice(label: Text('Опция 1'), secondaryText: Text('Описание опции'), value: 1),
        Choice(label: Text('Опция 2'), value: 2),
        Choice(label: Text('Опция 3'), value: 3),
        Choice(label: Text('Опция 4'), value: 4),
      ],
      initialValue: <int>[1, 3],
      onChanged: (List<int> value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem<int>.singleChoice(
      id: 'SETTING_9',
      leading: Icon(Icons.settings),
      label: Text('Single Choice'),
      //statusTextBuilder: (context, Choice<int> choice) => Text('${choice.label}'),
      pageBuilder: _buildPage,
      choices: <Choice<int>>[
        Choice(label: Text('Опция 1'), value: 1),
        Choice(label: Text('Опция 2'), secondaryText: Text('Описание опции'), value: 2),
        Choice(label: Text('Опция 3'), value: 3),
        Choice(label: Text('Опция 4'), value: 4),
      ],
      initialValue: 1,
      onChanged: (int value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.dateTime(
      id: 'SETTINGS_10',
      leading: Icon(Icons.settings),
      label: Text('DateTime'),
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
      initialDate: DateTime(2020),
      //statusTextBuilder: (context, value) => Text(value.toIso8601String()),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.toggleSwitch(
      id: 'SETTING_11',
      leading: Icon(Icons.settings),
      label: Text('Toggle Switch 16'),
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
      routes: {
        Home.routeName: (context) => Home(),
        SettingsPage.routeName: (context) => SettingsPage(
          title: Text('Settings'),
          groupBuilder: _groupBuilder,
          //builder: _buildPage,
        )
      },
      initialRoute: SettingsPage.routeName,
      theme: ThemeData.light(),
    );
  }
}

class Home extends StatelessWidget {
  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('SHOW SETTINGS'),
          onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
        ),
      ),
    );
  }
}
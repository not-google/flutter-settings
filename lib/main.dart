import 'package:flutter/material.dart';
import 'settings.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  List<SettingsMenuItem> _groupBuilder(BuildContext context) => <SettingsMenuItem>[
    SettingsMenuItem.individualSwitch(
      key: Key('SETTING_1'),
      leading: Icon(Icons.settings),
      title: Text('Individual Switch'),
      description: Text('Очень длинное описание, которое разьясняет назначение данной настройки'),
      defaultValue: true,
      enabled: false,
      onChanged: (value) => print('value: $value'),
      //pageBuilder: _buildPage,
    ),
    SettingsMenuItem.masterSwitch(
        key: Key('SETTING_2'),
        leading: Icon(Icons.settings),
        title: Text('Master Switch'),
        //masterSwitchTitle: Text('Use Master Switch'),
        //statusTextBuilder: (_, isActive) => isActive ? Text('On') : Text('Status Off'),
        inactiveBuilder: (context) => Text('Текст неактивного состояния'),
        defaultValue: false,
        duplicateSwitch: true,
        onChanged: (bool value) => print('value: $value'),
        //enabled: true,
        //pageBuilder: _buildPage,
        groupBuilder: (context) => <SettingsMenuItem>[
          SettingsMenuItem.simpleSwitch(
            key: Key('SETTING_2.1'),
            leading: Icon(Icons.settings),
            title: Text('Simple Switch 1'),
            defaultValue: true,
            subtitle: Text('Описание настройки'),
            onChanged: (value) => print(value),
          ),
          SettingsMenuItem.simpleSwitch(
            key: Key('SETTING_2.2'),
            leading: Icon(Icons.settings),
            title: Text('Simple Switch 2'),
            defaultValue: false,
            subtitle: Text('Описание настройки'),
          ),
          SettingsMenuItem.section(
            key: Key('SETTINGS_SECTION'),
            title: Text('Section'),
            groupBuilder: (context) =>  <SettingsMenuItem>[
              SettingsMenuItem.simpleSwitch(
                key: Key('SETTING_3.3.1'),
                leading: Icon(Icons.settings),
                title: Text('Simple Switch 3'),
                defaultValue: true,
                subtitle: Text('Описание настройки'),
              ),
              SettingsMenuItem.simpleSwitch(
                key: Key('SETTING_3.3.2'),
                leading: Icon(Icons.settings),
                title: Text('Simple Switch 4'),
                defaultValue: false,
                subtitle: Text('Описание настройки'),
              ),
            ],
          )
        ],
    ),
    SettingsMenuItem.dependency(
      key: Key('SETTING_3'),
      leading: Icon(Icons.settings),
      title: Text('Dependency'),
      statusTextBuilder: (context, enabled) => enabled
          ? Text('Зависимости доступны')
          : Text('Зависимости не доступны'),
      defaultValue: true,
      onChanged: (value) => print('value: $value'),
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.custom(
          key: Key('SETTINGS_BUILDER'),
          title: Text('Builder'),
          defaultValue: '5',
          builder: (context, widget) {
            return ListTile(
              title: widget.title,
              subtitle: Text(widget.enabled ? 'Enabled' : 'Disabled'),
              selected: widget.selected,
            );
          }
        ),
        SettingsMenuItem.simpleSwitch(
          key: Key('SETTING_3.1'),
          leading: Icon(Icons.settings),
          title: Text('Simple Switch 5'),
          defaultValue: true,
          subtitle: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.simpleSwitch(
          key: Key('SETTING_3.2'),
          leading: Icon(Icons.settings),
          title: Text('Simple Switch 6'),
          defaultValue: true,
          enabled: false,
          subtitle: Text('Описание настройки'),
          onChanged: (value) => print('value: $value'),
        ),
        SettingsMenuItem.section(
          key: Key('SETTINGS_SECTION_1'),
          title: Text('Section 1'),
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_3.3.1'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 7'),
              defaultValue: true,
              subtitle: Text('Описание настройки'),
            ),
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_3.3.2'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 8'),
              defaultValue: false,
              subtitle: Text('Описание настройки'),
            ),
          ],
        )
      ],
    ),
//    SettingsMenuItem.simpleSwitch(
//      key: Key('SETTING_3.3.1'),
//      leading: Icon(Icons.settings),
//      title: Text('Simple Switch 9'),
//      defaultValue: true,
//      subtitle: Text('Описание настройки'),
//    ),
    SettingsMenuItem.section(
      key: Key('SETTINGS_SECTION_2'),
      title: Text('Section 2'),
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.simpleSwitch(
          key: Key('SETTING_4.1'),
          leading: Icon(Icons.settings),
          title: Text('Simple Switch 10'),
          defaultValue: true,
          subtitle: Text('Описание настройки'),
        ),
        SettingsMenuItem.simpleSwitch(
          key: Key('SETTING_4.2'),
          leading: Icon(Icons.settings),
          title: Text('Simple Switch 11'),
          defaultValue: false,
          subtitle: Text('Описание настройки'),
        ),
      ],
    ),
    SettingsMenuItem.slider(
      key: Key('SETTING_5'),
      leading: Icon(Icons.settings),
      title: Text('Slider'),
      subtitle: Text('Страница настроек'),
      defaultValue: 0,
      min: 0,
      max: 100,
      onChangeEnd: (double value) => print('value: $value'),
    ),
    SettingsMenuItem.listSubpage(
      key: Key('ListSubpage'),
      title: Text('List Subpage'),
      leading: Icon(Icons.settings),
      subtitle: Text('Страница настроек'),
      pageBuilder: _buildPage,
      groupBuilder: (context) => <SettingsMenuItem>[
        SettingsMenuItem.listSubpage(
          key: Key('ListSubpageItem1'),
          title: Text('List Subpage Item 1'),
          leading: Icon(Icons.settings),
          subtitle: Text('Страница настроек'),
          pageBuilder: _buildPage,
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_6.1'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 12'),
              defaultValue: true,
              subtitle: Text('Описание настройки'),
            ),
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_6.2'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 13'),
              defaultValue: false,
              subtitle: Text('Описание настройки'),
            ),
          ],
        ),
        SettingsMenuItem.listSubpage(
          key: Key('ListSubpageItem2'),
          title: Text('List Subpage Item 2'),
          leading: Icon(Icons.settings),
          subtitle: Text('Страница настроек'),
          pageBuilder: _buildPage,
          groupBuilder: (context) => <SettingsMenuItem>[
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_7.1'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 14'),
              defaultValue: true,
              subtitle: Text('Описание настройки'),
            ),
            SettingsMenuItem.simpleSwitch(
              key: Key('SETTING_7.2'),
              leading: Icon(Icons.settings),
              title: Text('Simple Switch 15'),
              defaultValue: false,
              subtitle: Text('Описание настройки'),
            ),
          ],
        )
      ],
    ),
    SettingsMenuItem.multipleChoice(
      key: Key('SETTING_8'),
      leading: Icon(Icons.settings),
      title: Text('Multiple Choice'),
//      statusTextBuilder: (context, List<Choice<int>> choices) {
//        if (choices.isEmpty) return Text('Not Chosen');
//        String titles = choices.map((choice) => choice.title).join(', ');
//        return Text('$titles');
//      },
      choices: <Choice>[
        Choice(title: Text('Опция 1'), subtitle: Text('Описание опции'), value: '1'),
        Choice(title: Text('Опция 2'), value: '2'),
        Choice(title: Text('Опция 3'), value: '3'),
        Choice(title: Text('Опция 4'), value: '4'),
      ],
      defaultValue: ['1', '3'],
      onChanged: (List<String> value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.singleChoice(
      key: Key('SETTING_9'),
      leading: Icon(Icons.settings),
      title: Text('Single Choice'),
      //statusTextBuilder: (context, Choice<int> choice) => Text('${choice.title}'),
      pageBuilder: _buildPage,
      choices: <Choice>[
        Choice(title: Text('Опция 1'), value: '1'),
        Choice(title: Text('Опция 2'), subtitle: Text('Описание опции'), value: '2'),
        Choice(title: Text('Опция 3'), value: '3'),
        Choice(title: Text('Опция 4'), value: '4'),
      ],
      defaultValue: '1',
      onChanged: (String value) => print('value: $value'),
      //enabled: false
    ),
    SettingsMenuItem.time(
      key: Key('SETTINGS_TIME'),
      leading: Icon(Icons.settings),
      title: Text('Time'),
      defaultValue: TimeOfDay(hour: 6, minute: 0),
      enabled: true,
      //statusTextBuilder: (context, value) => Text(value.toIso8601String()),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.date(
      key: Key('SETTINGS_DATE'),
      leading: Icon(Icons.settings),
      title: Text('Date'),
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
      defaultValue: DateTime(2020),
      enabled: true,
      //statusTextBuilder: (context, value) => Text(value.toIso8601String()),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.dateTime(
      key: Key('SETTINGS_DATETIME'),
      leading: Icon(Icons.settings),
      title: Text('DateTime'),
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
      defaultValue: DateTime(2020),
      enabled: true,
      //statusTextBuilder: (context, value) => Text(value.toIso8601String()),
      onChanged: (value) => print('value: $value'),
    ),
    SettingsMenuItem.simpleSwitch(
      key: Key('SETTING_11'),
      leading: Icon(Icons.settings),
      title: Text('Simple Switch 16'),
      defaultValue: true,
      enabled: true,
      subtitle: Text('Описание настройки'),
      onChanged: (value) => print('value: $value'),
    ),
  ];

  Widget _buildPage(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onShowSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onShowSearch
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
        SettingsPageRoute.routeName: (context) => SettingsPageRoute(
          title: Text('Settings 1'),
          body: SettingsMenu(
            groupBuilder: _groupBuilder,
          ),
          //builder: _buildPage,
        )
      },
      initialRoute: SettingsPageRoute.routeName,
      //theme: ThemeData.dark(),
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
          onPressed: () => Navigator.pushNamed(context, SettingsPageRoute.routeName),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

enum SettingsPatternType {
  section,
  toggleSwitch,
// Selection Patterns
// https://material.io/design/platform-guidance/android-settings.html#selection-patterns
  singleChoice,
  multipleChoice,
  slider,
  dateTime,
  listSubscreen,
  masterSwitch,
  individualSwitch,
  dependency
}

class SelectionOption<T> {
  SelectionOption({
    @required this.label,
    @required this.value
  });

  final String label;
  final T value;
}

abstract class SettingsPatternBase<T> {
  SettingsPatternBase({
    this.id,
    this.sectionTitle,
    this.label,
    this.secondaryText,
    this.group,
    this.options,
    this.defaultValue,
    @required this.patternType,
    @required this.builder
  });

  final String id;
  final String sectionTitle;
  final Iterable<SettingsPattern> group;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final T defaultValue;
  final SettingsPatternType patternType;
  final WidgetBuilder builder;
}

class SettingsPattern<T> extends SettingsPatternBase {
  SettingsPattern.section({
    String title,
    @required Iterable<SettingsPattern> group
  }) : super(
      sectionTitle: title,
      group: group,
      patternType: SettingsPatternType.section,
      builder: (_) => SettingsSection(
        title: title,
        group: group,
      )
  );

  SettingsPattern.toggleSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    bool defaultValue = false
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.toggleSwitch,
      builder: (_) => SettingsToggleSwitch(
        id: id,
        label: label,
        secondaryText: secondaryText,
        defaultValue: defaultValue,
      )
  );

  SettingsPattern.singleChoice({
    @required String id,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    T defaultValue
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.singleChoice,
      builder: (_) => SettingsSingleChoice(
        id: id,
        label: label,
        secondaryText: secondaryText,
        options: options,
        defaultValue: defaultValue,
      )
  );

  SettingsPattern.multipleChoice({
    @required String id,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    List<T> defaultValue
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.multipleChoice,
      builder: (_) => SettingsMultipleChoice(
        id: id,
        label: label,
        secondaryText: secondaryText,
        options: options,
        defaultValue: defaultValue,
      )
  );

  SettingsPattern.slider({
    @required String id,
    @required String label,
    String secondaryText,
    double defaultValue = 0
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.slider,
      builder: (_) => SettingsSlider(
        id: id,
        label: label,
        secondaryText: secondaryText,
        defaultValue: defaultValue,
      )
  );

  SettingsPattern.dateTime({
    @required String id,
    @required String label,
    String secondaryText,
    DateTime defaultValue
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.dateTime,
      builder: (_) => SettingsDateTime(
        id: id,
        label: label,
        secondaryText: secondaryText,
        defaultValue: defaultValue,
      )
  );

  SettingsPattern.listSubscreen({
    @required String label,
    String secondaryText,
    @required Iterable<SettingsPattern> group
  }) : super(
      label: label,
      secondaryText: secondaryText,
      group: group,
      patternType: SettingsPatternType.listSubscreen,
      builder: (_) => SettingsListSubscreen(
        label: label,
        secondaryText: secondaryText,
        group: group
      )
  );

  SettingsPattern.masterSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    bool defaultValue = false
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.masterSwitch,
      builder: (_) => Container()
  );

  SettingsPattern.individualSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    bool defaultValue = false
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.individualSwitch,
      builder: (_) => Container()
  );

  SettingsPattern.dependency({
    @required String id,
    @required String label,
    secondaryText,
    @required Iterable<SettingsPattern> dependent,
    bool defaultValue = false,
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      group: dependent,
      defaultValue: defaultValue,
      patternType: SettingsPatternType.dependency,
      builder: (_) => Container()
  );
}

class Settings extends StatelessWidget {
  Settings({
    Key key,
    @required this.group
  }) : super(key: key);

  final Iterable<SettingsPattern> group;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: (context, index) => group.elementAt(index).builder(context)
    );
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    @required this.title,
    @required this.group,
    this.helpBuilder
  }) : super(key: key);

  final String title;
  final WidgetBuilder helpBuilder;
  final Iterable<SettingsPattern> group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          Visibility(
            visible: helpBuilder != null,
            child: IconButton(
              icon: Icon(Icons.help),
              onPressed: () => showDialog(
                context: context,
                builder: helpBuilder
              )
            )
          ),
          Visibility(
            visible: true,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => null
            )
          )
        ],
      ),
      body: Settings(group: group),
    );
  }
}

class SettingsSection extends StatelessWidget {
  SettingsSection({
    Key key,
    this.title,
    @required this.group
  }) : super(
    key: key
  );

  final String title;
  final Iterable<SettingsPattern> group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 1),
        Column(
          children: group.map(
            (SettingsPattern pattern) => pattern.builder(context)
          ).toList(),
        ),
        Divider(height: 1),
      ],
    );
  }
}

class SettingsToggleSwitch extends StatefulWidget {
  SettingsToggleSwitch({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    this.defaultValue = false
  }) : super(
    key: key
  );

  final String id;
  final String label;
  final String secondaryText;
  final bool defaultValue;

  @override
  _SettingsToggleSwitchState createState() => _SettingsToggleSwitchState();
}
class _SettingsToggleSwitchState extends State<SettingsToggleSwitch> {

  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  _handleChanged(bool value) {
    setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      value: _value,
      onChanged: _handleChanged
    );
  }
}

class SettingsSingleChoice<T> extends StatefulWidget {
  SettingsSingleChoice({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    @required this.options,
    this.defaultValue
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final T defaultValue;

  @override
  _SettingsSingleChoiceState createState() => _SettingsSingleChoiceState();
}
class _SettingsSingleChoiceState<T> extends State<SettingsSingleChoice<T>> {

  T _selectedValue;

  @override
  initState() {
    super.initState();
    _selectedValue = widget.defaultValue;
  }

  _handleChanged(value) {
    print(value);
    setState(() => _selectedValue = value);
  }

  Widget _buildOption(SelectionOption option) {
    return RadioListTile(
      title: Text(option.label),
      value: option.value,
      groupValue: _selectedValue,
      selected: _selectedValue == option.value,
      onChanged: _handleChanged
    );
  }

  Widget _buildDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.label),
      children: widget.options.map(_buildOption).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => showDialog(
        context: context,
        builder: _buildDialog
      ),
    );
  }
}


class SettingsMultipleChoice<T> extends StatefulWidget {
  SettingsMultipleChoice({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    @required this.options,
    this.defaultValue
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final List<T> defaultValue;

  @override
  _SettingsMultipleChoiceState<T> createState() => _SettingsMultipleChoiceState<T>();
}
class _SettingsMultipleChoiceState<T> extends State<SettingsMultipleChoice<T>> {

  List<T> _values;

  @override
  initState() {
    super.initState();
    _values = widget.defaultValue;
  }

  void _check(T value) => setState(() => _values.add(value));
  void _uncheck(T value) => setState(() => _values.remove(value));

  Widget _buildOption(SelectionOption option) {
    bool checked = _values.contains(option.value);
    return CheckboxListTile(
      title: Text(option.label),
      value: checked,
      selected: checked,
      onChanged: (bool checked) => checked ? _check(option.value) : _uncheck(option.value)
    );
  }

  Widget _buildDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.label),
      children: widget.options.map(_buildOption).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => showDialog(
        context: context,
        builder: _buildDialog
      ),
    );
  }
}

class SettingsSlider extends StatefulWidget {
  SettingsSlider({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    this.defaultValue = 0
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final double defaultValue;

  @override
  _SettingsSliderState createState() => _SettingsSliderState();
}
class _SettingsSliderState extends State<SettingsSlider> {

  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(double value) {
    setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Opacity(
            child: CircleAvatar(),
            opacity: 0,
          ),
          Column(
            children: <Widget>[
              Text(widget.label),
              Slider(
                value: _value,
                onChanged: _handleChanged
              )
            ],
          )
        ],
      ),
    );
  }
}

class SettingsDateTime extends StatefulWidget {
  SettingsDateTime({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    this.defaultValue
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final DateTime defaultValue;

  @override
  _SettingsDateTimeState createState() => _SettingsDateTimeState();
}
class _SettingsDateTimeState extends State<SettingsDateTime> {

  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => showDatePicker(
        context: context,
        initialDate: _value,
        firstDate: DateTime(1900),
        lastDate: DateTime(2021)
      ),
    );
  }
}

class SettingsListSubscreen extends StatelessWidget {
  SettingsListSubscreen({
    Key key,
    @required this.label,
    this.secondaryText,
    @required this.group
  }) : super(key: key);

  final String label;
  final String secondaryText;
  final Iterable<SettingsPattern> group;

  Widget _buildSettingsPage(BuildContext context) {
    return SettingsPage(
      title: label,
      group: group
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(label),
      subtitle: secondaryText == null ? null : Text(secondaryText),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: _buildSettingsPage)),
    );
  }
}
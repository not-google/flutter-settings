import 'package:flutter/material.dart';

const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;
const double _kDividerHeight = 1.0;
const List<SettingsMenuItemType> _kScreenSettingsMenuItemTypes = [
  SettingsMenuItemType.listSubscreen,
  SettingsMenuItemType.masterSwitch,
  SettingsMenuItemType.individualSwitch
];
const String statusOnLabel = 'On';
const String statusOffLabel = 'Off';

typedef ValueChangedBuilder<T> = Widget Function(BuildContext context, T value);
typedef MenuItemBuilder = Widget Function(BuildContext context, {
  bool isEnabled,
  bool isSelected
});

enum SettingsMenuItemType {
  toggleSwitch,
  section,
  // Selection Patterns
  singleChoice,
  multipleChoice,
  slider,
  dateTime,
  listSubscreen,
  masterSwitch,
  individualSwitch,
  dependency
}

class Choice<T> {
  Choice({
    @required this.label,
    @required this.value
  });

  final String label;
  final T value;
}

abstract class SettingsMenuEntry<T> extends StatelessWidget {
  SettingsMenuEntry({
    Key key,
    this.label,
    this.group,
    @required this.builder,
    @required this.type
  });

  final String label;
  final List<SettingsMenuItem> group;
  final MenuItemBuilder builder;
  final SettingsMenuItemType type;
}

class SettingsMenuItem<T> extends SettingsMenuEntry {
//  SettingsMenuItem._(SettingsMenuItem item, {
//    Key key,
//    SettingsMenuItem previous,
//    List<SettingsMenuItem> group,
//    bool enabled,
//    bool selected,
//    bool showTopDivider,
//    bool showBottomDivider
//  }) : super(
//    key: key,
//    id: item.id,
//    leading: item.leading,
//    masterSwitchTitle: item.masterSwitchTitle,
//    activeSecondaryTextBuilder: item.activeSecondaryTextBuilder,
//    inactiveSecondaryTextBuilder: item.inactiveSecondaryTextBuilder,
//    label: item.label,
//    sectionTitle: item.sectionTitle,
//    secondaryText: item.secondaryText,
//    group: group ?? item.group,
//    choices: item.choices,
//    initialValue: item.initialValue,
//    inactiveTextBuilder: item.inactiveTextBuilder,
//    showTopDivider: showTopDivider ?? _needShowTopDivider(item, previous),
//    showBottomDivider: showBottomDivider ?? _needShowBottomDivider(item),
//    enabled: enabled ?? item.enabled,
//    onChanged: item.onChanged,
//    selected: selected ?? item.selected,
//    type: item.type
//  );

  SettingsMenuItem.toggleSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => ToggleSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.toggleSwitch,
  );

  SettingsMenuItem.section({
    Key key,
    String title,
    @required List<SettingsMenuItem> group,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => SectionMenuItem(
      title: title,
      group: group,
      enabled: isEnabled ?? enabled
    ),
    group: group,
    type: SettingsMenuItemType.section,
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required List<Choice<T>> choices,
    @required T initialValue,
    bool enabled = true,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => SingleChoiceMenuItem<T>(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      choices: choices,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.singleChoice,
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required List<Choice<T>> choices,
    @required List<T> initialValue,
    bool enabled = true,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => MultipleChoiceMenuItem<T>(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      choices: choices,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.multipleChoice
  );

  SettingsMenuItem.slider({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required double initialValue,
    bool enabled = true,
    ValueChanged<double> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => SliderMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.slider
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    DateTime initialValue,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => DateTimeMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.dateTime
  );

  SettingsMenuItem.listSubscreen({
    Key key,
    @required String label,
    Widget leading,
    Widget secondaryText,
    @required List<SettingsMenuItem> group,
    bool enabled = true
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => ListSubscreenMenuItem(
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      group: group,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
    ),
    label: label,
    group: group,
    type: SettingsMenuItemType.listSubscreen
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    @required Widget masterSwitchTitle,
    @required ValueChangedBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveTextBuilder,
    List<SettingsMenuItem> group,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => MasterSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      masterSwitchTitle: masterSwitchTitle,
      statusTextBuilder: statusTextBuilder,
      inactiveTextBuilder: inactiveTextBuilder,
      group: group,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    group: group,
    type: SettingsMenuItemType.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    @required Widget secondaryText,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => IndividualSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required List<SettingsMenuItem> group,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, {isEnabled, isSelected}) => DependencyMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      group: group,
      initialValue: initialValue,
      enabled: isEnabled ?? enabled,
      selected: isSelected ?? false,
      onChanged: onChanged,
    ),
    label: label,
    group: group,
    type: SettingsMenuItemType.dependency
  );

  @override
  Widget build(BuildContext context) => builder(context);
}

class Settings<T> extends StatelessWidget {
  Settings(this.group, {
    Key key,
    this.enabled
  }) : super(key: key);

  final List<SettingsMenuItem<T>> group;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: (context, index) => group[index].builder(context)
    );
  }
}

class SettingsScaffold extends StatelessWidget {
  SettingsScaffold({
    Key key,
    @required this.title,
    @required this.settings,
    this.helpBuilder
  }) : super(key: key);

  final Widget title;
  final WidgetBuilder helpBuilder;
  final List<SettingsMenuItem> settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          Visibility(
            visible: true,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                context: context,
                delegate: _SettingsSearchDelegate(
                  data: settings
                )
              )
            )
          ),
          Visibility(
            visible: helpBuilder != null,
            child: IconButton(
              icon: Icon(Icons.help),
              onPressed: () => showDialog(
                context: context,
                builder: helpBuilder
              )
            )
          )
        ],
      ),
      body: Settings(settings),
    );
  }
}

class SectionMenuItem extends StatelessWidget {
  SectionMenuItem({
    Key key,
    this.title,
    @required this.group,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  final String title;
  final List<SettingsMenuItem> group;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;

  Widget _buildTitle(BuildContext context) {
    return title == null ? Container() : Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style:  Theme.of(context).textTheme.body2.copyWith(
          color: Theme.of(context).primaryColor
        )
      ),
      padding: const EdgeInsets.only(
        left: 72.0,
        right: 16.0,
        top: 16.0,
        bottom: 8.0
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: group.map(
        (item) => item.builder(context, isEnabled: enabled)
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        showTopDivider ? Divider(height: _kDividerHeight) : Container(),
        _buildTitle(context),
        _buildContent(context),
        showBottomDivider ? Divider(height: _kDividerHeight) : Container(),
      ],
    );
  }

//  static bool _needShowTopDivider(SettingsMenuItem item, SettingsMenuItem previous) {
//    if (previous != null && item.type == SettingsMenuItemType.section) {
//      bool isDependencyMenuItemWithLastSectionMenuItemItemInPrevious =
//          previous.type == SettingsMenuItemType.dependency &&
//              previous.group != null && previous.group.isNotEmpty &&
//              previous.group.last.type == SettingsMenuItemType.section;
//      bool isSectionMenuItemPrevious = previous.type == SettingsMenuItemType.section;
//
//      return !isDependencyMenuItemWithLastSectionMenuItemItemInPrevious && !isSectionMenuItemPrevious;
//    }
//
//    return null;
//  }
//
//  static bool _needShowBottomDivider(SettingsMenuItem item) {
//    return item.type == SettingsMenuItemType.section ? true : null;
//  }
}

class ToggleSwitchMenuItem extends StatefulWidget {
  ToggleSwitchMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final bool initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  _ToggleSwitchMenuItemState createState() => _ToggleSwitchMenuItemState();
}
class _ToggleSwitchMenuItemState extends State<ToggleSwitchMenuItem> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(bool newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: widget.secondaryText,
      value: _value,
      selected: widget.selected,
      onChanged: widget.enabled ? _handleChanged : null
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    this.title,
    this.content,
    this.contentPadding = const EdgeInsets.only(top: 16.0),
    this.confirmationText = 'Done',
    this.onConfirm
  });

  final Widget title;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final String confirmationText;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      contentPadding: contentPadding,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(confirmationText)
        )
      ]
    );
  }
}

class SingleChoiceMenuItem<T> extends StatelessWidget {
  SingleChoiceMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    @required this.choices,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final List<Choice<T>> choices;
  final T initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged onChanged;

  Widget _buildSettingsScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: SingleChoiceMenuItemControl<T>(
        choices: choices,
        initialValue: initialValue,
        onChanged: onChanged,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: secondaryText,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class SingleChoiceMenuItemControl<T> extends StatefulWidget {
  SingleChoiceMenuItemControl({
    Key key,
    @required this.choices,
    this.initialValue,
    this.onChanged
  }) : super(key: key);

  final List<Choice<T>> choices;
  final T initialValue;
  final ValueChanged<T> onChanged;

  @override
  _SingleChoiceMenuItemControlState createState() => _SingleChoiceMenuItemControlState();
}
class _SingleChoiceMenuItemControlState<T> extends State<SingleChoiceMenuItemControl<T>> {
  T _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(newValue) {
    setState(() {
      _value = newValue;
    });

    if (widget.onChanged != null) widget.onChanged(newValue);
  }

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = widget.choices[index];
    return RadioListTile(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(option.label),
      value: option.value,
      groupValue: _value,
      selected: _value == option.value,
      onChanged: _handleChanged,
      controlAffinity: ListTileControlAffinity.trailing
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.choices.length,
      itemBuilder: _buildRadioListTile
    );
  }
}

class MultipleChoiceMenuItem<T> extends StatelessWidget {
  MultipleChoiceMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    @required this.choices,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final secondaryText;
  final List<Choice<T>> choices;
  final List<T> initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<T> onChanged;


  Widget _buildAlertDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(label),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: choices.length * _kListTileHeight,
        child: MultipleChoiceMenuItemControl(
          choices: choices,
          initialValue: initialValue,
          onChanged: onChanged
        ),
      ),
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: secondaryText,
      onTap: () => showDialog(
        context: context,
        builder: _buildAlertDialog
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class MultipleChoiceMenuItemControl<T> extends StatefulWidget {
  MultipleChoiceMenuItemControl({
    Key key,
    @required this.choices,
    @required this.initialValue,
    this.onChanged
  }) : super(key: key);

  final List<Choice> choices;
  final List<T> initialValue;
  final ValueChanged onChanged;

  @override
  _MultipleChoiceMenuItemControlState<T> createState() => _MultipleChoiceMenuItemControlState();
}
class _MultipleChoiceMenuItemControlState<T> extends State<MultipleChoiceMenuItemControl<T>> {
  List<T> _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(List<T> newValue) {
    if (widget.onChanged != null) widget.onChanged(_value);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    Choice option = widget.choices[index];
    bool checked = _value.contains(option.value);
    return CheckboxListTile(
      title: Text(option.label),
      value: checked,
      selected: checked,
      onChanged: (bool isChecked) {
        isChecked ? _value.add(option.value) : _value.remove(option.value);
        _handleChanged(_value);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.choices.length,
      itemBuilder: _buildCheckboxListTile
    );
  }
}

class SliderMenuItem extends StatefulWidget {
  SliderMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final double initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<double> onChanged;

  @override
  _SliderState createState() => _SliderState();
}
class _SliderState extends State<SliderMenuItem> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(double newValue) {
    if (widget.onChanged != null) widget.onChanged(_value);

    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliderListTile(
      secondary: widget.leading ?? Icon(null),
      title: Text(widget.label),
      value: _value,
      selected: widget.selected,
      onChanged: widget.enabled ? _handleChanged : null,
    );
  }
}

class SliderListTile extends StatelessWidget {
  const SliderListTile({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.title,
    this.trailing,
    this.dense,
    this.secondary,
    this.selected
  }) : assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0),
        super(key: key);

  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final Color activeColor;
  final Color inactiveColor;
  final Widget title;
  final Widget trailing;
  final Widget secondary;
  final bool dense;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    bool enabled = onChanged != null || onChangeStart != null || onChangeEnd != null;
    return Stack(
      children: <Widget>[
        ListTile(
          leading: secondary,
          title: title,
          subtitle: Text(''),
          trailing: trailing,
          dense: dense,
          selected: selected,
          enabled: enabled,
        ),
        Positioned(
          top: title == null ? 12 : 24,
          left: secondary == null ? 0 : _kSecondaryWidth,
          right: trailing == null ? 0 : _kSecondaryWidth,
          child: Slider(
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
          )
        )
      ],
    );
  }
}

class DateTimeMenuItem extends StatefulWidget {
  DateTimeMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final DateTime initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<DateTime> onChanged;

  @override
  _DateTimeMenuItemState createState() => _DateTimeMenuItemState();
}
class _DateTimeMenuItemState extends State<DateTimeMenuItem> {
  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? null;
  }

  void _handleChanged(DateTime newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  Future<Null> _selectDate() async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );

    if (selectedDate != null && selectedDate != _value)
      _handleChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: widget.secondaryText,
      onTap: _selectDate,
      selected: widget.selected,
      enabled: widget.enabled,
    );
  }
}

class ListSubscreenMenuItem extends StatelessWidget {
  ListSubscreenMenuItem({
    Key key,
    @required this.label,
    this.leading,
    this.secondaryText,
    @required this.group,
    this.enabled = true,
    this.selected = false
  }) : super(key: key);

  final String label;
  final Widget leading;
  final Widget secondaryText;
  final List<SettingsMenuItem> group;
  final bool enabled;
  final bool selected;
  
  Widget _buildSettingsScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Settings(group),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: secondaryText,
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class DependencyMenuItem extends StatefulWidget {
  DependencyMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.secondaryText,
    @required this.group,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged  
  }) : super(key: key);
  
  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final List<SettingsMenuItem> group;
  final bool initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  
  @override
  _DependencyMenuItemState createState() => _DependencyMenuItemState();
}
class _DependencyMenuItemState extends State<DependencyMenuItem> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(bool newValue) {
    setState(() {
      _value = newValue;
    });
  }

  Widget _buildDependent(BuildContext context) {
    return Column(
      children: widget.group.map(
        (item) => item.builder(context, isEnabled: _value)
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: widget.leading ?? Icon(null),
          title: Text(widget.label),
          subtitle: widget.secondaryText,
          value: _value,
          onChanged: widget.enabled ? _handleChanged : null,
          selected: widget.selected,
        ),
        _buildDependent(context)
      ],
    );
  }
}

class MasterSwitchMenuItem extends StatefulWidget {
  MasterSwitchMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    @required this.masterSwitchTitle,
    @required this.statusTextBuilder,
    @required this.inactiveTextBuilder,
    this.group,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget masterSwitchTitle;
  final ValueChangedBuilder<bool> statusTextBuilder;
  final WidgetBuilder inactiveTextBuilder;
  final List<SettingsMenuItem> group;
  final bool initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  
  @override
  _MasterSwitchMenuItemState createState() => _MasterSwitchMenuItemState();
}
class _MasterSwitchMenuItemState extends State<MasterSwitchMenuItem> {
  bool _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(bool newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);
    setState(() {
      _value = newValue;
    });
  }

  Widget _buildActive(BuildContext context) {
    return Settings(widget.group);
  }

  Widget _buildInactive(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(
        left: 72,
        right: 16.0,
        top: 16.0,
        bottom: 16.0
      ),
      child: widget.inactiveTextBuilder(context),
    );
  }

  Widget _buildSettingsScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: MasterSwitchMenuItemControl(
        title: widget.masterSwitchTitle,
        value: _value,
        onChanged: _handleChanged,
        activeBuilder: _buildActive,
        inactiveBuilder: _buildInactive
      )
    );
  }

  Widget _buildSecondaryText(BuildContext context) {
    return widget.statusTextBuilder(context, _value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: _buildSecondaryText(context),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      trailing: Switch(
        value: _value,
        onChanged: _handleChanged,
      ),
      selected: widget.selected,
      enabled: widget.enabled,
    );
  }
}

class MasterSwitchMenuItemControl extends StatefulWidget {
  MasterSwitchMenuItemControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.onChanged,
    @required this.activeBuilder,
    @required this.inactiveBuilder
  }) : super(key: key);

  final Widget title;
  final bool value;
  final WidgetBuilder activeBuilder;
  final WidgetBuilder inactiveBuilder;
  final ValueChanged<bool> onChanged;

  @override
  _MasterSwitchMenuItemControlState createState() => _MasterSwitchMenuItemControlState();
}
class _MasterSwitchMenuItemControlState extends State<MasterSwitchMenuItemControl> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _handleChanged(bool newValue) {
    widget.onChanged(newValue);
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: widget.title,
      value: _value,
      contentBuilder: _value ? widget.activeBuilder : widget.inactiveBuilder,
      onChanged: _handleChanged,
    );
  }
}

class IndividualSwitchMenuItem extends StatefulWidget {
  IndividualSwitchMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    @required this.secondaryText,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);
  
  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final bool initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  
  @override
  _IndividualSwitchMenuItemState createState() => _IndividualSwitchMenuItemState();
}
class _IndividualSwitchMenuItemState extends State<IndividualSwitchMenuItem> {
  bool _value;
  String get _turnedLabel => _value ? statusOnLabel : statusOffLabel;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(bool newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);
    setState(() {
      _value = newValue;
    });
  }

  Widget _buildSettingsScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: IndividualSwitchMenuItemControl(
        activeTitleBuilder: (context) => Text(statusOnLabel),
        inactiveTitleBuilder: (context) => Text(statusOffLabel),
        initialValue: _value,
        secondaryText: widget.secondaryText,
        onChanged: _handleChanged,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: Text(_turnedLabel),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      selected: widget.selected,
      enabled: widget.enabled,
    );
  }
}

class IndividualSwitchMenuItemControl extends StatefulWidget {
  IndividualSwitchMenuItemControl({
    Key key,
    @required this.activeTitleBuilder,
    @required this.inactiveTitleBuilder,
    @required this.initialValue,
    @required this.onChanged,
    @required this.secondaryText
  }) : super(key: key);

  final WidgetBuilder activeTitleBuilder;
  final WidgetBuilder inactiveTitleBuilder;
  final bool initialValue;
  final Widget secondaryText;
  final ValueChanged<bool> onChanged;

  @override
  _IndividualSwitchMenuItemControlState createState() => _IndividualSwitchMenuItemControlState();
}
class _IndividualSwitchMenuItemControlState extends State<IndividualSwitchMenuItemControl> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(bool newValue) {
    setState(() {
      _value = newValue;
    });
    widget.onChanged(newValue);
  }

  Widget _buildTitle(BuildContext context) {
    return _value
      ? widget.activeTitleBuilder(context)
      : widget.inactiveTitleBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: _buildTitle(context),
      value: _value,
      contentBuilder: (context) => Container(
        padding: const EdgeInsets.only(
          left: 72,
          right: 16.0,
          top: 16.0,
          bottom: 16.0
        ),
        child: widget.secondaryText,
      ),
      onChanged: _handleChanged,
    );
  }
}

class ContentSwitchControl extends StatelessWidget {
  ContentSwitchControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.contentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Widget title;
  final bool value;
  final WidgetBuilder contentBuilder;
  final ValueChanged<bool> onChanged;

  Widget _buildControl(BuildContext context) {
    return Container(
      child: SwitchListTile(
        secondary: Visibility(
          visible: false,
          child: CircleAvatar()
        ),
        title: title,
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        inactiveThumbColor: Colors.white,
      ),
      decoration: BoxDecoration(
        color: value
          ? Theme.of(context).primaryColor
          : Theme.of(context).disabledColor
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: contentBuilder(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildControl(context),
        _buildContent(context)
      ],
    );
  }
}

class Suggestion {
  Suggestion({
    @required this.item,
    this.screen,
    this.parentsTitles,
  });

  final SettingsMenuItem item;
  final SettingsMenuItem screen;
  final List<String> parentsTitles;
}

class _SettingsSearchDelegate extends SearchDelegate<SettingsMenuItem> {
  _SettingsSearchDelegate({
    @required this.data
  });

  final List<SettingsMenuItem> data;
  final Iterable<Suggestion> _history = [];

  Iterable<SettingsMenuItem> _getResults() {
    return data.where(
      (item) => item.label != null && item.label.contains(query)
    ).toList();
  }

  List<Suggestion> _getSuggestions({
    SettingsMenuItem screen,
    SettingsMenuItem parent,
    List<Suggestion> suggestions,
    List<String> parentsTitles
  }) {
    List<SettingsMenuItem> data = parent != null ? parent.group : this.data;
    parentsTitles = parentsTitles ?? [];
    suggestions = suggestions ?? [];

    data.forEach((item) {
      List<String> itemParentsTitles;
      bool isScreen = _kScreenSettingsMenuItemTypes.contains(item.type);

      if ((item.label ?? '').startsWith(query)) {
        suggestions.add(
          Suggestion(
            screen: screen,
            item: item,
            parentsTitles: parentsTitles
          )
        );
      }

      if (item.group != null) {
        if (isScreen) {
          itemParentsTitles = []
            ..addAll(parentsTitles)
            ..add(item.label);
        }

        _getSuggestions(
          parent: item,
          screen: isScreen ? item : screen,
          suggestions: suggestions,
          parentsTitles: itemParentsTitles
        );
      }
    });

    return suggestions;
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

//  List<SettingsMenuItem> _getGroupWithSelected(
//    List<SettingsMenuItem> group,
//    SettingsMenuItem selectedItem
//  ) {
//    return group.map((item) {
//      if (item == selectedItem) {
//        return SettingsMenuItem._(
//          item,
//          selected: true,
//        );
//      } else if (item.group != null) {
//        return SettingsMenuItem._(
//          item,
//          group: _getGroupWithSelected(item.group, selectedItem),
//        );
//      }
//
//      return item;
//    }).toList();
//  }

  Widget _buildScreen(BuildContext context, Suggestion suggestion) {
    bool hasScreen = suggestion.screen != null;
    List<SettingsMenuItem> settings = hasScreen ? suggestion.screen.group : data;

    //settings = _getGroupWithSelected(settings, suggestion.item);

    return Scaffold(
      appBar: AppBar(
        title: Text(hasScreen ? suggestion.screen.label : 'Settings'),
      ),
      body: Settings(settings),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final Iterable<Suggestion> suggestions = query.isEmpty
        ? _history
        : _getSuggestions();

    return _SuggestionList(
      query: query,
      suggestions: suggestions,
      onSelected: (Suggestion suggestion) {
        query = suggestion.item.label;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _buildScreen(context, suggestion)
          )
        );
        //showResults(context);
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        '"$query"\n has no results',
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Iterable<SettingsMenuItem> results = _getResults();

    if (query == null || results.isEmpty) return _buildEmpty(context);

    return ListView(
      children: results.map((item) => _ResultCard(
        item: item,
        searchDelegate: this,
      )).toList()
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Container()
          : IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
      PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              title: Text('Clear history'),
            ),
          )
        ],
      )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.item, this.searchDelegate});

  final SettingsMenuItem item;
  final SearchDelegate<SettingsMenuItem> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, item);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${item.label}',
            style: theme.textTheme.headline.copyWith(fontSize: 72.0),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final Iterable<Suggestion> suggestions;
  final String query;
  final ValueChanged<Suggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final Suggestion suggestion = suggestions.elementAt(i);
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.item.label.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.item.label.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          subtitle: Text(suggestion.parentsTitles.join(' > ')),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
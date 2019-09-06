import 'package:flutter/material.dart';

const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;

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

class SelectionOption<T> {
  SelectionOption({
    @required this.label,
    @required this.value
  });

  final String label;
  final T value;
}

abstract class SettingsMenuEntry<T> extends StatefulWidget {
  SettingsMenuEntry({
    Key key,
    this.id,
    this.sectionTitle,
    this.leading,
    this.label,
    this.secondaryText,
    this.group,
    this.options,
    this.defaultValue,
    this.activeBuilder,
    this.inactiveBuilder,
    this.showTopDivider,
    this.showBottomDivider,
    this.enabled,
    this.onChanged,
    @required this.type
  });

  final String id;
  final String sectionTitle;
  final List<SettingsMenuItem> group;
  final Widget leading;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final T defaultValue;
  final WidgetBuilder activeBuilder;
  final WidgetBuilder inactiveBuilder;
  final bool showTopDivider;
  final bool showBottomDivider;
  final bool enabled;
  final ValueChanged onChanged;
  final SettingsMenuItemType type;
}


bool _needShowTopDivider(SettingsMenuItem item, SettingsMenuItem previous) {
  if (previous != null && item.type == SettingsMenuItemType.section) {
    bool isDependencyWithLastSectionItemInPrevious =
        previous.type == SettingsMenuItemType.dependency &&
        previous.group != null && previous.group.isNotEmpty &&
        previous.group.last.type == SettingsMenuItemType.section;
    bool isSectionPrevious = previous.type == SettingsMenuItemType.section;

    return !isDependencyWithLastSectionItemInPrevious && !isSectionPrevious;
  }

  return null;
}

bool _needShowBottomDivider(SettingsMenuItem item) {
  return item.type == SettingsMenuItemType.section ? true : null;
}

class SettingsMenuItem<T> extends SettingsMenuEntry {
  SettingsMenuItem._(SettingsMenuItem item, {
    Key key,
    SettingsMenuItem previous,
    bool enabled,
    bool showTopDivider,
    bool showBottomDivider
  }) : super(
    key: key,
    id: item.id,
    leading: item.leading,
    label: item.label,
    sectionTitle: item.sectionTitle,
    secondaryText: item.secondaryText,
    group: item.group,
    options: item.options,
    defaultValue: item.defaultValue,
    activeBuilder: item.activeBuilder,
    inactiveBuilder: item.inactiveBuilder,
    showTopDivider: showTopDivider ?? _needShowTopDivider(item, previous),
    showBottomDivider: showBottomDivider ?? _needShowBottomDivider(item),
    enabled: enabled ?? item.enabled,
    onChanged: item.onChanged,
    type: item.type
  );

  SettingsMenuItem.toggleSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.toggleSwitch,
  );

  SettingsMenuItem.section({
    Key key,
    String title,
    @required List<SettingsMenuItem> group,
    bool enabled = true,
  }) : super(
    key: key,
    sectionTitle: title,
    group: group,
    enabled: enabled,
    type: SettingsMenuItemType.section,
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    @required T defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    options: options,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.singleChoice,
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    @required List<T> defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    defaultValue: defaultValue,
    options: options,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.multipleChoice
  );

  SettingsMenuItem.slider({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required double defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.slider
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    DateTime defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.dateTime
  );

  SettingsMenuItem.listSubscreen({
    Key key,
    @required String label,
    Widget leading,
    String secondaryText,
    @required List<SettingsMenuItem> group,
    bool enabled = true
  }) : super(
    key: key,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    group: group,
    enabled: enabled,
    type: SettingsMenuItemType.listSubscreen
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required WidgetBuilder inactiveBuilder,
    List<SettingsMenuItem> group,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    inactiveBuilder: inactiveBuilder,
    group: group,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required WidgetBuilder activeBuilder,
    @required WidgetBuilder inactiveBuilder,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    activeBuilder: activeBuilder,
    inactiveBuilder: inactiveBuilder,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    String secondaryText,
    @required List<SettingsMenuItem> group,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged onChanged
  }) : super(
    key: key,
    id: id,
    leading: leading,
    label: label,
    secondaryText: secondaryText,
    group: group,
    defaultValue: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    type: SettingsMenuItemType.dependency
  );

  @override
  State<StatefulWidget> createState() {
    switch(type) {
      case SettingsMenuItemType.toggleSwitch: return _SettingsMenuItemToggleSwitchState();
      case SettingsMenuItemType.section: return _SettingsMenuItemSectionState();
      case SettingsMenuItemType.singleChoice: return _SettingsMenuItemSingleChoiceState();
      case SettingsMenuItemType.multipleChoice: return _SettingsMenuItemMultipleChoiceState();
      case SettingsMenuItemType.dateTime: return _SettingsMenuItemDateTimeState();
      case SettingsMenuItemType.slider: return _SettingsMenuItemSliderState();
      case SettingsMenuItemType.listSubscreen: return _SettingsMenuItemListSubscreenState();
      case SettingsMenuItemType.masterSwitch: return _SettingsMenuItemMasterSwitchState();
      case SettingsMenuItemType.individualSwitch: return _SettingsMenuItemIndividualSwitchState();
      case SettingsMenuItemType.dependency: return _SettingsMenuItemDependencyState();
      default: return null;
    }
  }
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
      itemBuilder: (context, index) => SettingsMenuItem._(
        group[index],
        previous: index > 0 ? group[index - 1] : null,
        enabled: enabled,
        showTopDivider: group[index] == group.first ? false : null,
        showBottomDivider: group[index] == group.last ? false : null,
      )
    );
  }
}

class SettingsScaffold extends StatelessWidget {
  SettingsScaffold({
    Key key,
    @required this.title,
    @required this.body,
    this.helpBuilder
  }) : super(key: key);

  final Widget title;
  final WidgetBuilder helpBuilder;
  final Widget body;

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
              onPressed: () => null
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
      body: body,
    );
  }
}

class _SettingsMenuItemSectionState<T> extends State<SettingsMenuItem<T>> {

  Widget _buildTitle(BuildContext context) {
    return widget.sectionTitle == null ? Container() : Container(
      alignment: Alignment.centerLeft,
      child: Text(
        widget.sectionTitle,
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

  Widget _buildSettingsMenuItem(SettingsMenuItem item) {
    int index = widget.group.indexOf(item);
    return SettingsMenuItem._(
      item,
      previous: index > 0 ? widget.group[index - 1] : null,
      enabled: widget.enabled,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: widget.group.map(_buildSettingsMenuItem)
        .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.showTopDivider ? Divider(height: 5) : Container(),
        _buildTitle(context),
        _buildContent(context),
        widget.showBottomDivider ? Divider(height: 5) : Container(),
      ],
    );
  }
}

class _SettingsMenuItemToggleSwitchState<T> extends State<SettingsMenuItem<T>> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(bool newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      value: _value,
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

class _SettingsMenuItemSingleChoiceState<T> extends State<SettingsMenuItem<T>> {
  Widget _buildSettingsScaffold(BuildContext context) {
    return SettingsScaffold(
      title: Text(widget.label),
      body: SingleChoiceControl(
        options: widget.options,
        initialValue: widget.defaultValue,
        onChanged: widget.onChanged,
      )
    );
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
        visible: false,
        child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      enabled: widget.enabled,
    );
  }
}

class SingleChoiceControl<T> extends StatefulWidget {
  SingleChoiceControl({
    Key key,
    @required this.options,
    this.initialValue,
    this.onChanged
  }) : super(key: key);

  final List<SelectionOption<T>> options;
  final T initialValue;
  final ValueChanged onChanged;

  @override
  _SingleChoiceControlState createState() => _SingleChoiceControlState();
}
class _SingleChoiceControlState<T> extends State<SingleChoiceControl<T>> {
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
    SelectionOption option = widget.options[index];
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
      itemCount: widget.options.length,
      itemBuilder: _buildRadioListTile
    );
  }
}

class _SettingsMenuItemMultipleChoiceState<T> extends State<SettingsMenuItem<T>> {

  Widget _buildAlertDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(widget.label),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: widget.options.length * _kListTileHeight,
        child: MultipleChoiceControl(
          options: widget.options,
          initialValue: widget.defaultValue,
          onChanged: widget.onChanged
        ),
      ),
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => showDialog(
        context: context,
        builder: _buildAlertDialog
      ),
      enabled: widget.enabled,
    );
  }
}

class MultipleChoiceControl<T> extends StatefulWidget {
  MultipleChoiceControl({
    Key key,
    @required this.options,
    @required this.initialValue,
    this.onChanged
  }) : super(key: key);

  final List<SelectionOption> options;
  final List<T> initialValue;
  final ValueChanged onChanged;

  @override
  _MultipleChoiceControlState<T> createState() => _MultipleChoiceControlState();
}
class _MultipleChoiceControlState<T> extends State<MultipleChoiceControl<T>> {
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
    SelectionOption option = widget.options[index];
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
      itemCount: widget.options.length,
      itemBuilder: _buildCheckboxListTile
    );
  }
}

class _SettingsMenuItemSliderState<T> extends State<SettingsMenuItem<T>> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(double newValue) {
    if (widget.onChanged != null) widget.onChanged(_value);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliderListTile(
      secondary: _buildLeading(context),
      title: Text(widget.label),
      value: _value,
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

class _SettingsMenuItemDateTimeState<T> extends State<SettingsMenuItem<T>> {
  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue ?? null;
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

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: _selectDate,
      enabled: widget.enabled,
    );
  }
}

class _SettingsMenuItemListSubscreenState<T> extends State<SettingsMenuItem<T>> {

  Widget _buildSettingsScaffold(BuildContext context) {
    return SettingsScaffold(
      title: Text(widget.label),
      body: Settings(widget.group),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
        visible: false,
        child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: _buildSettingsScaffold)),
      enabled: widget.enabled,
    );
  }
}

class _SettingsMenuItemDependencyState<T> extends State<SettingsMenuItem<T>> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(bool newValue) {
    setState(() {
      _value = newValue;
    });
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  Widget _buildDependentItem(SettingsMenuItem item) {
    int index = widget.group.indexOf(item);
    return SettingsMenuItem._(
      item,
      previous: index > 0 ? widget.group[index - 1] : null,
      enabled: widget.enabled == false ? false : _value
    );
  }

  Widget _buildDependent(BuildContext context) {
    return Column(
      children: widget.group.map(_buildDependentItem).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: _buildLeading(context),
          title: Text(widget.label),
          subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
          value: _value,
          onChanged: widget.enabled ? _handleChanged : null,
        ),
        _buildDependent(context)
      ],
    );
  }
}

class _SettingsMenuItemMasterSwitchState<T> extends State<SettingsMenuItem<T>> {

  Widget _buildSettingsScaffold(BuildContext context) {
    return SettingsScaffold(
      title: Text(widget.label),
      body: MasterSwitchControl(
        title: Text(widget.label),
        initialValue: widget.defaultValue,
        activeBuilder: (context) => Settings(widget.group),
        inactiveBuilder: widget.inactiveBuilder
      )
    );
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      enabled: widget.enabled,
    );
  }
}

class _SettingsMenuItemIndividualSwitchState<T> extends State<SettingsMenuItem<T>> {

  Widget _buildSettingsScaffold(BuildContext context) {
    return SettingsScaffold(
      title: Text(widget.label),
      body: MasterSwitchControl(
        title: Text(widget.label),
        initialValue: widget.defaultValue,
        activeBuilder: widget.activeBuilder,
        inactiveBuilder: widget.inactiveBuilder
      )
    );
  }

  Widget _buildLeading(BuildContext context) {
    return widget.leading ?? Visibility(
      visible: false,
      child: CircleAvatar()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(context),
      title: Text(widget.label),
      subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildSettingsScaffold)
      ),
      enabled: widget.enabled,
    );
  }
}

class MasterSwitchControl extends StatefulWidget {
  MasterSwitchControl({
    Key key,
    @required this.title,
    this.initialValue = false,
    @required this.activeBuilder,
    @required this.inactiveBuilder,
  }) : super(key: key);

  final Widget title;
  final bool initialValue;
  final WidgetBuilder activeBuilder;
  final WidgetBuilder inactiveBuilder;

  @override
  _MasterSwitchControlState createState() => _MasterSwitchControlState();
}
class _MasterSwitchControlState extends State<MasterSwitchControl> {
  bool _isActive;

  @override
  initState() {
    super.initState();
    _isActive = widget.initialValue;
  }

  void _handleChanged(bool isActive) {
    setState(() {
      _isActive = isActive;
    });
  }

  Widget _buildControl(BuildContext context) {
    return Container(
      child: SwitchListTile(
        secondary: Visibility(
          visible: false,
          child: CircleAvatar()
        ),
        title: Theme(
          data: ThemeData.dark(),
          child: widget.title
        ),
        value: _isActive,
        onChanged: _handleChanged,
        activeColor: Colors.white,
        inactiveThumbColor: Colors.white,
      ),
      decoration: BoxDecoration(
        color: _isActive
          ? Theme.of(context).primaryColor
          : Theme.of(context).disabledColor
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: _isActive
        ? widget.activeBuilder(context)
        : widget.inactiveBuilder(context)
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
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
    this.id,
    this.sectionTitle,
    this.label,
    this.secondaryText,
    this.group,
    this.options,
    this.defaultValue,
    this.activeBuilder,
    this.inactiveBuilder,
    this.enabled,
    @required this.type
  });

  final String id;
  final String sectionTitle;
  final List<SettingsMenuItem> group;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final T defaultValue;
  final WidgetBuilder activeBuilder;
  final WidgetBuilder inactiveBuilder;
  final bool enabled;
  final SettingsMenuItemType type;
}

class SettingsMenuItem<T> extends SettingsMenuEntry {
  SettingsMenuItem._(SettingsMenuItem item, {
    Key key,
    bool enabled
  }) : super(
      id: item.id,
      label: item.label,
      sectionTitle: item.sectionTitle,
      secondaryText: item.secondaryText,
      group: item.group,
      options: item.options,
      defaultValue: item.defaultValue,
      activeBuilder: item.activeBuilder,
      inactiveBuilder: item.inactiveBuilder,
      enabled: enabled == false ? enabled : item.enabled,
      type: item.type
  );

  SettingsMenuItem.toggleSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    bool defaultValue = false,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.toggleSwitch,
  );

  SettingsMenuItem.section({
    String title,
    @required List<SettingsMenuItem> group,
    bool showTopDivider = true,
    bool showBottomDivider = true,
    bool enabled = true
  }) : super(
      sectionTitle: title,
      group: group,
      enabled: enabled,
      type: SettingsMenuItemType.section,
  );

  SettingsMenuItem.singleChoice({
    @required String id,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    T defaultValue,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      options: options,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.singleChoice,
  );

  SettingsMenuItem.multipleChoice({
    @required String id,
    @required String label,
    String secondaryText,
    @required List<SelectionOption> options,
    List<T> defaultValue,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      options: options,
      enabled: enabled,
      type: SettingsMenuItemType.multipleChoice
  );

  SettingsMenuItem.slider({
    @required String id,
    @required String label,
    String secondaryText,
    double defaultValue = 0,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.slider
  );

  SettingsMenuItem.dateTime({
    @required String id,
    @required String label,
    String secondaryText,
    DateTime defaultValue,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.dateTime
  );

  SettingsMenuItem.listSubscreen({
    @required String label,
    String secondaryText,
    @required List<SettingsMenuItem> group,
    bool enabled = true
  }) : super(
      label: label,
      secondaryText: secondaryText,
      group: group,
      enabled: enabled,
      type: SettingsMenuItemType.listSubscreen
  );

  SettingsMenuItem.masterSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    @required WidgetBuilder inactiveBuilder,
    List<SettingsMenuItem> group,
    bool defaultValue = false,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      inactiveBuilder: inactiveBuilder,
      group: group,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    @required String id,
    @required String label,
    String secondaryText,
    @required WidgetBuilder activeBuilder,
    @required WidgetBuilder inactiveBuilder,
    bool defaultValue = false,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      activeBuilder: activeBuilder,
      inactiveBuilder: inactiveBuilder,
      defaultValue: defaultValue,
      enabled: enabled,
      type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    @required String id,
    @required String label,
    String secondaryText,
    @required List<SettingsMenuItem> group,
    bool defaultValue = false,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      group: group,
      defaultValue: defaultValue,
      enabled: enabled,
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

  Widget _buildItem(BuildContext context, int index) {
    SettingsMenuItem item = group.elementAt(index);
    return SettingsMenuItem._(item, enabled: enabled);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: _buildItem
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

  Widget _buildContent(BuildContext context) {
    return Column(
      children: widget.group.map(
        (item) => SettingsMenuItem._(item, enabled: widget.enabled)
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 1),
        _buildTitle(context),
        _buildContent(context),
        Divider(height: 1),
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
    setState(() {
      _value = newValue;
    });
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
        defaultValue: widget.defaultValue,
      )
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
    this.defaultValue
  }) : super(key: key);

  final List<SelectionOption<T>> options;
  final T defaultValue;

  @override
  _SingleChoiceControlState createState() => _SingleChoiceControlState();
}
class _SingleChoiceControlState<T> extends State<SingleChoiceControl<T>> {
  T _value;

  @override
  initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(newValue) {
    setState(() {
      _value = newValue;
    });
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
          value: widget.defaultValue,
        ),
      ),
      onConfirm: () => Navigator.of(context).pop(),
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
    @required this.value
  }) : super(key: key);

  final List<SelectionOption> options;
  final List<T> value;

  @override
  _MultipleChoiceControlState<T> createState() => _MultipleChoiceControlState();
}
class _MultipleChoiceControlState<T> extends State<MultipleChoiceControl<T>> {
  List<T> _value;

  @override
  initState() {
    super.initState();
    _value = widget.value;
  }

  void _add(T optionValue) {
    setState(() {
      _value.add(optionValue);
    });
  }

  void _remove(T optionValue) {
    setState(() {
      _value.remove(optionValue);
    });
  }

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    SelectionOption option = widget.options[index];
    bool checked = widget.value.contains(option.value);
    return CheckboxListTile(
        title: Text(option.label),
        value: checked,
        selected: checked,
        onChanged: (bool isChecked) => isChecked
          ? _add(option.value)
          : _remove(option.value)
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
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SliderListTile(
        secondary: Visibility(
          visible: false,
          child: CircleAvatar()
        ),
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
          visible: false,
          child: CircleAvatar()
      ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: Visibility(
            visible: false,
            child: CircleAvatar()
          ),
          title: Text(widget.label),
          subtitle: widget.secondaryText == null ? null : Text(widget.secondaryText),
          value: _value,
          onChanged: widget.enabled ? _handleChanged : null,
        ),
        SettingsMenuItem.section(
          group: widget.group,
          enabled: widget.enabled == false ? false : _value,
          showBottomDivider: false,
          showTopDivider: false,
        )
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
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
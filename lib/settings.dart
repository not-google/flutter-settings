import 'package:flutter/material.dart';

const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;

enum SettingsPatternType {
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

abstract class SettingsPatternBase<T> {
  SettingsPatternBase({
    this.id,
    this.sectionTitle,
    this.label,
    this.secondaryText,
    this.group,
    this.options,
    this.defaultValue,
    this.enabled,
    @required this.patternType
  });

  final String id;
  final String sectionTitle;
  final List<SettingsPattern> group;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final T defaultValue;
  final bool enabled;
  final SettingsPatternType patternType;
}

class SettingsPattern<T> extends SettingsPatternBase {
  SettingsPattern.toggleSwitch({
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
      patternType: SettingsPatternType.toggleSwitch
  );

  SettingsPattern.section({
    String title,
    @required List<SettingsPattern> group,
    bool enabled = true
  }) : super(
      sectionTitle: title,
      group: group,
      enabled: enabled,
      patternType: SettingsPatternType.section
  );

  SettingsPattern.singleChoice({
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
      defaultValue: defaultValue,
      enabled: enabled,
      patternType: SettingsPatternType.singleChoice
  );

  SettingsPattern.multipleChoice({
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
      enabled: enabled,
      patternType: SettingsPatternType.multipleChoice
  );

  SettingsPattern.slider({
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
      patternType: SettingsPatternType.slider
  );

  SettingsPattern.dateTime({
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
      patternType: SettingsPatternType.dateTime
  );

  SettingsPattern.listSubscreen({
    @required String label,
    String secondaryText,
    @required List<SettingsPattern> group,
    bool enabled = true
  }) : super(
      label: label,
      secondaryText: secondaryText,
      group: group,
      enabled: enabled,
      patternType: SettingsPatternType.listSubscreen
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
      patternType: SettingsPatternType.masterSwitch
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
      patternType: SettingsPatternType.individualSwitch
  );

  SettingsPattern.dependency({
    @required String id,
    @required String label,
    secondaryText,
    @required List<SettingsPattern> dependent,
    bool defaultValue = false,
    bool enabled = true
  }) : super(
      id: id,
      label: label,
      secondaryText: secondaryText,
      group: dependent,
      defaultValue: defaultValue,
      enabled: enabled,
      patternType: SettingsPatternType.dependency
  );
}

class SettingsPatternWidget extends StatelessWidget {
  SettingsPatternWidget(this.pattern, {
    Key key,
    this.enable
  }) : super(key: key);

  final SettingsPattern pattern;
  final bool enable;

  Widget _buildToggleSwitch() {
    return SettingsToggleSwitch(
        id: pattern.id,
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        defaultValue: pattern.defaultValue,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildSection() {
    return SettingsSection(
        title: pattern.sectionTitle,
        group: pattern.group,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildSingleChoice() {
    return SettingsSingleChoice(
        id: pattern.id,
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        options: pattern.options,
        defaultValue: pattern.defaultValue,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildMultipleChoice() {
    return SettingsMultipleChoice(
        id: pattern.id,
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        options: pattern.options,
        defaultValue: pattern.defaultValue,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildSlider() {
    return SettingsSlider(
        id: pattern.id,
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        defaultValue: pattern.defaultValue,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildDateTime() {
    return SettingsDateTime(
        id: pattern.id,
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        defaultValue: pattern.defaultValue,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildListSubscreen() {
    return SettingsListSubscreen(
        label: pattern.label,
        secondaryText: pattern.secondaryText,
        group: pattern.group,
        enabled: enable != null ? enable : pattern.enabled
    );
  }

  Widget _buildMasterSwitch() {
    return Container();
  }

  Widget _buildIndividualSwitch() {
    return Container();
  }

  Widget _buildDependency() {
    return SettingsDependency(
      label: pattern.label,
      secondaryText: pattern.secondaryText,
      dependent: pattern.group,
      defaultValue: pattern.defaultValue,
      enabled: enable != null ? enable : pattern.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(pattern.patternType) {
      case SettingsPatternType.section: return _buildSection();
      case SettingsPatternType.singleChoice: return _buildSingleChoice();
      case SettingsPatternType.multipleChoice: return _buildMultipleChoice();
      case SettingsPatternType.dateTime: return _buildDateTime();
      case SettingsPatternType.slider: return _buildSlider();
      case SettingsPatternType.listSubscreen: return _buildListSubscreen();
      case SettingsPatternType.masterSwitch: return _buildMasterSwitch();
      case SettingsPatternType.individualSwitch: return _buildIndividualSwitch();
      case SettingsPatternType.dependency: return _buildDependency();
      case SettingsPatternType.toggleSwitch: return _buildToggleSwitch();
      default: return null;
    }
  }
}

class Settings<T> extends StatelessWidget {
  Settings({
    Key key,
    @required this.group
  }) : super(key: key);

  final List<SettingsPattern<T>> group;

  Widget _buildSection(
      BuildContext context,
      SettingsPattern pattern,
      SettingsPattern previousPattern
      ) {
    bool isNotFirst = group.first != pattern;
    bool isNotLast = group.last != pattern;
    bool isNotPreviousPatternSection =
        (previousPattern != null) &&
            (previousPattern.patternType != SettingsPatternType.section);
    return SettingsSection(
      title: pattern.sectionTitle,
      group: pattern.group,
      enabled: pattern.enabled,
      showTopDivider: isNotFirst && isNotPreviousPatternSection,
      showBottomDivider: isNotLast,
    );
  }

  Widget _buildPattern(BuildContext context, SettingsPattern pattern) {
    return SettingsPatternWidget(pattern);
  }

  Widget _buildItem(BuildContext context, int index) {
    SettingsPattern pattern = group.elementAt(index);
    SettingsPattern previousPattern = index > 0 ? group.elementAt(index - 1) : null;
    switch(pattern.patternType) {
      case SettingsPatternType.section: return _buildSection(context, pattern, previousPattern);
      default: return SettingsPatternWidget(pattern);
    }
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

class SettingsSection extends StatelessWidget {
  SettingsSection({
    Key key,
    this.title,
    @required this.group,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true
  }) : super(
      key: key
  );

  final String title;
  final List<SettingsPattern> group;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;

  Widget _buildSection(
      BuildContext context,
      SettingsPattern pattern,
      SettingsPattern previousPattern
      ) {
    bool isNotFirst = group.first != pattern;
    bool isNotLast = group.last != pattern;
    bool isNotPreviousPatternSection =
        (previousPattern != null) &&
        (previousPattern.patternType != SettingsPatternType.section);
    return SettingsSection(
        title: pattern.sectionTitle,
        group: pattern.group,
        enabled: enabled,
        showTopDivider: isNotFirst && isNotPreviousPatternSection,
        showBottomDivider: isNotLast,
    );
  }

  Widget _buildPattern(BuildContext context, SettingsPattern pattern) {
    int index = group.indexOf(pattern);
    SettingsPattern previousPattern = index > 0 ? group.elementAt(index - 1) : null;
    switch(pattern.patternType) {
      case SettingsPatternType.section: return _buildSection(context, pattern, previousPattern);
      default: return SettingsPatternWidget(pattern, enable: enabled);
    }
  }

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
      children: (group).map(
        (SettingsPattern pattern) => _buildPattern(context, pattern)
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        showTopDivider ? Divider(height: 1) : Container(),
        _buildTitle(context),
        _buildContent(context),
        showBottomDivider ? Divider(height: 1) : Container(),
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
    this.defaultValue = false,
    this.enabled = true
  }) : super(
      key: key
  );

  final String id;
  final String label;
  final String secondaryText;
  final bool defaultValue;
  final bool enabled;

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

class SettingsSingleChoice<T> extends StatelessWidget {
  SettingsSingleChoice({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    @required this.options,
    this.defaultValue,
    this.enabled = true
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final List<SelectionOption<T>> options;
  final T defaultValue;
  final bool enabled;

  Widget _buildAlertDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(label),
      content: SizedBox(
        height: options.length * _kListTileHeight,
        child: RadioListView(
          options: options,
          defaultValue: defaultValue,
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
      title: Text(label),
      subtitle: secondaryText == null ? null : Text(secondaryText),
      onTap: () => showDialog(
          context: context,
          builder: _buildAlertDialog
      ),
      enabled: enabled,
    );
  }
}

class RadioListView<T> extends StatefulWidget {
  RadioListView({
    Key key,
    @required this.options,
    this.defaultValue
  }) : super(key: key);

  final List<SelectionOption<T>> options;
  final T defaultValue;

  @override
  _RadioListViewState createState() => _RadioListViewState();
}
class _RadioListViewState<T> extends State<RadioListView<T>> {

  T _value;

  @override
  initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  _handleChanged(value) => setState(() => _value = value);

  Widget _buildRadioListTile(BuildContext context, int index) {
    SelectionOption option = widget.options[index];
    return RadioListTile(
        title: Text(option.label),
        value: option.value,
        groupValue: _value,
        selected: _value == option.value,
        onChanged: _handleChanged
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

class SettingsMultipleChoice<T> extends StatelessWidget {
  SettingsMultipleChoice({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    @required this.options,
    this.defaultValue,
    this.enabled = true
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final List<SelectionOption> options;
  final List<T> defaultValue;
  final bool enabled;

  Widget _buildAlertDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(label),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: options.length * _kListTileHeight,
        child: CheckboxListView(
          options: options,
          defaultValue: defaultValue,
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
      title: Text(label),
      subtitle: secondaryText == null ? null : Text(secondaryText),
      onTap: () => showDialog(
          context: context,
          builder: _buildAlertDialog
      ),
      enabled: enabled,
    );
  }
}

class CheckboxListView<T> extends StatefulWidget {
  CheckboxListView({
    Key key,
    @required this.options,
    this.defaultValue
  }) : super(key: key);

  final List<SelectionOption> options;
  final List<T> defaultValue;

  @override
  _CheckboxListViewState createState() => _CheckboxListViewState();
}
class _CheckboxListViewState<T> extends State<CheckboxListView<T>> {

  List<T> _values;

  @override
  initState() {
    super.initState();
    _values = widget.defaultValue;
  }

  void _check(T value) => setState(() => _values.add(value));
  void _uncheck(T value) => setState(() => _values.remove(value));

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    SelectionOption option = widget.options[index];
    bool checked = _values.contains(option.value);
    return CheckboxListTile(
        title: Text(option.label),
        value: checked,
        selected: checked,
        onChanged: (bool checked) => checked
            ? _check(option.value)
            : _uncheck(option.value)
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

class SettingsSlider extends StatefulWidget {
  SettingsSlider({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    this.defaultValue = 0,
    this.enabled = true
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final double defaultValue;
  final bool enabled;

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

  _handleChanged(double value) => setState(() => _value = value);

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

class SettingsDateTime extends StatefulWidget {
  SettingsDateTime({
    Key key,
    @required this.id,
    @required this.label,
    this.secondaryText,
    this.defaultValue,
    this.enabled = true
  }) : super(key: key);

  final String id;
  final String label;
  final String secondaryText;
  final DateTime defaultValue;
  final bool enabled;

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
      enabled: widget.enabled,
    );
  }
}

class SettingsListSubscreen extends StatelessWidget {
  SettingsListSubscreen({
    Key key,
    @required this.label,
    this.secondaryText,
    @required this.group,
    this.enabled = true
  }) : super(key: key);

  final String label;
  final String secondaryText;
  final List<SettingsPattern> group;
  final bool enabled;

  Widget _buildSettingsScaffold(BuildContext context) {
    return SettingsScaffold(
      title: Text(label),
      body: Settings(group: group),
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: _buildSettingsScaffold)),
      enabled: enabled,
    );
  }
}

class SettingsDependency extends StatefulWidget {
  SettingsDependency({
    Key key,
    @required this.label,
    this.secondaryText,
    @required this.dependent,
    this.defaultValue = false,
    this.enabled = true
  }) : super(key: key);

  final String label;
  final String secondaryText;
  final List<SettingsPattern> dependent;
  final bool defaultValue;
  final bool enabled;

  @override
  _SettingsDependencyState createState() => _SettingsDependencyState();
}
class _SettingsDependencyState extends State<SettingsDependency> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  void _handleChanged(bool value) => setState(() => _value = value);

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
        SettingsSection(
          group: widget.dependent,
          enabled: _value,
          showBottomDivider: false,
          showTopDivider: false,
        )
      ],
    );
  }
}
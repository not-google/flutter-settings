import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;
const double _kDividerHeight = 1.0;
const List<SettingsMenuItemType> _kScreenSettingsMenuItemTypes = [
  SettingsMenuItemType.listSubscreen,
  SettingsMenuItemType.masterSwitch,
  SettingsMenuItemType.individualSwitch
];
const String activeLabel = 'On';
const String inactiveLabel = 'Off';

typedef SettingsPageBuilder<T> = Function(
  BuildContext context,
  Widget title,
  Widget body,
  VoidCallback onSearch
);
typedef SettingsMenuItemBuilder<T> = List<SettingsMenuItem<T>> Function(BuildContext context);
typedef StatusBuilder<T> = Widget Function(BuildContext context, T status);
typedef MenuItemBuilder = Widget Function(BuildContext context, {
  bool dependencyEnabled,
  bool selected,
  bool showTopDivider,
  bool showBottomDivider,
  VoidCallback showSettingsSearch
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
    this.itemBuilder,
    this.pageBuilder,
    @required this.builder,
    @required this.type
  });

  final String label;
  final SettingsPageBuilder pageBuilder;
  final SettingsMenuItemBuilder itemBuilder;
  final MenuItemBuilder builder;
  final SettingsMenuItemType type;
}

class SettingsMenuItem<T> extends SettingsMenuEntry<T> {

  static bool _needShowTopDivider(
      BuildContext context,
      SettingsMenuItem item,
      SettingsMenuItem previous
  ) {
    bool isSection = item.type == SettingsMenuItemType.section;
    bool isNotEmptyPrevious = previous?.itemBuilder != null;
    if (isSection && isNotEmptyPrevious) {
      List<SettingsMenuItem> previousGroup = previous.itemBuilder(context);
      bool isNotDependencyWithLastSectionPrevious =
          previous.type != SettingsMenuItemType.dependency ||
          previousGroup?.last?.type != SettingsMenuItemType.section;
      bool isNotSectionPrevious = previous.type != SettingsMenuItemType.section;

      return isNotDependencyWithLastSectionPrevious && isNotSectionPrevious;
    }

    return false;
  }

  static bool _needShowBottomDivider(SettingsMenuItem item) {
    return item.type == SettingsMenuItemType.section;
  }

  SettingsMenuItem._(
    SettingsMenuItem item, {
    Key key,
    SettingsMenuItem previous,
    bool selected = false,
    bool enabled,
    VoidCallback onSearch
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch,
    }) => item.builder(
      context,
      dependencyEnabled: enabled,
      selected: selected,
      showTopDivider: _needShowTopDivider(context, item, previous),
      showBottomDivider: _needShowBottomDivider(item),
      showSettingsSearch: onSearch
    ),
    label: item.label,
    itemBuilder: item.itemBuilder,
    pageBuilder: item.pageBuilder,
    type: item.type
  );

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
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => ToggleSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onChanged: onChanged,
    ),
    label: label,
    type: SettingsMenuItemType.toggleSwitch,
  );

  SettingsMenuItem.section({
    Key key,
    String title,
    @required SettingsMenuItemBuilder itemBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider = true,
      bool showBottomDivider = true,
      VoidCallback showSettingsSearch
    }) => SectionMenuItem(
      title: title,
      itemBuilder: itemBuilder,
      enabled: dependencyEnabled ?? enabled,
      showTopDivider: showTopDivider,
      showBottomDivider: showBottomDivider
    ),
    itemBuilder: itemBuilder,
    type: SettingsMenuItemType.section,
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    StatusBuilder<Choice<T>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required T initialValue,
    SettingsPageBuilder pageBuilder,
    bool enabled = true,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => SingleChoiceMenuItem<T>(
      id: id,
      leading: leading,
      label: label,
      statusTextBuilder: statusTextBuilder,
      choices: choices,
      initialValue: initialValue,
      pageBuilder: pageBuilder,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onChanged: onChanged,
      onSearch: showSettingsSearch,
    ),
    label: label,
    pageBuilder: pageBuilder,
    type: SettingsMenuItemType.singleChoice,
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    StatusBuilder<List<Choice<T>>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required List<T> initialValue,
    bool enabled = true,
    ValueChanged<List<T>> onChanged
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => MultipleChoiceMenuItem<T>(
      id: id,
      leading: leading,
      label: label,
      statusTextBuilder: statusTextBuilder,
      initialValue: initialValue,
      choices: choices,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
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
    double min = 0.0,
    double max = 1.0,
    int divisions,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeStart,
    ValueChanged<double> onChangeEnd,
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => SliderMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      initialValue: initialValue,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
    ),
    label: label,
    type: SettingsMenuItemType.slider
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    StatusBuilder<DateTime> statusTextBuilder,
    @required DateTime initialValue,
    @required DateTime min,
    @required DateTime max,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => DateTimeMenuItem(
      id: id,
      leading: leading,
      label: label,
      statusTextBuilder: statusTextBuilder,
      initialValue: initialValue,
      min: min,
      max: max,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
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
    @required SettingsMenuItemBuilder itemBuilder,
    @required SettingsPageBuilder pageBuilder,
    bool enabled = true
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => ListSubscreenMenuItem(
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      itemBuilder: itemBuilder,
      pageBuilder: pageBuilder,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onSearch: showSettingsSearch
    ),
    label: label,
    itemBuilder: itemBuilder,
    pageBuilder: pageBuilder,
    type: SettingsMenuItemType.listSubscreen
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    @required Widget masterSwitchTitle,
    StatusBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveTextBuilder,
    bool duplicateSwitchInMenuItem = false,
    @required SettingsMenuItemBuilder itemBuilder,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
    @required SettingsPageBuilder pageBuilder
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => MasterSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      masterSwitchTitle: masterSwitchTitle,
      statusTextBuilder: statusTextBuilder,
      inactiveTextBuilder: inactiveTextBuilder,
      itemBuilder: itemBuilder,
      initialValue: initialValue,
      duplicateSwitchInMenuItem: duplicateSwitchInMenuItem,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onChanged: onChanged,
      pageBuilder: pageBuilder,
      onSearch: showSettingsSearch
    ),
    label: label,
    itemBuilder: itemBuilder,
    pageBuilder: pageBuilder,
    type: SettingsMenuItemType.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    @required Widget description,
    @required bool initialValue,
    bool enabled = true,
    @required SettingsPageBuilder pageBuilder,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => IndividualSwitchMenuItem(
      id: id,
      leading: leading,
      label: label,
      description: description,
      initialValue: initialValue,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onChanged: onChanged,
      pageBuilder: pageBuilder,
      onSearch: showSettingsSearch,
    ),
    label: label,
    pageBuilder: pageBuilder,
    type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required SettingsMenuItemBuilder itemBuilder,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (BuildContext context, {
      bool dependencyEnabled,
      bool selected = false,
      bool showTopDivider,
      bool showBottomDivider,
      VoidCallback showSettingsSearch
    }) => DependencyMenuItem(
      id: id,
      leading: leading,
      label: label,
      secondaryText: secondaryText,
      itemBuilder: itemBuilder,
      initialValue: initialValue,
      enabled: dependencyEnabled ?? enabled,
      selected: selected,
      onChanged: onChanged,
    ),
    label: label,
    itemBuilder: itemBuilder,
    type: SettingsMenuItemType.dependency
  );

  @override
  Widget build(BuildContext context) => builder(context);
}

class SettingsMenu extends StatelessWidget {
  SettingsMenu({
    Key key,
    @required this.itemBuilder,
    this.onSearch,
    this.enabled
  }) : super(key: key);

  final SettingsMenuItemBuilder itemBuilder;
  final VoidCallback onSearch;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    List<SettingsMenuItem> group = itemBuilder(context);
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: (context, index) {
        SettingsMenuItem item = group[index];
        return SettingsMenuItem._(
          item,
          previous: index > 1 ? group[index - 1] : null,
          enabled: enabled,
          onSearch: onSearch,
        );
      }
    );
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    @required this.title,
    @required this.itemBuilder,
    @required this.builder,
  }) : super(key: key);

  final Widget title;
  final SettingsPageBuilder builder;
  final SettingsMenuItemBuilder itemBuilder;

  void _showSettingsSearch(context) {
    showSearch(
      context: context,
      delegate: SettingsSearchDelegate(
        itemBuilder: itemBuilder
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      itemBuilder: itemBuilder,
      onSearch: () => _showSettingsSearch(context),
    );
  }

  @override
  Widget build(BuildContext context) => builder(
    context,
    title,
    _buildBody(context),
    () => _showSettingsSearch(context)
  );
}

class SectionMenuItem extends StatelessWidget {
  SectionMenuItem({
    Key key,
    this.title,
    @required this.itemBuilder,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  final String title;
  final SettingsMenuItemBuilder itemBuilder;
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
    List<SettingsMenuItem> group = itemBuilder(context);
    return Column(
      children: group.map(
        (item) {
          int index = group.indexOf(item);
          return SettingsMenuItem._(
            item,
            previous: index > 1 ? group[index - 1] : null,
            enabled: enabled
          );
        }
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

class SingleChoiceMenuItem<T> extends StatefulWidget {
  SingleChoiceMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    this.pageBuilder,
    @required this.choices,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged,
    this.onSearch
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final StatusBuilder<Choice<T>> statusTextBuilder;
  final SettingsPageBuilder pageBuilder;
  final List<Choice<T>> choices;
  final T initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<T> onChanged;
  final VoidCallback onSearch;

  @override
  _SingleChoiceMenuItemState<T> createState() => _SingleChoiceMenuItemState<T>();
}
class _SingleChoiceMenuItemState<T> extends State<SingleChoiceMenuItem<T>> {
  T _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(T newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildTitle(BuildContext context) {
    return Text(widget.label);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChoiceMenuItemControl<T>(
      choices: widget.choices,
      initialValue: _value,
      onChanged: _handleChanged,
    );
  }

  Widget _buildPage(BuildContext context) {
    if (widget.pageBuilder != null) return widget.pageBuilder(
      context,
      _buildTitle(context),
      _buildBody(context),
      widget.onSearch
    );

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
      ),
      body: _buildBody(context)
    );
  }

  Widget _buildDefaultStatusText(context, Choice<T> choice) {
    return Text('${choice.label}');
  }

  Widget _buildStatusText(BuildContext context) {
    Choice<T> choice = widget.choices.firstWhere(
      (Choice<T> choice) => choice.value == _value
    );

    if (widget.statusTextBuilder != null)
      return widget.statusTextBuilder(context, choice);

    return _buildDefaultStatusText(context, choice);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: _buildStatusText(context),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: _buildPage)
      ),
      selected: widget.selected,
      enabled: widget.enabled,
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
  _SingleChoiceMenuItemControlState<T> createState() => _SingleChoiceMenuItemControlState<T>();
}
class _SingleChoiceMenuItemControlState<T> extends State<SingleChoiceMenuItemControl<T>> {
  T _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(T newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = widget.choices[index];
    return RadioListTile<T>(
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

class MultipleChoiceMenuItem<T> extends StatefulWidget {
  MultipleChoiceMenuItem({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    @required this.choices,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final StatusBuilder<List<Choice<T>>> statusTextBuilder;
  final List<Choice<T>> choices;
  final List<T> initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<List<T>> onChanged;

  @override
  _MultipleChoiceMenuItemState<T> createState() => _MultipleChoiceMenuItemState<T>();
}
class _MultipleChoiceMenuItemState<T> extends State<MultipleChoiceMenuItem<T>> {
  List<T> _value;

  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChanged(List<T> newValue) {
    if (widget.onChanged != null) widget.onChanged(newValue);

    setState(() {
      _value = newValue;
    });
  }

  Widget _buildAlertDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(widget.label),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: widget.choices.length * _kListTileHeight,
        child: MultipleChoiceMenuItemControl(
          choices: widget.choices,
          initialValue: widget.initialValue,
          onChanged: _handleChanged
        ),
      ),
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildDefaultStatusText(BuildContext context, List<Choice<T>> choices) {
    if (choices.isEmpty) return Text('Not Chosen');
    String labels = choices.map((choice) => choice.label).join(', ');
    return Text('$labels');
  }

  Widget _buildStatusText(BuildContext context) {
    List<Choice<T>> choices = widget.choices.where(
      (choice) => _value.contains(choice.value)
    ).toList();

    if (widget.statusTextBuilder != null)
      return widget.statusTextBuilder(context, choices);

    return _buildDefaultStatusText(context, choices);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: _buildStatusText(context),
      onTap: () => showDialog(
        context: context,
        builder: _buildAlertDialog
      ),
      selected: widget.selected,
      enabled: widget.enabled,
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

  final List<Choice<T>> choices;
  final List<T> initialValue;
  final ValueChanged<List<T>> onChanged;

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
    if (widget.onChanged != null) widget.onChanged(newValue);

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
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final double initialValue;
  final bool enabled;
  final bool selected;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;

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
    if (widget.onChanged != null) widget.onChanged(newValue);

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
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      onChanged: widget.enabled ? _handleChanged : null,
      onChangeStart: widget.enabled ? widget.onChangeStart : null,
      onChangeEnd: widget.enabled ? widget.onChangeEnd : null,
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
    this.statusTextBuilder,
    @required this.initialValue,
    @required this.min,
    @required this.max,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final StatusBuilder<DateTime> statusTextBuilder;
  final DateTime initialValue;
  final DateTime min;
  final DateTime max;
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
    _value = widget.initialValue;
  }

  Future<Null> _showDatePicker() async {
    final DateTime newValue = await showDatePicker(
      context: context,
      initialDate: widget.initialValue,
      firstDate: widget.min,
      lastDate: widget.max,
    );

    if (newValue != null && newValue != _value && widget.onChanged != null) {
      _value = newValue;
      widget.onChanged(newValue);
    }
  }

  Widget _buildDefaultStatusText(BuildContext context) {
    return Text(_value.toIso8601String());
  }

  Widget _buildStatusText(BuildContext context) {
    if (widget.statusTextBuilder != null)
      return widget.statusTextBuilder(context, _value);

    return _buildDefaultStatusText(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: _buildStatusText(context),
      onTap: _showDatePicker,
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
    @required this.itemBuilder,
    @required this.pageBuilder,
    this.enabled = true,
    this.selected = false,
    this.onSearch
  }) : super(key: key);

  final String label;
  final Widget leading;
  final Widget secondaryText;
  final SettingsMenuItemBuilder itemBuilder;
  final SettingsPageBuilder pageBuilder;
  final bool enabled;
  final bool selected;
  final VoidCallback onSearch;

  Widget _buildTitle(BuildContext context) {
    return Text(label);
  }
  
  Widget _buildBody(BuildContext context) {
    return SettingsMenu(
      itemBuilder: itemBuilder,
      onSearch: onSearch,
    );
  }

  Widget _buildPage(context) {
    return pageBuilder(
      context,
      _buildTitle(context),
      _buildBody(context),
      onSearch
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
        MaterialPageRoute(builder: _buildPage)
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
    @required this.itemBuilder,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget secondaryText;
  final SettingsMenuItemBuilder itemBuilder;
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
    List<SettingsMenuItem> group = widget.itemBuilder(context);
    return Column(
      children: group.map(
        (item) {
          int index = group.indexOf(item);
          return SettingsMenuItem._(
            item,
            previous: index > 1 ? group[index - 1] : null,
            enabled: _value
          );
        }
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
    @required this.itemBuilder,
    @required this.initialValue,
    this.duplicateSwitchInMenuItem = false,
    this.enabled = true,
    this.selected = false,
    this.onChanged,
    @required this.pageBuilder,
    this.onSearch
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget masterSwitchTitle;
  final StatusBuilder<bool> statusTextBuilder;
  final WidgetBuilder inactiveTextBuilder;
  final SettingsMenuItemBuilder itemBuilder;
  final bool initialValue;
  final bool duplicateSwitchInMenuItem;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final SettingsPageBuilder pageBuilder;
  final VoidCallback onSearch;

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

  Widget _buildStatusText(BuildContext context) {
    if (widget.statusTextBuilder != null)
      return widget.statusTextBuilder(context, _value);

    return _value ? Text(activeLabel) : Text(inactiveLabel);
  }

  Widget _buildDuplicateSwitch(BuildContext context) {
    return widget.duplicateSwitchInMenuItem ? Switch(
      value: _value,
      onChanged: _handleChanged,
    ) : null;
  }


  Widget _buildActive(BuildContext context) {
    return SettingsMenu(
      itemBuilder: widget.itemBuilder,
      onSearch: widget.onSearch,
    );
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

  Widget _buildTitle(BuildContext context) {
    return Text(widget.label);
  }

  Widget _buildBody(BuildContext context) {
    return MasterSwitchMenuItemControl(
        title: widget.masterSwitchTitle,
        value: _value,
        onChanged: widget.onChanged,
        activeBuilder: _buildActive,
        inactiveBuilder: _buildInactive
    );
  }

  Widget _buildPage(BuildContext context) {
    return widget.pageBuilder(
      context,
      _buildTitle(context),
      _buildBody(context),
      widget.onSearch
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: _buildStatusText(context),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildPage)
      ),
      trailing: _buildDuplicateSwitch(context),
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
    @required this.description,
    @required this.initialValue,
    this.enabled = true,
    this.selected = false,
    this.onChanged,
    @required this.pageBuilder,
    this.onSearch
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final Widget description;
  final bool initialValue;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final SettingsPageBuilder pageBuilder;
  final VoidCallback onSearch;

  @override
  _IndividualSwitchMenuItemState createState() => _IndividualSwitchMenuItemState();
}
class _IndividualSwitchMenuItemState extends State<IndividualSwitchMenuItem> {
  bool _value;
  String get _statusLabel => _value ? activeLabel : inactiveLabel;

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

  Widget _buildTitle(BuildContext context) {
    return Text(widget.label);
  }

  Widget _buildBody(BuildContext context) {
    return IndividualSwitchMenuItemControl(
      activeTitleBuilder: (context) => Text(activeLabel),
      inactiveTitleBuilder: (context) => Text(inactiveLabel),
      initialValue: _value,
      description: widget.description,
      onChanged: _handleChanged,
    );
  }

  Widget _buildPage(BuildContext context) {
    return widget.pageBuilder(
      context,
      _buildTitle(context),
      _buildBody(context),
      widget.onSearch
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? Icon(null),
      title: Text(widget.label),
      subtitle: Text(_statusLabel),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: _buildPage)
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
    @required this.description
  }) : super(key: key);

  final WidgetBuilder activeTitleBuilder;
  final WidgetBuilder inactiveTitleBuilder;
  final bool initialValue;
  final Widget description;
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
    widget.onChanged(newValue);
    setState(() {
      _value = newValue;
    });
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
        child: widget.description,
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
    this.page,
    this.parentsTitles,
  });

  final SettingsMenuItem item;
  final SettingsMenuItem page;
  final List<String> parentsTitles;
}

class SettingsSearchDelegate extends SearchDelegate<SettingsMenuItem> {
  SettingsSearchDelegate({
    @required this.itemBuilder
  });

  final SettingsMenuItemBuilder itemBuilder;
  final Iterable<Suggestion> _history = [];

  Iterable<SettingsMenuItem> _getResults(BuildContext context) {
    return itemBuilder(context).where(
      (item) => item.label != null && item.label.contains(query)
    ).toList();
  }

  List<Suggestion> _getSuggestions(BuildContext context, {
    SettingsMenuItem page,
    SettingsMenuItem parent,
    List<Suggestion> suggestions,
    List<String> parentsTitles
  }) {
    List<SettingsMenuItem> data = parent != null ? parent.itemBuilder(context) : this.itemBuilder(context);
    parentsTitles = parentsTitles ?? [];
    suggestions = suggestions ?? [];

    data.forEach((item) {
      List<String> itemParentsTitles;
      bool isPage = _kScreenSettingsMenuItemTypes.contains(item.type);

      if ((item.label ?? '').startsWith(query)) {
        suggestions.add(
          Suggestion(
            page: page,
            item: item,
            parentsTitles: parentsTitles
          )
        );
      }

      if (item.itemBuilder != null) {
        if (isPage) {
          itemParentsTitles = []
            ..addAll(parentsTitles)
            ..add(item.label);
        }

        _getSuggestions(
          context,
          parent: item,
          page: isPage ? item : page,
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
//    BuildContext context,
//    SettingsMenuItemBuilder itemBuilder,
//    SettingsMenuItem selectedItem
//  ) {
//    return itemBuilder(context).map((item) {
//      if (item == selectedItem) {
//        return SettingsMenuItem._(item, selected: true);
//      } else if (item.itemBuilder != null) {
//        List<SettingsMenuItem> itemGroup = item.itemBuilder(context);
//
//        if (itemGroup.isEmpty) return item;
//
//        List<SettingsMenuItem> replacement = _getGroupWithSelected(
//          context,
//          item.itemBuilder,
//          selectedItem
//        );
//        item.itemBuilder = (context) => replacement;
//      }
//
//      return item;
//    }).toList();
//  }

  Widget _buildPage(BuildContext context, Suggestion suggestion) {
    bool hasPage = suggestion.page != null;
    //List<SettingsMenuItem> settings = hasScreen ? suggestion.screen.itemBuilder(context) : itemBuilder(context);

    //settings = _getGroupWithSelected(context, settings, suggestion.item);

    return Scaffold(
      appBar: AppBar(
        title: Text(hasPage ? suggestion.page.label : 'Settings'),
      ),
      body: suggestion.item.builder(context),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final Iterable<Suggestion> suggestions = query.isEmpty
        ? _history
        : _getSuggestions(context);

    return _SuggestionList(
      query: query,
      suggestions: suggestions,
      onSelected: (Suggestion suggestion) {
        query = suggestion.item.label;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _buildPage(context, suggestion)
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
    Iterable<SettingsMenuItem> results = _getResults(context);

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
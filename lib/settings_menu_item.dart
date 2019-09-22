import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';
import 'settings_page.dart';
import 'settings_menu.dart';
import 'section.dart';
import 'single_choice.dart';
import 'multiple_choice.dart';
import 'multiple_choice_list_tile.dart';
import 'slider_list_tile.dart';
import 'date_picker_list_tile.dart';
import 'time_picker_list_tile.dart';
import 'date_time_picker_list_tile.dart';
import 'master_switch.dart';
import 'master_switch_list_tile.dart';
import 'individual_switch.dart';
import 'dependency.dart';

typedef SettingsGroupBuilder<T> = List<SettingsMenuItem<T>> Function(BuildContext context);

enum SettingsMenuItemPattern {
  simpleSwitch,
  section,
  // Selection Patterns
  singleChoice,
  multipleChoice,
  slider,
  date,
  time,
  dateTime,
  listSubpage,
  masterSwitch,
  individualSwitch,
  dependency
}

class SettingsMenuItemBuilder<T> extends StatelessWidget {
  SettingsMenuItemBuilder({
    Key key,
    this.id,
    @required this.label,
    @required this.builder,
    @required this.value,
    this.enabled = true,
    this.dependencyEnabled = true,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.controlBuilder,
    this.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.controlSeparated = false,
    this.selectedId,
    this.onSearch,
    this.showTopDivider,
    this.showBottomDivider,
    @required this.pattern,
  });

  final String id;
  final Text label;
  final bool enabled;
  final bool dependencyEnabled;
  final value;
  final onChanged;
  final onChangeStart;
  final onChangeEnd;
  final StateBuilder<SettingsMenuItemBuilder> builder;
  final StateBuilder<SettingsMenuItemBuilder> controlBuilder;
  final StateBuilder<SettingsMenuItemBuilder> pageContentBuilder;
  final SettingsPageBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final bool controlSeparated;
  final String selectedId;
  final VoidCallback onSearch;
  final bool showTopDivider;
  final bool showBottomDivider;
  final SettingsMenuItemPattern pattern;

  bool get selected => selectedId == id;
  bool get isEnabled => enabled == false ? false : dependencyEnabled;

  SettingsMenuItemBuilder copyWith({
    String id,
    Text label,
    bool enabled,
    bool dependencyEnabled,
    value,
    onChanged,
    onChangeStart,
    onChangeEnd,
    StateBuilder<SettingsMenuItemBuilder> builder,
    StateBuilder<SettingsMenuItemBuilder> controlBuilder,
    StateBuilder<SettingsMenuItemBuilder> pageContentBuilder,
    SettingsPageBuilder pageBuilder,
    SettingsGroupBuilder groupBuilder,
    bool controlSeparated,
    String selectedId,
    VoidCallback onSearch,
    bool showTopDivider,
    bool showBottomDivider,
    SettingsMenuItemPattern pattern
  }) => SettingsMenuItemBuilder(
      id: id ?? this.id,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      dependencyEnabled: dependencyEnabled ?? this.dependencyEnabled,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      onChangeStart: onChangeStart ?? this.onChangeStart,
      onChangeEnd: onChangeEnd ?? this.onChangeEnd,
      builder: builder ?? this.builder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      groupBuilder: groupBuilder ?? this.groupBuilder,
      controlSeparated: controlSeparated ?? this.controlSeparated,
      selectedId: selectedId ?? this.selectedId,
      onSearch: onSearch ?? this.onSearch,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      pattern: pattern ?? this.pattern
  );

  SettingsMenuItemBuilder copyFrom(SettingsMenuItemBuilder widget) => SettingsMenuItemBuilder(
      id: widget.id ?? this.id,
      label: widget.label ?? this.label,
      enabled: widget.enabled ?? this.enabled,
      dependencyEnabled: widget.dependencyEnabled ?? this.dependencyEnabled,
      value: widget.value ?? this.value,
      onChanged: widget.onChanged ?? this.onChanged,
      onChangeStart: widget.onChangeStart ?? this.onChangeStart,
      onChangeEnd: widget.onChangeEnd ?? this.onChangeEnd,
      builder: widget.builder ?? this.builder,
      controlBuilder: widget.controlBuilder ?? this.controlBuilder,
      pageContentBuilder: widget.pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: widget.pageBuilder ?? this.pageBuilder,
      groupBuilder: widget.groupBuilder ?? this.groupBuilder,
      controlSeparated: widget.controlSeparated ?? this.controlSeparated,
      selectedId: widget.selectedId ?? this.selectedId,
      onSearch: widget.onSearch ?? this.onSearch,
      showTopDivider: widget.showTopDivider ?? this.showTopDivider,
      showBottomDivider: widget.showBottomDivider ?? this.showBottomDivider,
      pattern: widget.pattern ?? this.pattern
  );

  Widget buildPage(BuildContext context) {
    Widget title = label;
    Widget body = pageContentBuilder(context, this);
    return (this.pageBuilder ?? SettingsPage.pageBuilder)(
        context,
        title,
        body,
        onSearch
    );
  }

  Widget buildStateful(BuildContext context) {
    ValueNotifier _notifier = ValueNotifier(value);

    void handleChanged(newValue) {
      if (onChanged != null) onChanged(newValue);
      _notifier.value = newValue;
    }

    statefulBuilder(StateBuilder<SettingsMenuItemBuilder> builder)
      => (context, widget)
      => ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (context, newValue, _) => builder(
            context,
            widget.copyWith(value: newValue)
          )
      );

    SettingsMenuItemBuilder widget = this.copyWith(
      builder: statefulBuilder(builder),
      controlBuilder: statefulBuilder(controlBuilder),
      onChanged: handleChanged
    );

    return widget.builder(context, widget);
  }

  @override
  Widget build(BuildContext context) => builder(context, this);
}

class SettingsMenuItem<T> extends SettingsMenuItemBuilder<T> {
  SettingsMenuItem.simpleSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Widget secondaryText,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => SwitchListTile(
      secondary: leading ?? Icon(null),
      title: label,
      subtitle: secondaryText,
      value: widget.value,
      selected: widget.selected,
      onChanged: widget.enabled
        ? (widget.onChanged ?? (value) => null)
        : null
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.simpleSwitch
  );

  SettingsMenuItem.section({
    Key key,
    Widget title,
    @required SettingsGroupBuilder groupBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => Section(
      title: title,
      content: SettingsMenu(
        groupBuilder: groupBuilder,
        enabled: widget.isEnabled,
        selectedId: widget.selectedId,
        onSearch: widget.onSearch,
        scrolled: false,
      ),
      enabled: widget.isEnabled,
      showTopDivider: widget.showTopDivider ?? true,
      showBottomDivider: widget.showBottomDivider ?? true
    ),
    enabled: enabled,
    groupBuilder: groupBuilder,
    pattern: SettingsMenuItemPattern.section
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<Choice<T>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required T initialValue,
    SettingsPageBuilder pageBuilder,
    bool enabled = true,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (context, widget) {
      T value = widget.value;
      Choice<T> selectedChoice = choices.firstWhere((choice) => choice.value == value);
      Widget secondaryText = (statusTextBuilder != null)
        ? statusTextBuilder(context, selectedChoice)
        : selectedChoice.label;
      return ListTile(
        leading: leading ?? Icon(null),
        title: label,
        subtitle: secondaryText,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: widget.buildPage
          )
        ),
        selected: widget.selected,
        enabled: widget.isEnabled,
      );
    },
    controlBuilder: (context, widget) => SingleChoice<T>(
      choices: choices,
      value: widget.value,
      onChanged: widget.onChanged,
    ),
    pageContentBuilder: (context, widget) => widget.controlBuilder(context, widget),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.singleChoice
  );

  SettingsMenuItem.multipleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<List<Choice<T>>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required List<T> initialValue,
    bool enabled = true,
    ValueChanged<List<T>> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => MultipleChoiceListTile<T>(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      controlBuilder: (context) => widget.controlBuilder(context, widget),
      choices: choices,
      value: widget.value,
      enabled: widget.isEnabled,
      selected: widget.selected,
    ),
    controlBuilder: (context, widget) =>  MultipleChoice<T>(
      choices: choices,
      value: widget.value,
      onChanged: widget.onChanged
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.multipleChoice
  );

  SettingsMenuItem.slider({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Widget secondaryText,
    @required double initialValue,
    double min = 0.0,
    double max = 1.0,
    int divisions,
    Color activeColor,
    Color inactiveColor,
    SemanticFormatterCallback semanticFormatterCallback,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeStart,
    ValueChanged<double> onChangeEnd,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => SliderListTile(
      secondary: leading ?? Icon(null),
      title: label,
      value: widget.value,
      selected: widget.selected,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      semanticFormatterCallback: semanticFormatterCallback,
      onChanged: widget.enabled ? widget.onChanged : null,
      onChangeStart: widget.enabled ? widget.onChangeStart : null,
      onChangeEnd: widget.enabled ? widget.onChangeEnd : null,
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    onChangeStart: onChangeStart,
    onChangeEnd: onChangeEnd,
    pattern: SettingsMenuItemPattern.slider
  );

  SettingsMenuItem.date({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => DatePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: widget.isEnabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.date
  );

  SettingsMenuItem.time({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<TimeOfDay> statusTextBuilder,
    @required TimeOfDay initialValue,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<TimeOfDay> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => TimePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      builder: builder,
      enabled: widget.isEnabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.time
  );

  SettingsMenuItem.dateTime({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    SelectableDayPredicate selectableDayPredicate,
    Locale locale,
    TextDirection textDirection,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => DateTimePickerListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      textDirection: textDirection,
      builder: builder,
      enabled: widget.isEnabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    pattern: SettingsMenuItemPattern.dateTime
  );

  SettingsMenuItem.listSubpage({
    Key key,
    @required String id,
    @required Text label,
    Widget leading,
    Widget secondaryText,
    @required SettingsGroupBuilder groupBuilder,
    @required SettingsPageBuilder pageBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: secondaryText,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
      selected: widget.selected,
      enabled: widget.isEnabled,
    ),
    pageContentBuilder: (context, widget) => SettingsMenu(
      groupBuilder: groupBuilder,
      onSearch: widget.onSearch,
      selectedId: widget.selectedId,
    ),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    groupBuilder: groupBuilder,
    pattern: SettingsMenuItemPattern.listSubpage
  );

  SettingsMenuItem.masterSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    Text switchTitle,
    ValueBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveBuilder,
    bool duplicateSwitch = false,
    @required SettingsGroupBuilder groupBuilder,
    @required bool initialValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
    @required SettingsPageBuilder pageBuilder
  }) : super(
    key: key,
    builder: (context, widget) => MasterSwitchListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      showSwitch: duplicateSwitch,
      value: widget.value,
      enabled: widget.isEnabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
    ),
    controlBuilder: (context, widget) => MasterSwitch(
      title: switchTitle ?? Text('Use ${label.data}'),
      value: widget.value,
      onChanged: widget.onChanged,
      activeContentBuilder: (context) => SettingsMenu(
        groupBuilder: groupBuilder,
        onSearch: widget.onSearch,
        selectedId: widget.selectedId
      ),
      inactiveContentBuilder: (context) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16.0).copyWith(left: 72.0),
        child: inactiveBuilder(context),
      )
    ),
    pageContentBuilder: (context, widget)
      => widget.controlBuilder(context, widget),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    @required Widget description,
    @required bool initialValue,
    bool enabled = true,
    @required SettingsPageBuilder pageBuilder,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: label,
      subtitle: Text(
        widget.value
          ? SettingsLocalizations.activeLabel
          : SettingsLocalizations.inactiveLabel
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget
        )
      ),
      selected: widget.selected,
      enabled: widget.isEnabled,
    ),
    controlBuilder: (context, widget) => IndividualSwitch(
      value: widget.value,
      description: description,
      onChanged: widget.onChanged,
    ),
    pageContentBuilder: (context, widget) => widget.controlBuilder(context, widget),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsMenuItemPattern.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<bool> statusTextBuilder,
    @required SettingsGroupBuilder groupBuilder,
    @required bool initialValue,
    ValueChanged<bool> onChanged,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => widget.controlBuilder(context, widget),
    controlBuilder: (context, widget) => Dependency(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      dependentBuilder: (context, dependencyEnabled) => SettingsMenu(
        groupBuilder: groupBuilder,
        enabled: dependencyEnabled,
        selectedId: widget.selectedId,
        onSearch: widget.onSearch,
        scrolled: false
      ),
      dependencyEnabled: widget.value,
      enabled: widget.isEnabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    value: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    pattern: SettingsMenuItemPattern.dependency
  );

//  final ValueNotifier _valueNotifier = ValueNotifier(null);
//  void _handleChanged(newValue) {
//    if (onChanged != null) onChanged(newValue);
//    _valueNotifier.value = newValue;
//  }
//
//  Widget _buildValueListenable(
//      BuildContext context,
//      SettingsStateBuilder builder
//      ) => ValueListenableBuilder(
//      valueListenable: _valueNotifier,
//      builder: (context, value, _) => builder(
//          context,
//          this.copyWith(
//            value: value,
//            onChanged: _handleChanged,
//          )
//      )
//  );
//
//  Widget buildControl(BuildContext context)
//  => _buildValueListenable(context, controlBuilder);

//  Widget _build(BuildContext context) {
//    return controlSeparated
//        ? _buildValueListenable(context, this.builder)
//        : this.builder(context, this);
//  }
//
//  @override
//  Widget build(BuildContext context) => _build(context);

  //@override
  //Widget build(BuildContext context) => builder(context, this);
}
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

typedef SettingsGroupBuilder<T> = List<SettingsMenuItemBuilder<T>> Function(BuildContext context);
typedef SettingsGroupItemBuilder<T> = SettingsMenuItemBuilder Function(SettingsMenuItemBuilder item);
typedef WidgetStateBuilder<T> = Widget Function(BuildContext context, T widget);
typedef SettingsMenuItemStateBuilder = Widget Function(
    BuildContext context,
    SettingsMenuItemBuilder widget
);

enum SettingsPattern {
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
    this.label,
    @required this.builder,
    @required this.initialValue,
    this.value,
    this.enabled = true,
    this.onChanged,
    this.controlBuilder,
    this.pageBuilder = SettingsPageRoute.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.controlSeparated = false,
    this.selectedId,
    this.onShowSearch,
    this.showTopDivider,
    this.showBottomDivider,
    @required this.pattern,
  }) :
    assert(pageBuilder != null),
    assert(builder != null),
    super(key: key);

  final String id;
  final Text label;
  final bool enabled;
  final initialValue;
  final value;
  final onChanged;
  final SettingsMenuItemStateBuilder builder;
  final SettingsMenuItemStateBuilder controlBuilder;
  final SettingsMenuItemStateBuilder pageContentBuilder;
  final SettingsPageRouteBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final bool controlSeparated;
  final String selectedId;
  final VoidCallback onShowSearch;
  final bool showTopDivider;
  final bool showBottomDivider;
  final SettingsPattern pattern;

  bool get selected => selectedId == id;

  SettingsMenuItemBuilder copyWith({
    String id,
    Text label,
    bool enabled,
    initialValue,
    value,
    onChanged,
    SettingsMenuItemStateBuilder builder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsPageRouteBuilder pageBuilder,
    SettingsGroupBuilder groupBuilder,
    bool controlSeparated,
    String selectedId,
    VoidCallback onShowSearch,
    bool showTopDivider,
    bool showBottomDivider,
    SettingsPattern pattern
  }) => SettingsMenuItemBuilder(
      id: id ?? this.id,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      initialValue: initialValue ?? this.initialValue,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      builder: builder ?? this.builder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      groupBuilder: groupBuilder ?? this.groupBuilder,
      controlSeparated: controlSeparated ?? this.controlSeparated,
      selectedId: selectedId ?? this.selectedId,
      onShowSearch: onShowSearch ?? this.onShowSearch,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      pattern: pattern ?? this.pattern
  );

  SettingsMenuItemBuilder makeStateful() {
    ValueNotifier _notifier = ValueNotifier(initialValue);

    void handleChanged(newValue) {
      if (onChanged != null) onChanged(newValue);
      _notifier.value = newValue;
    }

    statefulBuilder(SettingsMenuItemStateBuilder builder)
      => (context, widget)
      => ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, newValue, _)
          => builder(
            context,
            widget.copyWith(value: newValue)
          )
      );

    return this.copyWith(
        builder: statefulBuilder(builder),
        controlBuilder: statefulBuilder(controlBuilder),
        onChanged: handleChanged
    );
  }

  Widget buildPage(BuildContext context) {
    return pageBuilder(
        context,
        label,
        pageContentBuilder(context, this),
        onShowSearch
    );
  }

  @override
  Widget build(BuildContext context) => builder(context, this);
}

class SettingsMenuItem<T> extends SettingsMenuItemBuilder<T> {
  SettingsMenuItem.builder({
    Key key,
    @required String id,
    @required SettingsMenuItemStateBuilder builder,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsGroupBuilder groupBuilder,
    Text label,
    @required T initialValue,
    bool enabled = true,
    ValueChanged<T> onChanged,
  }) : super(
    key: key,
    id: id,
    label: label,
    initialValue: initialValue,
    enabled: enabled,
    onChanged: onChanged,
    builder: builder
  );

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
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsPattern.simpleSwitch
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
      content: SettingsMenu.column(
        groupBuilder: groupBuilder,
        itemBuilder: (item) => item.copyWith(
          onShowSearch: widget.onShowSearch,
          selectedId: widget.selectedId,
          enabled: widget.enabled
        )
      ),
      enabled: widget.enabled,
      showTopDivider: widget.showTopDivider ?? true,
      showBottomDivider: widget.showBottomDivider ?? true
    ),
    enabled: enabled,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.section
  );

  SettingsMenuItem.singleChoice({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    ValueBuilder<Choice<T>> statusTextBuilder,
    @required List<Choice<T>> choices,
    @required T initialValue,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
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
        enabled: widget.enabled,
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
    initialValue: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsPattern.singleChoice
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
      enabled: widget.enabled,
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
    initialValue: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsPattern.multipleChoice
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
      onChangeStart: widget.enabled ? onChangeStart : null,
      onChangeEnd: widget.enabled ? onChangeEnd : null,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsPattern.slider
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
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsPattern.date
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
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsPattern.time
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
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    pattern: SettingsPattern.dateTime
  );

  SettingsMenuItem.listSubpage({
    Key key,
    @required String id,
    @required Text label,
    Widget leading,
    Widget secondaryText,
    @required SettingsGroupBuilder groupBuilder,
    SettingsPageRouteBuilder pageBuilder  = SettingsPageRoute.pageBuilder,
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
      enabled: widget.enabled,
    ),
    pageContentBuilder: (context, widget) => SettingsMenu(
      groupBuilder: groupBuilder,
      itemBuilder: (item) => item.copyWith(
        onShowSearch: widget.onShowSearch,
        selectedId: widget.selectedId
      )
    ),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    enabled: enabled,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.listSubpage
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
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder
  }) : super(
    key: key,
    builder: (context, widget) => MasterSwitchListTile(
      leading: leading ?? Icon(null),
      title: label,
      statusTextBuilder: statusTextBuilder,
      showSwitch: duplicateSwitch,
      value: widget.value,
      enabled: widget.enabled,
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
        itemBuilder: (item) => item.copyWith(
          onShowSearch: widget.onShowSearch,
          selectedId: widget.selectedId
        ),
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
    initialValue: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    controlSeparated: true,
    pattern: SettingsPattern.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required Text label,
    @required Widget description,
    @required bool initialValue,
    bool enabled = true,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
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
      enabled: widget.enabled,
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
    initialValue: initialValue,
    onChanged: onChanged,
    controlSeparated: true,
    pattern: SettingsPattern.individualSwitch
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
      dependentBuilder: (context, dependencyEnabled) => SettingsMenu.column(
        groupBuilder: groupBuilder,
        itemBuilder: (item) => item.copyWith(
          enabled: item.enabled == false ? false : dependencyEnabled,
          selectedId: widget.selectedId,
          onShowSearch: widget.onShowSearch,
        )
      ),
      dependencyEnabled: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    id: id,
    label: label,
    enabled: enabled,
    initialValue: initialValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.dependency
  );
}
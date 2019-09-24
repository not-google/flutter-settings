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

typedef SettingsGroupBuilder = List<SettingsMenuItemBuilder> Function(BuildContext context);
typedef SettingsGroupItemBuilder = SettingsMenuItemBuilder Function(SettingsMenuItemBuilder item);
typedef WidgetStateBuilder<T> = Widget Function(BuildContext context, T widget);
typedef SettingsMenuItemStateBuilder = Widget Function(
    BuildContext context,
    SettingsMenuItemBuilder widget
);

enum SettingsPattern {
  custom,
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

const List<SettingsPattern> patternsWithSeparatedControls = [
  SettingsPattern.multipleChoice,
  SettingsPattern.singleChoice,
  SettingsPattern.masterSwitch,
  SettingsPattern.individualSwitch
];

class SettingsMenuItemBuilder extends StatelessWidget {
  SettingsMenuItemBuilder({
    @required this.key,
    this.title,
    @required this.builder,
    @required this.defaultValue,
    this.value,
    this.enabled = true,
    this.onChanged,
    this.controlBuilder,
    this.pageBuilder = SettingsPageRoute.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.selectedKey,
    this.onShowSearch,
    this.showTopDivider = true,
    this.showBottomDivider = true,
    this.pattern,
  }) :
    assert(key != null),
    assert(builder != null),
    assert(pageBuilder != null),
    super(key: key);

  final Key key;
  final Text title;
  final bool enabled;
  final defaultValue;
  final value;
  final onChanged;
  final SettingsMenuItemStateBuilder builder;
  final SettingsMenuItemStateBuilder controlBuilder;
  final SettingsMenuItemStateBuilder pageContentBuilder;
  final SettingsPageRouteBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final Key selectedKey;
  final VoidCallback onShowSearch;
  final bool showTopDivider;
  final bool showBottomDivider;
  final SettingsPattern pattern;

  bool get selected => selectedKey != null && selectedKey == key;
  // Whether the widget control is separated from the menu item and requires
  // a separated rebuild (example: widget is part of subpage)
  bool get separated => patternsWithSeparatedControls.contains(pattern);

  SettingsMenuItemBuilder copyWith({
    Key key,
    Text title,
    bool enabled,
    defaultValue,
    value,
    onChanged,
    SettingsMenuItemStateBuilder builder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsPageRouteBuilder pageBuilder,
    SettingsGroupBuilder groupBuilder,
    Key selectedKey,
    VoidCallback onShowSearch,
    bool showTopDivider,
    bool showBottomDivider,
    SettingsPattern pattern
  }) => SettingsMenuItemBuilder(
      key: key ?? this.key,
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      defaultValue: defaultValue ?? this.defaultValue,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      builder: builder ?? this.builder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      groupBuilder: groupBuilder ?? this.groupBuilder,
      selectedKey: selectedKey ?? this.selectedKey,
      onShowSearch: onShowSearch ?? this.onShowSearch,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      pattern: pattern ?? this.pattern
  );

  SettingsMenuItemBuilder makeStateful() {
    ValueNotifier _notifier = ValueNotifier(value ?? defaultValue);

    void handleChanged(newValue) {
      if (onChanged != null) onChanged(newValue);
      _notifier.value = newValue;
    }

    statefulBuilder(SettingsMenuItemStateBuilder builder)
      => (BuildContext context, SettingsMenuItemBuilder widget)
      => ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (context, newValue, _) => builder(
            context,
            widget.copyWith(
              value: newValue
            )
          )
        );

    return this.copyWith(
        builder: statefulBuilder(builder),
        controlBuilder: separated ? statefulBuilder(controlBuilder) : controlBuilder,
        onChanged: handleChanged
    );
  }

  Widget buildControl(BuildContext context) {
    return controlBuilder(context, this);
  }

  Widget buildPage(BuildContext context) {
    return pageBuilder(
        context,
        title,
        pageContentBuilder(context, this),
        onShowSearch
    );
  }

  @override
  Widget build(BuildContext context) => builder(context, this);
}

class SettingsMenuItem extends SettingsMenuItemBuilder {
  SettingsMenuItem.custom({
    @required Key key,
    @required SettingsMenuItemStateBuilder builder,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsGroupBuilder groupBuilder,
    Text title,
    @required String defaultValue,
    bool enabled = true,
    ValueChanged<String> onChanged,
  }) : super(
    key: key,
    title: title,
    defaultValue: defaultValue,
    value: defaultValue,
    enabled: enabled,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    builder: builder,
    controlBuilder: controlBuilder,
    pageBuilder: pageBuilder,
    pageContentBuilder: pageContentBuilder
  );

  SettingsMenuItem.simpleSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    Widget subtitle,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => SwitchListTile(
      secondary: leading ?? Icon(null),
      title: title,
      subtitle: subtitle,
      value: widget.value,
      selected: widget.selected,
      onChanged: widget.enabled
        ? (widget.onChanged ?? (value) => null)
        : null
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.simpleSwitch
  );

  SettingsMenuItem.section({
    @required Key key,
    Text title,
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
          selectedKey: widget.selectedKey,
          enabled: widget.enabled
        )
      ),
      enabled: widget.enabled,
      showTopDivider: widget.showTopDivider,
      showBottomDivider: widget.showBottomDivider
    ),
    enabled: enabled,
    defaultValue: null,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.section
  );

  SettingsMenuItem.singleChoice({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<Choice> statusTextBuilder,
    @required List<Choice> choices,
    @required String defaultValue,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    bool enabled = true,
    ValueChanged<String> onChanged
  }) : super(
    key: key,
    builder: (context, widget) {
      String value = widget.value;
      Choice selectedChoice = choices.firstWhere((choice) => choice.value == value);
      Widget subtitle = (statusTextBuilder != null)
        ? statusTextBuilder(context, selectedChoice)
        : selectedChoice.title;
      return ListTile(
        leading: leading ?? Icon(null),
        title: title,
        subtitle: subtitle,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: widget.buildPage
          )
        ),
        selected: widget.selected,
        enabled: widget.enabled,
      );
    },
    controlBuilder: (context, widget) => SingleChoice(
      choices: choices,
      value: widget.value,
      onChanged: widget.onChanged,
    ),
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.singleChoice
  );

  SettingsMenuItem.multipleChoice({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<List<Choice>> statusTextBuilder,
    @required List<Choice> choices,
    @required List<String> defaultValue,
    bool enabled = true,
    ValueChanged<List<String>> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => MultipleChoiceListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      controlBuilder: (context) => widget.buildControl(context),
      choices: choices,
      value: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
    ),
    controlBuilder: (context, widget) =>  MultipleChoice(
      choices: choices,
      value: widget.value,
      onChanged: widget.onChanged
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.multipleChoice
  );

  SettingsMenuItem.slider({
    @required Key key,
    Widget leading,
    @required Text title,
    Widget subtitle,
    @required double defaultValue,
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
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => SliderListTile(
      secondary: leading ?? Icon(null),
      title: title,
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
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.slider
  );

  SettingsMenuItem.date({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime defaultValue,
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
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => DatePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
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
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.date
  );

  SettingsMenuItem.time({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<TimeOfDay> statusTextBuilder,
    @required TimeOfDay defaultValue,
    TransitionBuilder builder,
    bool enabled = true,
    ValueChanged<TimeOfDay> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => TimePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      value: widget.value,
      builder: builder,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.time
  );

  SettingsMenuItem.dateTime({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<DateTime> statusTextBuilder,
    @required DateTime defaultValue,
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
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => DateTimePickerListTile(
      leading: leading ?? Icon(null),
      title: title,
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
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.dateTime
  );

  SettingsMenuItem.listSubpage({
    @required Key key,
    @required Text title,
    Widget leading,
    Widget subtitle,
    @required SettingsGroupBuilder groupBuilder,
    SettingsPageRouteBuilder pageBuilder  = SettingsPageRoute.pageBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: title,
      subtitle: subtitle,
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
        selectedKey: widget.selectedKey
      )
    ),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: null,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.listSubpage
  );

  SettingsMenuItem.masterSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    Text switchTitle,
    ValueBuilder<bool> statusTextBuilder,
    @required WidgetBuilder inactiveBuilder,
    bool duplicateSwitch = false,
    @required SettingsGroupBuilder groupBuilder,
    @required bool defaultValue,
    bool enabled = true,
    ValueChanged<bool> onChanged,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder
  }) : super(
    key: key,
    builder: (context, widget) => MasterSwitchListTile(
      leading: leading ?? Icon(null),
      title: title,
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
      title: switchTitle ?? Text('Use ${title.data}'),
      value: widget.value,
      onChanged: widget.onChanged,
      activeContentBuilder: (context) => SettingsMenu(
        groupBuilder: groupBuilder,
        itemBuilder: (item) => item.copyWith(
          onShowSearch: widget.onShowSearch,
          selectedKey: widget.selectedKey
        ),
      ),
      inactiveContentBuilder: (context) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16.0).copyWith(left: 72.0),
        child: inactiveBuilder(context),
      )
    ),
    pageContentBuilder: (context, widget)
      => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.masterSwitch
  );

  SettingsMenuItem.individualSwitch({
    @required Key key,
    Widget leading,
    @required Text title,
    @required Widget description,
    @required bool defaultValue,
    bool enabled = true,
    SettingsPageRouteBuilder pageBuilder = SettingsPageRoute.pageBuilder,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, widget) => ListTile(
      leading: leading ?? Icon(null),
      title: title,
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
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    pattern: SettingsPattern.individualSwitch
  );

  SettingsMenuItem.dependency({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<bool> statusTextBuilder,
    @required SettingsGroupBuilder groupBuilder,
    @required bool defaultValue,
    ValueChanged<bool> onChanged,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, widget) => widget.buildControl(context),
    controlBuilder: (context, widget) => Dependency(
      leading: leading ?? Icon(null),
      title: title,
      statusTextBuilder: statusTextBuilder,
      dependentBuilder: (context, dependencyEnabled) => SettingsMenu.column(
        groupBuilder: groupBuilder,
        itemBuilder: (item) => item.copyWith(
          enabled: item.enabled == false ? false : dependencyEnabled,
          selectedKey: widget.selectedKey,
          onShowSearch: widget.onShowSearch,
        )
      ),
      dependencyEnabled: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChanged,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChanged: onChanged,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.dependency
  );
}
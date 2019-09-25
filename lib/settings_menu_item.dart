import 'package:flutter/material.dart';
import 'settings_localizations.dart';
import 'types.dart';
import 'choice.dart';
import 'settings_page_route.dart';
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
// return value
typedef OnGetPreloaded<T> = T Function(Key key);
typedef OnGetValue<T> = Future<T> Function(Key key);
// return bool of success or failed saved
typedef OnSetValue<T> = Future<bool> Function(Key key, T value);

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
    this.onChangeSaved,
    this.onShowSearch,
    this.onGetPreloaded,
    this.onGetValue,
    this.onSetValue,
    this.controlBuilder,
    this.pageBuilder = SettingsPageRoute.pageBuilder,
    this.pageContentBuilder,
    this.groupBuilder,
    this.selectedKey,
    this.showTopDivider = true,
    this.showBottomDivider = true,
    this.valueLoaded = false,
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
  final onChangeSaved;
  final VoidCallback onShowSearch;
  final OnGetPreloaded onGetPreloaded;
  final OnGetValue onGetValue;
  final OnSetValue onSetValue;
  final SettingsMenuItemStateBuilder builder;
  final SettingsMenuItemStateBuilder controlBuilder;
  final SettingsMenuItemStateBuilder pageContentBuilder;
  final SettingsPageRouteBuilder pageBuilder;
  final SettingsGroupBuilder groupBuilder;
  final Key selectedKey;
  final bool showTopDivider;
  final bool showBottomDivider;
  final bool valueLoaded;
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
    onChangeSaved,
    OnGetPreloaded onGetPreloaded,
    OnGetValue onGetValue,
    OnSetValue onSetValue,
    VoidCallback onShowSearch,
    SettingsMenuItemStateBuilder builder,
    SettingsMenuItemStateBuilder controlBuilder,
    SettingsMenuItemStateBuilder pageContentBuilder,
    SettingsPageRouteBuilder pageBuilder,
    SettingsGroupBuilder groupBuilder,
    Key selectedKey,
    bool showTopDivider,
    bool showBottomDivider,
    bool valueLoaded,
    SettingsPattern pattern
  }) => SettingsMenuItemBuilder(
      key: key ?? this.key,
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      defaultValue: defaultValue ?? this.defaultValue,
      value: value ?? this.value,
      onChangeSaved: onChangeSaved ?? this.onChangeSaved,
      onGetPreloaded: onGetPreloaded ?? this.onGetPreloaded,
      onGetValue: onGetValue ?? this.onGetValue,
      onSetValue: onSetValue ?? this.onSetValue,
      builder: builder ?? this.builder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageContentBuilder ?? this.pageContentBuilder,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      groupBuilder: groupBuilder ?? this.groupBuilder,
      selectedKey: selectedKey ?? this.selectedKey,
      onShowSearch: onShowSearch ?? this.onShowSearch,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      valueLoaded: valueLoaded ?? this.valueLoaded,
      pattern: pattern ?? this.pattern
  );

  dynamic getPreloaded() => onGetPreloaded != null ? onGetPreloaded(key) : value;
  Future<dynamic> getValue() async => onGetValue(key);
  Future<bool> setValue(value) async => onSetValue(key, value);

  SettingsMenuItemBuilder makeStateful() {
    ValueNotifier _notifier = ValueNotifier(
      getPreloaded() ?? defaultValue
    );

    if (onGetPreloaded == null && onGetValue != null) {
      getValue().then((value) => _notifier.value = value);
    }

    void handleChangeSaved(newValue) async {
      if (onSetValue != null) {
        dynamic successSaved = await setValue(newValue);
        if (!successSaved) {
          print('Failed to save change.');
          print('Key: ${key.toString()}');
          print('Old value: $value');
          print('New value: $value');
          return value;
        }
      }

      if (onChangeSaved != null) onChangeSaved(newValue);
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
        onChangeSaved: handleChangeSaved,
        valueLoaded: true
    );
  }

  Widget buildControl(BuildContext context) {
    return controlBuilder(context, this.copyWith(
      value: value ?? defaultValue
    ));
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
    ValueChanged<String> onChangeSaved,
  }) : super(
    key: key,
    title: title,
    defaultValue: defaultValue,
    value: defaultValue,
    enabled: enabled,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<bool> onChangeSaved,
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
        ? (widget.onChangeSaved ?? (value) => null)
        : null
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    onChangeSaved: onChangeSaved,
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
          onGetPreloaded: widget.onGetPreloaded,
          onGetValue: widget.onGetValue,
          onSetValue: widget.onSetValue,
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
    ValueChanged<String> onChangeSaved
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
      onChanged: widget.onChangeSaved,
    ),
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<List<String>> onChangeSaved
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
      onChanged: widget.onChangeSaved
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<double> onChangeSaved,
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
      onChanged: widget.enabled ? widget.onChangeSaved : null,
      onChangeStart: widget.enabled ? onChangeStart : null,
      onChangeEnd: widget.enabled ? onChangeEnd : null,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<DateTime> onChangeSaved
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
      onChanged: widget.onChangeSaved,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<TimeOfDay> onChangeSaved
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
      onChanged: widget.onChangeSaved,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
    ValueChanged<DateTime> onChangeSaved
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
      onChanged: widget.onChangeSaved,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
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
        onGetPreloaded: widget.onGetPreloaded,
        onGetValue: widget.onGetValue,
        onSetValue: widget.onSetValue,
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
    ValueChanged<bool> onChangeSaved,
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
      onChanged: widget.onChangeSaved,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: widget.buildPage
        )
      ),
    ),
    controlBuilder: (context, widget) => MasterSwitch(
      title: switchTitle ?? Text('Use ${title.data}'),
      value: widget.value,
      onChanged: widget.onChangeSaved,
      activeContentBuilder: (context) => SettingsMenu(
        groupBuilder: groupBuilder,
        itemBuilder: (item) => item.copyWith(
          onGetPreloaded: widget.onGetPreloaded,
          onGetValue: widget.onGetValue,
          onSetValue: widget.onSetValue,
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
    onChangeSaved: onChangeSaved,
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
    ValueChanged<bool> onChangeSaved
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
          builder: widget.buildPage
        )
      ),
      selected: widget.selected,
      enabled: widget.enabled,
    ),
    controlBuilder: (context, widget) => IndividualSwitch(
      value: widget.value,
      description: description,
      onChanged: widget.onChangeSaved,
    ),
    pageContentBuilder: (context, widget) => widget.buildControl(context),
    pageBuilder: pageBuilder,
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
    pattern: SettingsPattern.individualSwitch
  );

  SettingsMenuItem.dependency({
    @required Key key,
    Widget leading,
    @required Text title,
    ValueBuilder<bool> statusTextBuilder,
    @required SettingsGroupBuilder groupBuilder,
    @required bool defaultValue,
    ValueChanged<bool> onChangeSaved,
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
          onGetPreloaded: widget.onGetPreloaded,
          onGetValue: widget.onGetValue,
          onSetValue: widget.onSetValue,
        )
      ),
      dependencyEnabled: widget.value,
      enabled: widget.enabled,
      selected: widget.selected,
      onChanged: widget.onChangeSaved,
    ),
    title: title,
    enabled: enabled,
    defaultValue: defaultValue,
    value: defaultValue,
    onChangeSaved: onChangeSaved,
    groupBuilder: groupBuilder,
    pattern: SettingsPattern.dependency
  );
}
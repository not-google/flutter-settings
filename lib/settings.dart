import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const String activeLabel = 'On';
const String inactiveLabel = 'Off';
const double _kListTileHeight = 56.0;
const double _kSecondaryWidth = 50.0;
const double _kDividerHeight = 1.0;
const List<SettingsMenuItemType> _kPageSettingsMenuItemTypes = [
  SettingsMenuItemType.listSubpage,
  SettingsMenuItemType.masterSwitch,
  SettingsMenuItemType.individualSwitch
];

typedef SettingsPageBuilder<T> = Widget Function(
  BuildContext context,
  Widget title,
  Widget body,
  VoidCallback onSearch,
);
typedef SettingsItemBuilder<T> = List<SettingsMenuItem<T>> Function(BuildContext context);
typedef StatusBuilder<T> = Widget Function(BuildContext context, T status);
typedef StateBuilder<T> = Widget Function(BuildContext context, T state);

enum SettingsMenuItemType {
  toggleSwitch,
  section,
  // Selection Patterns
  singleChoice,
  multipleChoice,
  slider,
  dateTime,
  listSubpage,
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
    this.id,
    @required this.builder,
    this.controlBuilder,
    this.pageBuilder,
    this.pageContentBuilder,
    @required this.label,
    this.itemBuilder,
    this.needUpdateOnChanged = false,
    @required this.type,
  });

  final String id;
  final String label;
  final StateBuilder<SettingsMenuItemState> builder;
  final StateBuilder<SettingsMenuItemState> controlBuilder;
  final StateBuilder<SettingsMenuItemState> pageContentBuilder;
  final SettingsPageBuilder pageBuilder;
  final SettingsItemBuilder itemBuilder;
  final bool needUpdateOnChanged;
  final SettingsMenuItemType type;
}

class SettingsMenuItemState<T> {
  SettingsMenuItemState({
    this.selected,
    this.enabled,
    this.showTopDivider,
    this.showBottomDivider,
    this.value,
    this.onChanged,
    this.pageBuilder,
    this.controlBuilder,
    this.pageContentBuilder,
    this.onSearch
  });

  final bool selected;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;
  final T value;
  final ValueChanged<T> onChanged;
  final VoidCallback onSearch;
  final WidgetBuilder pageBuilder;
  final WidgetBuilder controlBuilder;
  final WidgetBuilder pageContentBuilder;

  SettingsMenuItemState<T> copyWith({
    bool selected,
    bool enabled,
    bool showTopDivider,
    bool showBottomDivider,
    ValueChanged<T> onChanged,
    VoidCallback onSearch,
    T value,
    WidgetBuilder pageBuilder,
    WidgetBuilder controlBuilder,
    WidgetBuilder pageContentBuilder,
  }) {
    return SettingsMenuItemState(
      selected: selected ?? this.selected,
      enabled: enabled ?? this.enabled,
      showTopDivider: showTopDivider ?? this.showTopDivider,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      onChanged: onChanged ?? this.onChanged,
      onSearch: onSearch ?? this.onSearch,
      value: value ?? this.value,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      controlBuilder: controlBuilder ?? this.controlBuilder,
      pageContentBuilder: pageBuilder ?? this.pageContentBuilder,
    );
  }
}

class SettingsMenuItem<T> extends SettingsMenuEntry<T> {
  SettingsMenuItem.toggleSwitch({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required bool initialValue,
    bool enabled = true,
    bool selected = false,
    ValueChanged<bool> onChanged,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context),
    controlBuilder: (context, state) => SwitchListTile(
        secondary: leading ?? Icon(null),
        title: Text(label),
        subtitle: secondaryText,
        value: state.value ?? initialValue,
        selected: state.selected ?? selected,
        onChanged: (state.enabled ?? enabled)
          ? (state.onChanged ?? onChanged ?? (value) => null) : null
    ),
    id: id,
    label: label,
    type: SettingsMenuItemType.toggleSwitch
  );

  SettingsMenuItem.section({
    Key key,
    Widget title,
    @required SettingsItemBuilder itemBuilder,
    bool enabled = true,
  }) : super(
    key: key,
    builder: (context, state) => Section(
      title: title,
      itemBuilder: itemBuilder,
      enabled: state.enabled ?? enabled,
      showTopDivider: state.showTopDivider ?? true,
      showBottomDivider: state.showBottomDivider ?? true
    ),
    itemBuilder: itemBuilder,
    type: SettingsMenuItemType.section
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
    bool selected = false,
    ValueChanged<T> onChanged
  }) : super(
    key: key,
    builder: (context, state) {
      T value = state.value ?? initialValue;
      Choice<T> selectedChoice = choices.firstWhere((choice) => choice.value == value);
      Widget statusText = (statusTextBuilder != null)
          ? statusTextBuilder(context, selectedChoice)
          : Text(selectedChoice.label);
      return ListTile(
        leading: leading ?? Icon(null),
        title: Text(label),
        subtitle: statusText,
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: state.pageBuilder)
        ),
        selected: state.selected ?? selected,
        enabled: state.enabled ?? enabled,
      );
    },
    controlBuilder: (context, state) => SingleChoiceControl<T>(
      choices: choices,
      value: state.value ?? initialValue,
      onChanged: state.onChanged ?? onChanged,
    ),
    pageContentBuilder: (context, state) => state.controlBuilder(context),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.singleChoice
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
    builder: (context, state) => MultipleChoiceMenuItem<T>(
      leading: leading,
      label: label,
      statusTextBuilder: statusTextBuilder,
      controlBuilder: state.controlBuilder,
      choices: choices,
      value: state.value ?? initialValue,
      enabled: state.enabled ?? enabled,
    ),
    controlBuilder: (context, state) =>  MultipleChoiceControl<T>(
      choices: choices,
      value: state.value ?? initialValue,
      onChanged: state.onChanged ?? onChanged
    ),
    id: id,
    label: label,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.multipleChoice
  );

  SettingsMenuItem.slider({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required double initialValue,
    double min = 0.0,
    double max = 1.0,
    int divisions,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeStart,
    ValueChanged<double> onChangeEnd,
    bool enabled = true,
    bool selected = false,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context),
    controlBuilder: (context, state) => SliderListTile(
      secondary: leading ?? Icon(null),
      title: Text(label),
      value: state.value ?? initialValue,
      selected: state.selected ?? selected,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: (state.enabled ?? enabled) ? (state.onChanged ?? onChanged) : null,
      onChangeStart: (state.enabled ?? enabled) ? onChangeStart : null,
      onChangeEnd: (state.enabled ?? enabled) ? onChangeEnd : null,
    ),
    id: id,
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
    @required DateTime firstDate,
    @required DateTime lastDate,
    bool enabled = true,
    bool selected = false,
    ValueChanged<DateTime> onChanged
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context),
    controlBuilder: (context, state) => DatePickerListTile(
      id: id,
      leading: leading,
      label: label,
      statusTextBuilder: statusTextBuilder,
      value: state.value ?? initialValue,
      firstDate: firstDate,
      lastDate: lastDate,
      enabled: state.enabled ?? enabled,
      selected: state.selected ?? selected,
      onChanged: state.onChanged ?? onChanged,
    ),
    id: id,
    label: label,
    type: SettingsMenuItemType.dateTime
  );

  SettingsMenuItem.listSubpage({
    Key key,
    @required String label,
    Widget leading,
    Widget secondaryText,
    @required SettingsItemBuilder itemBuilder,
    @required SettingsPageBuilder pageBuilder,
    bool enabled = true,
    bool selected = false
  }) : super(
    key: key,
    builder: (context, state) => ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: secondaryText,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: state.pageBuilder)
      ),
      selected: state.selected ?? selected,
      enabled: state.enabled ?? enabled,
    ),
    pageContentBuilder: (context, state) => SettingsMenu(
      itemBuilder: itemBuilder,
      onSearch: state.onSearch,
    ),
    pageBuilder: pageBuilder,
    label: label,
    itemBuilder: itemBuilder,
    type: SettingsMenuItemType.listSubpage
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
    @required SettingsItemBuilder itemBuilder,
    @required bool initialValue,
    bool enabled = true,
    bool selected = false,
    ValueChanged<bool> onChanged,
    @required SettingsPageBuilder pageBuilder
  }) : super(
    key: key,
    builder: (context, state) {
      bool value = state.value ?? initialValue;
      Widget statusText = statusTextBuilder != null
        ? statusTextBuilder(context, value)
        : Text(value ? activeLabel : inactiveLabel);
      return ListTile(
        leading: leading ?? Icon(null),
        title: Text(label),
        subtitle: statusText,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: state.pageBuilder)
        ),
        trailing: duplicateSwitchInMenuItem ? Switch(
          value: value,
          onChanged: state.onChanged ?? onChanged,
        ) : null,
        selected: state.selected ?? selected,
        enabled: state.enabled ?? enabled,
      );
    },
    controlBuilder: (context, state) => MasterSwitchControl(
      title: masterSwitchTitle,
      value: state.value ?? initialValue,
      onChanged: state.onChanged ?? onChanged,
      activeContentBuilder: (context) => SettingsMenu(
        itemBuilder: itemBuilder,
        onSearch: state.onSearch,
      ),
      inactiveContentBuilder: (context) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(
          left: 72,
          right: 16.0,
          top: 16.0,
          bottom: 16.0
        ),
        child: inactiveTextBuilder(context),
      )
    ),
    pageContentBuilder: (context, state) => state.controlBuilder(context),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    itemBuilder: itemBuilder,
    needUpdateOnChanged: true,
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
    bool selected = false,
    @required SettingsPageBuilder pageBuilder,
    ValueChanged<bool> onChanged
  }) : super(
    key: key,
    builder: (context, state) {
      bool value = state.value ?? initialValue;
      String statusText = value ? activeLabel : inactiveLabel;
      return ListTile(
        leading: leading ?? Icon(null),
        title: Text(label),
        subtitle: Text(statusText),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: state.pageBuilder)
        ),
        selected: state.selected ?? selected,
        enabled: state.enabled ?? enabled,
      );
    },
    controlBuilder: (context, state) => IndividualSwitchControl(
      statusTextBuilder: (context, checked) =>
        Text(checked ? activeLabel : inactiveLabel),
      value: state.value ?? initialValue,
      description: description,
      onChanged: state.onChanged ?? onChanged,
    ),
    pageContentBuilder: (context, state) => state.controlBuilder(context),
    pageBuilder: pageBuilder,
    id: id,
    label: label,
    needUpdateOnChanged: true,
    type: SettingsMenuItemType.individualSwitch
  );

  SettingsMenuItem.dependency({
    Key key,
    @required String id,
    Widget leading,
    @required String label,
    Widget secondaryText,
    @required SettingsItemBuilder itemBuilder,
    @required bool initialValue,
    ValueChanged<bool> onChanged,
    bool enabled = true,
    bool selected = false,
  }) : super(
    key: key,
    builder: (context, state) => state.controlBuilder(context),
    controlBuilder: (context, state) => DependencyControl(
      leading: leading,
      title: Text(label),
      secondaryText: secondaryText,
      itemBuilder: itemBuilder,
      dependencyEnabled: state.value ?? initialValue,
      enabled: state.enabled ?? enabled,
      selected: state.selected ?? selected,
      onChanged: state.onChanged ?? onChanged,
    ),
    id: id,
    label: label,
    itemBuilder: itemBuilder,
    type: SettingsMenuItemType.dependency
  );

  final ValueNotifier _valueNotifier = ValueNotifier(null);
  void _handleChanged(newValue) => _valueNotifier.value = newValue;

  Widget buildControl(BuildContext context, [SettingsMenuItemState state]) {
    state = (state ?? SettingsMenuItemState());
    return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, value, _) => this.controlBuilder(
        context,
        state.copyWith(
          value: value,
          onChanged: _handleChanged
        )
      ),
    );
  }

  Widget buildPage(BuildContext context, [SettingsMenuItemState state]) {
    state = (state ?? SettingsMenuItemState());
    state = state.copyWith(
      controlBuilder: (context) => buildControl(context, state)
    );
    Widget title = Text(label);
    Widget body = this.pageContentBuilder(context, state);

    return (this.pageBuilder ?? SettingsPage.pageBuilder)(
      context,
      title,
      body,
      state.onSearch
    );
  }

  Widget _buildState(BuildContext context, [SettingsMenuItemState state]) {
    state = state ?? SettingsMenuItemState();
    state = state.copyWith(
      pageBuilder: (context) => buildPage(context, state),
      controlBuilder: (context) => buildControl(context, state),
    );

    if (needUpdateOnChanged) return ValueListenableBuilder(
      valueListenable: _valueNotifier,
      builder: (context, value, _) => this.builder(
        context,
        state.copyWith(
          value: value,
          onChanged: _handleChanged
        )
      )
    );

    return this.builder(context, state);
  }

  @override
  Widget build(BuildContext context, {
    bool selected,
    bool enabled,
    bool showTopDivider,
    bool showBottomDivider,
    VoidCallback onSearch
  }) {
    return _buildState(
      context,
      SettingsMenuItemState(
        enabled: enabled,
        selected: selected,
        showTopDivider: showTopDivider,
        showBottomDivider: showBottomDivider,
        onSearch: onSearch
      )
    );
  }
}

class SettingsMenu extends StatelessWidget {
  SettingsMenu({
    Key key,
    @required this.itemBuilder,
    this.enabled = true,
    this.onSearch
  }) : super(key: key);

  final SettingsItemBuilder itemBuilder;
  final bool enabled;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    List<SettingsMenuItem> group = itemBuilder(context);
    return ListView.builder(
      itemCount: group.length,
      itemBuilder: (context, index) {
        SettingsMenuItem item = group[index];
          return item.build(
            context,
            enabled: enabled,
            onSearch: onSearch,
            showTopDivider: Section.needShowTopDivider(
              context: context,
              item: item,
              group: group,
              hideWhenFirst: true
            ),
            showBottomDivider: Section.needShowBottomDivider(
              context: context,
              item: item,
              group: group,
              hideWhenLast: true
            )
          );
      }
    );
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    this.title,
    @required this.itemBuilder,
    this.builder,
  }) : super(key: key);

  static String routeName = '/settings';
  final Widget title;
  final SettingsPageBuilder builder;
  final SettingsItemBuilder itemBuilder;

  void _showSearch(context) {
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
      onSearch: () => _showSearch(context),
    );
  }

  static Widget pageBuilder(
    BuildContext context,
    Widget title,
    Widget body,
    VoidCallback onSearch
  ) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearch
          ),
        ],
      ),
      body: body
    );
  }

  @override
  Widget build(BuildContext context) => (builder ?? pageBuilder)(
    context,
    title ?? Text('Settings'),
    _buildBody(context),
    () => _showSearch(context)
  );
}

class MultipleChoiceMenuItem<T> extends StatelessWidget {
  MultipleChoiceMenuItem({
    Key key,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    @required this.controlBuilder,
    @required this.choices,
    @required this.value,
    this.enabled = true,
    this.selected = false,
  }) : super(key: key);
  
  final Widget leading;
  final String label;
  final StatusBuilder<List<Choice<T>>> statusTextBuilder;
  final WidgetBuilder controlBuilder;
  final List<Choice<T>> choices;
  final List<T> value;
  final bool enabled;
  final bool selected;
  
  Widget _buildDialog(BuildContext context) {
    return ConfirmationDialog(
      title: Text(label),
      contentPadding: const EdgeInsets.only(top: 16.0),
      content: SizedBox(
        height: choices.length * _kListTileHeight,
        child: controlBuilder(context),
      ),
      onConfirm: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    List<Choice<T>> checkedChoices = choices.where(
      (choice) => value.contains(choice.value)
    ).toList();

    if (statusTextBuilder != null) {
      return statusTextBuilder(context, checkedChoices);
    } else {
      String statusText = checkedChoices.map(
        (choice) => choice.label
      ).join(', ');
      return Text(statusText);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: _buildStatusText(context),
      onTap: () => showDialog(
        context: context,
        builder: _buildDialog
      ),
      selected: selected,
      enabled: enabled,
    );
  }
}

class Section extends StatelessWidget {
  Section({
    Key key,
    this.title,
    @required this.itemBuilder,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  final Widget title;
  final SettingsItemBuilder itemBuilder;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;

  Widget _buildTitle(BuildContext context) {
    return title == null ? Container() : Container(
      alignment: Alignment.centerLeft,
      child: title,
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
      children: group.map((item) {
        return item.build(
          context,
          enabled: enabled,
          showTopDivider: Section.needShowTopDivider(
            context: context,
            item: item,
            group: group
          ),
          showBottomDivider: Section.needShowBottomDivider(
            context: context,
            item: item,
            group: group
          )
        );
      }).toList(),
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

  static bool needShowTopDivider({
    @required BuildContext context,
    @required SettingsMenuItem item,
    @required List<SettingsMenuItem> group,
    bool hideWhenFirst = false
  }) {
    bool isNotSection = item.type != SettingsMenuItemType.section;
    if (isNotSection) return false;

    bool isFirst = item == group.first;
    if (hideWhenFirst && isFirst) return false;

    int itemIndex = group.indexOf(item);
    SettingsMenuItem previous = itemIndex > 0 ? group[itemIndex - 1] : null;

    bool isSectionPrevious = previous?.type == SettingsMenuItemType.section;
    if (isSectionPrevious) return false;

    bool isPageLinkPrevious = previous?.pageBuilder != null;
    if (isPageLinkPrevious) return true;

    bool isNotEmptyPrevious = previous?.itemBuilder != null;
    if (isNotEmptyPrevious) {
      List<SettingsMenuItem> previousGroup = previous.itemBuilder(context);
      bool isSectionLastPreviousItem = previousGroup?.last?.type == SettingsMenuItemType.section;
      if (isSectionLastPreviousItem) return false;
    }

    return true;
  }

  static bool needShowBottomDivider({
    @required BuildContext context,
    @required SettingsMenuItem item,
    @required List<SettingsMenuItem> group,
    bool hideWhenLast = false
  }) {
    bool isNotSection = item.type != SettingsMenuItemType.section;
    if (isNotSection) return false;

    bool isLast = item == group.last;
    if (hideWhenLast && isLast) return false;

    return true;
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

class SingleChoiceControl<T> extends StatelessWidget {
  SingleChoiceControl({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) : super(key: key);

  final List<Choice<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = choices[index];
    return RadioListTile<T>(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: Text(option.label),
      value: option.value,
      groupValue: value,
      selected: value == option.value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.trailing
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: _buildRadioListTile
    );
  }
}

class MultipleChoiceControl<T> extends StatelessWidget {
  MultipleChoiceControl({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) : super(key: key);

  final List<Choice<T>> choices;
  final List<T> value;
  final ValueChanged<List<T>> onChanged;

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    Choice option = choices[index];
    bool checked = value.contains(option.value);
    return CheckboxListTile(
      title: Text(option.label),
      value: checked,
      selected: checked,
      onChanged: (bool isChecked) {
        List<T> _value = []..addAll(value);
        isChecked ? _value.add(option.value) : _value.remove(option.value);
        onChanged(_value);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: _buildCheckboxListTile
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

class DatePickerListTile extends StatelessWidget {
  DatePickerListTile({
    Key key,
    @required this.id,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    @required this.value,
    @required this.firstDate,
    @required this.lastDate,
    this.enabled = true,
    this.selected = false,
    this.onChanged
  }) : super(key: key);

  final String id;
  final Widget leading;
  final String label;
  final StatusBuilder<DateTime> statusTextBuilder;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool enabled;
  final bool selected;
  final ValueChanged<DateTime> onChanged;

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime newValue = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (newValue != null && newValue != value && onChanged != null) {
      onChanged(newValue);
    }
  }

  Widget _buildStatusText(BuildContext context) {
    if (statusTextBuilder != null)
      return statusTextBuilder(context, value);

    return Text(value.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(null),
      title: Text(label),
      subtitle: _buildStatusText(context),
      onTap: () => _showDatePicker(context),
      selected: selected,
      enabled: enabled,
    );
  }
}

class DependencyControl extends StatelessWidget {
  DependencyControl({
    Key key,
    this.leading,
    @required this.title,
    this.secondaryText,
    @required this.itemBuilder,
    @required this.dependencyEnabled,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final Widget secondaryText;
  final SettingsItemBuilder itemBuilder;
  final bool dependencyEnabled;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool> onChanged;

  Widget _buildDependent(BuildContext context) {
    List<SettingsMenuItem> group = itemBuilder(context);
    return Column(
      children: group.map(
        (item) => item.build(
          context,
          enabled: dependencyEnabled,
            showTopDivider: Section.needShowTopDivider(
              context: context,
              item: item,
              group: group
            ),
            showBottomDivider: Section.needShowBottomDivider(
              context: context,
              item: item,
              group: group
            )
        )
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          secondary: leading ?? Icon(null),
          title: title,
          subtitle: secondaryText,
          value: dependencyEnabled,
          onChanged: enabled ? onChanged : null,
          selected: selected,
        ),
        _buildDependent(context)
      ],
    );
  }
}

class MasterSwitchControl extends StatelessWidget {
  MasterSwitchControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.activeContentBuilder,
    @required this.inactiveContentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Widget title;
  final bool value;
  final WidgetBuilder activeContentBuilder;
  final WidgetBuilder inactiveContentBuilder;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: title,
      value: value,
      pageContentBuilder: value ? activeContentBuilder : inactiveContentBuilder,
      onChanged: onChanged,
    );
  }
}

class IndividualSwitchControl extends StatelessWidget {
  IndividualSwitchControl({
    Key key,
    @required this.statusTextBuilder,
    @required this.value,
    @required this.onChanged,
    @required this.description
  }) : super(key: key);

  final StatusBuilder statusTextBuilder;
  final bool value;
  final Widget description;
  final ValueChanged<bool> onChanged;

  Widget _buildTitle(BuildContext context) {
    return statusTextBuilder(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return ContentSwitchControl(
      title: _buildTitle(context),
      value: value,
      pageContentBuilder: (context) => Container(
        padding: const EdgeInsets.only(
          left: 72,
          right: 16.0,
          top: 16.0,
          bottom: 16.0
        ),
        child: description,
      ),
      onChanged: onChanged,
    );
  }
}

class ContentSwitchControl extends StatelessWidget {
  ContentSwitchControl({
    Key key,
    @required this.title,
    @required this.value,
    @required this.pageContentBuilder,
    @required this.onChanged
  }) : super(key: key);

  final Widget title;
  final bool value;
  final WidgetBuilder pageContentBuilder;
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
      child: pageContentBuilder(context)
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

  final SettingsItemBuilder itemBuilder;
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
      bool isPage = _kPageSettingsMenuItemTypes.contains(item.type);

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
//    SettingsItemBuilder itemBuilder,
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

//    if (suggestion.item.pageBuilder != null) {
//      return suggestion.item.pageBuilder(
//        context,
//        _showSearch
//      );
//    } else if (suggestion.page.pageBuilder != null) {
//      return suggestion.page.pageBuilder(
//        context,
//        _showSearch
//      );
//    }

    if (suggestion.item.pageContentBuilder != null) {
      return suggestion.item.buildPage(context);
    } else if (suggestion?.page?.pageContentBuilder != null) {
      return suggestion.page.buildPage(context);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: suggestion.item,
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
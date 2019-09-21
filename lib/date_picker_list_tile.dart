import 'package:flutter/material.dart';
import 'types.dart';

class DatePickerListTile extends StatelessWidget {
  DatePickerListTile({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.value,
    @required this.firstDate,
    @required this.lastDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.locale,
    this.textDirection,
    this.builder,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) :
    assert(title != null),
    assert(value != null),
    assert(enabled != null),
    assert(selected != null),
    assert(firstDate != null),
    assert(lastDate != null),
    assert(!value.isBefore(firstDate), 'value must be on or after firstDate'),
    assert(!value.isAfter(lastDate), 'value must be on or before lastDate'),
    assert(!firstDate.isAfter(lastDate), 'lastDate must be on or after firstDate'),
    assert(selectableDayPredicate == null || selectableDayPredicate(value),
      'Provided value must satisfy provided selectableDayPredicate'),
    assert(initialDatePickerMode != null, 'initialDatePickerMode must not be null'),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<DateTime> statusTextBuilder;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final DatePickerMode initialDatePickerMode;
  final SelectableDayPredicate selectableDayPredicate;
  final Locale locale;
  final TextDirection textDirection;
  final TransitionBuilder builder;
  final bool enabled;
  final bool selected;
  final ValueChanged<DateTime> onChanged;

  Future<DateTime> _showDatePicker(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: firstDate,
        lastDate: lastDate,
        selectableDayPredicate: selectableDayPredicate,
        initialDatePickerMode: initialDatePickerMode,
        locale: locale,
        textDirection: textDirection,
        builder: builder
    );

    if (newDate == null) return null;

    return DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        value.hour,
        value.minute,
        value.second,
        value.millisecond,
        value.microsecond
    );
  }

  void _handleChanged(BuildContext context) async {
    DateTime newValue = await _showDatePicker(context);
    if (onChanged != null && newValue != null && newValue != value)
      onChanged(newValue);
  }

  Widget _buildStatusText(BuildContext context) {
    if (statusTextBuilder != null)
      return statusTextBuilder(context, value);

    RegExp timeRegExp = RegExp(' [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3}\$');
    String secondaryText = value
        .toString()
        .replaceAll(timeRegExp, '');
    return Text(
        secondaryText,
        softWrap: false,
        overflow: TextOverflow.ellipsis
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = enabled
        ? Theme.of(context).indicatorColor
        : Theme.of(context).disabledColor;
    return ListTile(
      leading: leading,
      title: title,
      subtitle: _buildStatusText(context),
      trailing: IconButton(
        icon: Icon(Icons.calendar_today, color: color),
        onPressed: enabled ? () => _handleChanged(context) : null,
      ),
      onTap: () => _handleChanged(context),
      selected: selected,
      enabled: enabled,
    );
  }
}
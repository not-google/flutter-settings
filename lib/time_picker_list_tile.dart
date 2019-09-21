import 'package:flutter/material.dart';
import 'types.dart';

class TimePickerListTile extends StatelessWidget {
  TimePickerListTile({
    Key key,
    this.leading,
    @required this.label,
    this.statusTextBuilder,
    @required this.value,
    this.builder,
    this.enabled = true,
    this.selected = false,
    @required this.onChanged
  }) : super(key: key);

  final Widget leading;
  final Text label;
  final ValueBuilder<TimeOfDay> statusTextBuilder;
  final TimeOfDay value;
  final TransitionBuilder builder;
  final bool enabled;
  final bool selected;
  final ValueChanged<TimeOfDay> onChanged;

  Future<TimeOfDay> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
        context: context,
        initialTime: value,
        builder: builder
    );
  }

  void _handleChanged(BuildContext context) async {
    TimeOfDay newValue = await _showTimePicker(context);
    if (newValue != null && newValue != value)
      onChanged(newValue);
  }

  Widget _buildSecondaryText(BuildContext context) {
    if (statusTextBuilder != null)
      return statusTextBuilder(context, value);

    return Text(
        value.format(context),
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
      leading: leading ?? Icon(null),
      title: label,
      subtitle: _buildSecondaryText(context),
      trailing: IconButton(
        icon: Icon(Icons.access_time, color: color),
        onPressed: enabled ? () => _handleChanged(context) : null,
      ),
      onTap: () => _handleChanged(context),
      selected: selected,
      enabled: enabled,
    );
  }
}
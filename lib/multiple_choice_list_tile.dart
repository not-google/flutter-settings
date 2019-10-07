import 'package:flutter/material.dart';
import 'types.dart';
import 'choice.dart';
import 'multiple_choice.dart';

const double _kListTileHeight = 56.0;

class MultipleChoiceListTile extends StatelessWidget {
  MultipleChoiceListTile({
    Key key,
    this.leading,
    @required this.title,
    this.statusTextBuilder,
    @required this.choices,
    @required this.value,
    @required this.onChanged,
    this.onSingleChanged,
    this.enabled = true,
    this.selected = false,
    this.loading = false,
  }) :
    assert(title != null),
    assert(choices != null),
    assert(value != null),
    assert(enabled != null),
    assert(selected != null),
    assert(loading != null),
    super(key: key);

  final Widget leading;
  final Widget title;
  final ValueBuilder<List<Choice>> statusTextBuilder;
  final List<Choice> choices;
  final List<String> value;
  final bool enabled;
  final bool selected;
  final bool loading;
  final ValueChanged<List<String>> onChanged;
  final ValueChanged<List<String>> onSingleChanged;

  Widget _buildDialog(BuildContext context) {
    List<String> _value = value;
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return AlertDialog(
        title: title,
        content: SizedBox(
          height: choices.length * _kListTileHeight,
          child: StatefulBuilder(
            builder: (context, setState) => MultipleChoice(
              choices: choices,
              value: _value,
              enabled: enabled,
              onChanged: (newValue) {
                if (onSingleChanged != null) onSingleChanged(newValue);
                setState(() => _value = newValue);
              }
            )
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 16.0),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancelButtonLabel)
          ),
          FlatButton(
            onPressed: () {
              onChanged(_value);
              Navigator.of(context).pop();
            },
            child: Text(localizations.okButtonLabel)
          )
        ]
    );
  }

  Widget _buildStatusText(BuildContext context) {
    List<Choice> checkedChoices = choices.where(
      (choice) => value.contains(choice.value)
    ).toList();

    if (statusTextBuilder != null) {
      return statusTextBuilder(context, checkedChoices);
    } else {
      String subtitle = checkedChoices.map(
        (choice) => choice.title.data
      ).join(', ');
      return Text(subtitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
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
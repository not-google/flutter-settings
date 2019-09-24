import 'package:flutter/material.dart';
import 'choice.dart';

class MultipleChoice extends StatelessWidget {
  MultipleChoice({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) :
    assert(choices != null),
    super(key: key);

  final List<Choice> choices;
  final List<String> value;
  final ValueChanged<List<String>> onChanged;

  Widget _buildCheckboxListTile(BuildContext context, int index) {
    Choice option = choices[index];
    bool checked = value.contains(option.value);
    return CheckboxListTile(
        title: option.title,
        subtitle: option.subtitle,
        value: checked,
        onChanged: (bool checked) {
          List<String> _value = []..addAll(value);
          checked ? _value.add(option.value) : _value.remove(option.value);
          if (onChanged != null) onChanged(_value);
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
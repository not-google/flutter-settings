import 'package:flutter/material.dart';
import 'choice.dart';

class SingleChoice extends StatelessWidget {
  SingleChoice({
    Key key,
    @required this.choices,
    @required this.value,
    @required this.onChanged
  }) :
    assert(value != null),
    assert(choices != null),
    super(key: key);

  final List<Choice> choices;
  final String value;
  final ValueChanged<String> onChanged;

  Widget _buildRadioListTile(BuildContext context, int index) {
    Choice option = choices[index];
    return RadioListTile<String>(
      secondary: Visibility(
        visible: false,
        child: CircleAvatar()
      ),
      title: option.title,
      subtitle: option.subtitle,
      value: option.value,
      groupValue: value,
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
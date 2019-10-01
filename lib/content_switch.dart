import 'package:flutter/material.dart';

class ContentSwitch extends StatelessWidget {
  ContentSwitch({
    Key key,
    @required this.title,
    @required this.value,
    @required this.contentBuilder,
    @required this.onChanged,
    this.loading = false
  }) :
    assert(title != null),
    assert(value != null),
    assert(loading != null),
    assert(contentBuilder != null),
    super(key: key);

  final Text title;
  final bool value;
  final bool loading;
  final WidgetBuilder contentBuilder;
  final ValueChanged<bool> onChanged;

  Widget _buildControl(BuildContext context) {
    return Container(
        child: SwitchListTile(
          secondary: Visibility(
              visible: false,
              child: CircleAvatar()
          ),
          title: DefaultTextStyle(
            style: (title.style ?? Theme.of(context).textTheme.subhead).copyWith(
                color: title.style?.color ?? Theme.of(context).colorScheme.onBackground,
                fontWeight: title.style?.fontWeight ?? FontWeight.w500
            ),
            child: title,
          ),
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.onBackground,
          inactiveThumbColor: Theme.of(context).colorScheme.onBackground,
        ),
        decoration: BoxDecoration(
            color: value
                ? Theme.of(context).indicatorColor
                : Theme.of(context).disabledColor
        ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
        child: contentBuilder(context)
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (loading) return LinearProgressIndicator();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildControl(context),
        _buildLoading(context),
        _buildContent(context)
      ],
    );
  }
}
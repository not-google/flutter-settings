import 'package:flutter/material.dart';

const double _kDividerHeight = 1.0;

class Section extends StatelessWidget {
  Section({
    Key key,
    this.title,
    @required this.content,
    this.enabled = true,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  final Text title;
  final Widget content;
  final bool enabled;
  final bool showTopDivider;
  final bool showBottomDivider;
  Widget _buildTitle(BuildContext context) {
    if (title == null) return Container();

    return Container(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: (title.style ?? Theme.of(context).textTheme.body1).copyWith(
          color: title.style?.color ?? Theme.of(context).primaryColor
        ),
        child: title,
      ),
      padding: const EdgeInsets.all(16.0).copyWith(
        left: 72.0,
        bottom: 8.0
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        showTopDivider ? Divider(height: _kDividerHeight) : Container(),
        _buildTitle(context),
        content,
        showBottomDivider ? Divider(height: _kDividerHeight) : Container(),
      ],
    );
  }
}
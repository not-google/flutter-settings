import 'package:flutter/material.dart';

typedef ValueBuilder<T> = Widget Function(BuildContext context, T value);
typedef StateBuilder<T> = Widget Function(BuildContext context, T widget);
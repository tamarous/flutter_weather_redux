import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ThemeState extends Equatable {
  final ThemeData theme;
  final MaterialColor color;
  ThemeState({
    @required this.theme,
    @required this.color,
  })  : assert(theme != null, color != null),
        super([theme, color]);

  factory ThemeState.initial() => ThemeState(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        color: Colors.lightBlue,
      );
}

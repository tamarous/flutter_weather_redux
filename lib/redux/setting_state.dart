import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

enum TemperatureUnits {
  fahrenheit,
  celsius,
}

class SettingsState extends Equatable {
  final TemperatureUnits temperatureUnits;

  SettingsState({@required this.temperatureUnits}):assert(temperatureUnits != null), super([temperatureUnits]);
}
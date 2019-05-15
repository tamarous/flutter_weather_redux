import 'package:flutter/material.dart';
import 'package:flutter_weather_redux/models/models.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import 'theme_state.dart';

class WeatherChangedAction {
  final WeatherCondition condition;

  WeatherChangedAction({@required this.condition}) : assert(condition != null);
}

final weatherChangeReducer = combineReducers<ThemeState>([
  TypedReducer<ThemeState, WeatherChangedAction>(onWeatherChange),
]);

ThemeState onWeatherChange(ThemeState state, WeatherChangedAction action) {
  return _mapWeatherConditionToThemeData(action.condition);
}

ThemeState _mapWeatherConditionToThemeData(WeatherCondition condition) {
  ThemeState theme;
  switch (condition) {
    case WeatherCondition.clear:
    case WeatherCondition.lightCloud:
      theme = ThemeState(
        theme: ThemeData(
          primaryColor: Colors.orangeAccent,
        ),
        color: Colors.yellow,
      );
      break;
    case WeatherCondition.hail:
    case WeatherCondition.snow:
    case WeatherCondition.sleet:
      theme = ThemeState(
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
        ),
        color: Colors.lightBlue,
      );
      break;
    case WeatherCondition.heavyCloud:
      theme = ThemeState(
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
        ),
        color: Colors.grey,
      );
      break;
    case WeatherCondition.heavyRain:
    case WeatherCondition.lightRain:
    case WeatherCondition.showers:
      theme = ThemeState(
        theme: ThemeData(
          primaryColor: Colors.indigoAccent,
        ),
        color: Colors.indigo,
      );
      break;
    case WeatherCondition.thunderstorm:
      theme = ThemeState(
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
        ),
        color: Colors.deepPurple,
      );
      break;
    case WeatherCondition.unknown:
      theme = ThemeState(
        theme: ThemeData.light(),
        color: Colors.lightBlue,
      );
      break;
  }
  return theme;
}

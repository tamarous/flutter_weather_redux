import 'package:meta/meta.dart';

import 'redux_exports.dart';

class GlobalState {
  WeatherState weatherState;
  ThemeState themeState;
  SettingsState settingsState;

  GlobalState(
      {@required this.weatherState,
      @required this.themeState,
      @required this.settingsState})
      : assert(weatherState != null, themeState != null);

  factory GlobalState.initial() => GlobalState(
        weatherState: WeatherState.initial(),
        themeState: ThemeState.initial(),
        settingsState: SettingsState.initial(),
      );
}

GlobalState globalReducer(GlobalState state, action) {
  return GlobalState(
    weatherState: weatherSearchReducer(state.weatherState, action),
    themeState: themeChangeReducer(state.themeState, action),
    settingsState: settingsChangeReducer(state.settingsState, action),
  );
}

import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import 'redux_exports.dart';

class SettingsChangeAction {
  TemperatureUnits units;

  SettingsChangeAction({@required this.units}) : assert(units != null);
}

final settingsChangeReducer = combineReducers<SettingsState>([
  TypedReducer<SettingsState, SettingsChangeAction>(onSettingChange),
]);

SettingsState onSettingChange(
    SettingsState state, SettingsChangeAction action) {
  return SettingsState(temperatureUnits: action.units);
}

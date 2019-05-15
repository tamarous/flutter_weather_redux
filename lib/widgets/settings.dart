import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weather_redux/redux/redux_exports.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<GlobalState>(context);

    return StoreConnector<GlobalState, ViewModel>(
      converter: (store) {
        return ViewModel(settingsState: store.state.settingsState);
      },
      builder: (BuildContext context, ViewModel vm) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Temperature Units',
                  ),
                  isThreeLine: true,
                  subtitle:
                      Text('Use metric measurements for temperature units.'),
                  trailing: Switch(
                    value: vm.settingsState.temperatureUnits ==
                        TemperatureUnits.celsius,
                    onChanged: (value) {
                      SettingsChangeAction changeAction;
                      if (value) {
                        changeAction = new SettingsChangeAction(
                            units: TemperatureUnits.celsius);
                      } else {
                        changeAction = new SettingsChangeAction(
                            units: TemperatureUnits.fahrenheit);
                      }
                      store.dispatch(changeAction);
                    },
                  ),
                )
              ],
            ));
      },
    );
  }
}

class ViewModel {
  SettingsState settingsState;
  ViewModel({@required this.settingsState}) : assert(settingsState != null);
}

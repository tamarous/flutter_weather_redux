import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weather_redux/models/models.dart' as model;
import 'package:flutter_weather_redux/redux/redux_exports.dart';
import 'package:flutter_weather_redux/redux/setting_state.dart';
import 'package:flutter_weather_redux/widgets/widgets.dart';
import 'package:meta/meta.dart';

class CombinedWeatherTemperature extends StatelessWidget {
  final model.Weather weather;

  CombinedWeatherTemperature({
    Key key,
    @required this.weather,
  })  : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, ViewModel>(
      converter: (store) {
        return ViewModel(settingsState: store.state.settingsState);
      },
      builder: (BuildContext context, ViewModel vm) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: WeatherConditions(
                    condition: weather.condition,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Temperature(
                    temperature: weather.temp,
                    high: weather.maxTemp,
                    low: weather.minTemp,
                    units: vm.settingsState.temperatureUnits,
                  ),
                )
              ],
            ),
            Center(
              child: Text(
                weather.formattedCondition,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class ViewModel {
  SettingsState settingsState;
  ViewModel({@required this.settingsState}) : assert(settingsState != null);
}

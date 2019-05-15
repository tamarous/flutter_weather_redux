import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weather_redux/models/models.dart';
import 'package:flutter_weather_redux/redux/redux_exports.dart';
import 'package:flutter_weather_redux/widgets/combined_weather_temperature.dart';
import 'package:flutter_weather_redux/widgets/widgets.dart';
import 'package:redux/redux.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Completer<void> _refreshCompleter;

  Weather previousWeather;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
  }

  Widget buildBody(GlobalState state, Store<GlobalState> store) {
    if (state.weatherState.isEmpty) {
      return Center(
        child: Text('Please select a location'),
      );
    }
    if (state.weatherState.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.weatherState.hasLoaded) {
      _refreshCompleter?.complete();
      _refreshCompleter = Completer();

      final weather = state.weatherState.weather;

      if (previousWeather != null) {
        Weather currentWeather = weather;
        if (currentWeather.condition != previousWeather.condition) {
          store.dispatch(
              WeatherChangedAction(condition: currentWeather.condition));
        }
      }

      previousWeather = weather;

      return GradientContainer(
        color: state.themeState.color,
        child: RefreshIndicator(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Location(
                    location: weather.location,
                  ),
                ),
              ),
              Center(
                child: LastUpdated(
                  dateTime: weather.lastUpdated,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: CombinedWeatherTemperature(
                    weather: weather,
                  ),
                ),
              ),
            ],
          ),
          onRefresh: () {
            store.dispatch(
                refreshWeatherAction(state.weatherState.weather.location));
            return _refreshCompleter.future;
          },
        ),
      );
    }
    if (state.weatherState.hasError) {
      return Center(
        child: Text(
          'Something went wrong',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<GlobalState>(context);

    return StoreConnector<GlobalState, SearchScreenViewModel>(
      converter: (store) {
        return SearchScreenViewModel(state: store.state);
      },
      builder: (BuildContext context, SearchScreenViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Flutter Weather',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  final city = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CitySelection(),
                      ));
                  if (city != null) {
                    store.dispatch(searchWeatherAction(city));
                  }
                },
              )
            ],
          ),
          body: buildBody(vm.state, store),
        );
      },
    );
  }
}

class SearchScreenViewModel {
  final GlobalState state;
  SearchScreenViewModel({this.state});
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weather_redux/redux/redux.dart';
import 'package:flutter_weather_redux/widgets/combined_weather_temperature.dart';
import 'package:flutter_weather_redux/widgets/widgets.dart';

class Weather extends StatefulWidget {
  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
  }

  Widget buildBody(WeatherState state) {
    if (state.isEmpty) {
      return Center(
        child: Text('Please select a location'),
      );
    }
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.hasLoaded) {
      final weather = state.weather;
      return GradientContainer(
        color: Colors.blue,
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
          onRefresh: () {},
        ),
      );
    }
    if (state.hasError) {
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
    final store = StoreProvider.of<WeatherState>(context);

    return StoreConnector<WeatherState, SearchScreenViewModel>(
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
          body: buildBody(vm.state),
        );
      },
    );
  }
}

class SearchScreenViewModel {
  final WeatherState state;
  SearchScreenViewModel({this.state});
}

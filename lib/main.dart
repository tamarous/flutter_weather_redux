import 'package:flutter/material.dart';
import 'package:flutter_weather_redux/redux/redux.dart';
import 'package:flutter_weather_redux/redux/weather_actions.dart';

import 'package:flutter_weather_redux/repositories/repositories.dart';
import 'package:flutter_weather_redux/widgets/widgets.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:http/http.dart' as http;

void main() {
  final store = new Store<WeatherState>(searchReducer,
      initialState: WeatherState.initial(),
      middleware: [thunkMiddleware],
      );

  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(httpClient: http.Client()));
  runApp(MyApp(
    weatherRepository: weatherRepository,
    store: store,
  ));
}

class MyApp extends StatefulWidget {
  final WeatherRepository weatherRepository;

  final Store<WeatherState> store;

  MyApp({
    Key key,
    @required this.weatherRepository,
    this.store,
  })  : assert(weatherRepository != null),
        super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<WeatherState>(
      store: widget.store,
      child: MaterialApp(
        title: 'Flutter Weather',
        theme: ThemeData(primaryColor: Colors.white),
        home: Weather(
          weatherRepository: widget.weatherRepository,
        ),
      ),
    );
  }
}

import 'package:flutter_weather_redux/models/models.dart';
import 'package:flutter_weather_redux/redux/redux_exports.dart';
import 'package:flutter_weather_redux/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SearchAction {
  final String city;
  SearchAction(this.city);
}

class SearchLoadingAction {}

class SearchErrorAction {}

class SearchResultAction {
  Weather weather;
  SearchResultAction(this.weather);
}

final weatherSearchReducer = combineReducers<WeatherState>([
  TypedReducer<WeatherState, SearchLoadingAction>(_onLoad),
  TypedReducer<WeatherState, SearchErrorAction>(_onError),
  TypedReducer<WeatherState, SearchResultAction>(_onResult),
]);

ThunkAction<GlobalState> searchWeatherAction(String city) {
  return (Store<GlobalState> store) async {
    store.dispatch(SearchLoadingAction());

    WeatherApiClient weatherApiClient =
        WeatherApiClient(httpClient: http.Client());

    WeatherRepository repository =
        WeatherRepository(weatherApiClient: weatherApiClient);

    try {
      Weather weather = await repository.getWeather(city);
      store.dispatch(SearchResultAction(weather));
    } catch (e) {
      print(e.toString());
      store.dispatch(SearchErrorAction());
    }
  };
}

ThunkAction<GlobalState> refreshWeatherAction(String city) {
  return (Store<GlobalState> store) async {
    WeatherApiClient weatherApiClient =
        WeatherApiClient(httpClient: http.Client());

    WeatherRepository repository =
        WeatherRepository(weatherApiClient: weatherApiClient);

    try {
      Weather weather = await repository.getWeather(city);
      store.dispatch(SearchResultAction(weather));
    } catch (e) {
      print(e.toString());
      store.dispatch(SearchErrorAction());
    }
  };
}

WeatherState _onLoad(WeatherState state, SearchLoadingAction action) {
  return WeatherState.loading();
}

WeatherState _onError(WeatherState state, SearchErrorAction action) {
  return WeatherState.error();
}

WeatherState _onResult(WeatherState state, SearchResultAction action) {
  return WeatherState(weather: action.weather, hasLoaded: true);
}

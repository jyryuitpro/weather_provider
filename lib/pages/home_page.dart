import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/search_page.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();
    _weatherProvider = context.read<WeatherProvider>();
    _weatherProvider.addListener(_registerListener);
  }

  void _registerListener() {
    final WeatherState weatherState = context.read<WeatherProvider>().state;

    if (weatherState.status == WeatherStatus.error) {
      errorDialog(context, weatherState.error.errMsg);
    }
  }

  @override
  void dispose() {
    _weatherProvider.removeListener(_registerListener);
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // _fetchWeather() {
  //   WeatherRepository(
  //           weatherApiservices: WeatherApiservices(httpClient: http.Client()))
  //       .fetchWeather('London');
  // }

  // _fetchWeather() {
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     context.read<WeatherProvider>().fetchWeather('London');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
              print('city: $_city');

              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    final weatherState = context.watch<WeatherProvider>().state;

    if (weatherState.status == WeatherStatus.initial) {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (weatherState.status == WeatherStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (weatherState.status == WeatherStatus.error &&
        weatherState.weather.title == '') {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    return Center(
      child: Text(
        weatherState.weather.title,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

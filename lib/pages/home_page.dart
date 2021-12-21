import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/search_page.dart';
import 'package:weather_provider/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

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
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

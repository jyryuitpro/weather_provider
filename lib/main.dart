import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather_provider/pages/home_page.dart';
import 'package:weather_provider/providers/temp_settings_provider.dart';
import 'package:weather_provider/providers/theme_provider.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/repositories/weather_repository.dart';
import 'package:weather_provider/services/weather_api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) {
            final WeatherApiservices weatherApiServices =
                WeatherApiservices(httpClient: http.Client());
            return WeatherRepository(weatherApiservices: weatherApiServices);
          },
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
        ChangeNotifierProvider<TempSettingsProvider>(
          create: (context) => TempSettingsProvider(),
        ),
        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (
            BuildContext context,
            WeatherProvider weatherProvider,
            ThemeProvider? themProvider,
          ) =>
              themProvider!..update(weatherProvider),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: HomePage(),
      ),
    );
  }
}

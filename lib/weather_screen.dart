import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/secrets.dart';

import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    try{
      getCurrentWeather();
    }catch (e){
      throw e.toString();
    }
  }

  Future<Map<String,dynamic>> getCurrentWeather() async {
    String city = 'Chandigarh';
    try{
      final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherApiKey'),);

      final data = jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw 'An unexpected error occurred';
      }
      return data;
    }
    catch(e){
      throw e.toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed:
          (){
            debugPrint('Refresh Clicked!!!');
          },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          double celcius = 0;

          double convertToCelsius(double x){
            celcius = x - 273.15;
            return celcius;
          }

          return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // -------------- Main card ------------------

                    SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Card(
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text('${convertToCelsius(currentTemp).toStringAsFixed(2)} °C',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                      )
                                  ),

                                  const SizedBox(height: 14),

                                  Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain' ? currentSky == 'Clouds' ? Icons.cloud : Icons.thunderstorm : Icons.sunny,
                                  size: 64),

                                  const SizedBox(height: 18),

                                  Text(currentSky,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ))

                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                    ),


                const SizedBox(height: 20,),

                //---------------- Forecast cards ------------------

                const Text('Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),

                const SizedBox(height: 16),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: '00:00',
                        icon: Icons.cloud,
                        temp: '301.12'
                      ),
                      HourlyForecastItem(
                          time: '03:00',
                          icon: Icons.cloud,
                          temp: '300.52'
                      ),
                      HourlyForecastItem(
                          time: '06:00',
                          icon: Icons.cloud,
                          temp: '302.22'
                      ),
                      HourlyForecastItem(
                          time: '09:00',
                          icon: Icons.cloud,
                          temp: '300.62'
                      ),
                      HourlyForecastItem(
                          time: '12:00',
                          icon: Icons.cloud,
                          temp: '304.27'
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                //------------ Additional Information -----------

                const Text('Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12,),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '94',
                    ),
                    AdditionalInformationItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '7.67',
                    ),
                    AdditionalInformationItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '1006',
                    ),
                  ]
                )
              ]
            ),
          );
        }
      ),
    );
  }
}

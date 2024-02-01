import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  late double celcius;

  String convertToCelsius(x){
    celcius = x - 273.15;
    return '${celcius.toStringAsFixed(0)} °C';
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

          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];


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
                                  Text(convertToCelsius(currentTemp),
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

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //       children: [
                //         for(int i = 0; i < 5; i++)
                //           HourlyForecastItem(
                //               time: data['list'][i+1]['dt'].toString(),
                //               icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds'  || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud :  Icons.sunny,
                //               // icon: data['list'][i+1]['weather']['main'] == 'Clouds' || data['list'][i+1]['weather']['main'] == 'Rain' ? data['list'][i+1]['weather']['main'] == 'Clouds' ? Icons.cloud : Icons.thunderstorm : Icons.sunny,
                //               temp: convertToCelsius(data['list'][i+1]['main']['temp']),
                //             // temp: data['list'][i+1]['main']['temp'].toString(),
                //           ),
                //       ],
                //   ),
                // ),

                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index){
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky = data['list'][index+1]['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain' ? hourlySky == 'Clouds' ? Icons.cloud : Icons.thunderstorm : Icons.sunny,
                        temp: convertToCelsius(hourlyForecast['main']['temp']),
                      );
                    },
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
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

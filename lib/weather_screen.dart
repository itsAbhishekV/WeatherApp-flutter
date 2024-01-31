import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/additional_info_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // -------------- Main card ------------------

            SizedBox(
              width: double.infinity,
              height: 230,
              child: Card(
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('300 °F',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              )
                          ),

                          SizedBox(height: 14),

                          Icon(Icons.cloud,
                          size: 64),

                          SizedBox(height: 18),

                          Text('Rain',
                          style: TextStyle(
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
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
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

            const SizedBox(height: 16,),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInformationItem(),
                AdditionalInformationItem(),
                AdditionalInformationItem(),
              ]
            )

          ]
        ),
      ),
    );
  }
}
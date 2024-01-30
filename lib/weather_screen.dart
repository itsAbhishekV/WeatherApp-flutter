import 'dart:ui';

import 'package:flutter/material.dart';

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
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('300 °F',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 16,),
                          Icon(Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(height: 16,),
                          Text('Rain',
                              style: TextStyle(
                            fontSize: 20,
                          )
                          )
                        ]
                      ),
                    ),
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

            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformationItem(),
                  AdditionalInformationItem(),
                  AdditionalInformationItem(),
                ]
              ),
            )

          ]
        ),
      ),
    );
  }
}


class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12.0),
        child: const Column(
          children: [
            Text('03:00',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 8,),
            Icon(Icons.cloud,
              size: 32,),
            SizedBox(height: 8,),
            Text('320.12'),
          ],
        ),
      ),
    );
  }
}


class AdditionalInformationItem extends StatelessWidget {
  const AdditionalInformationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.beach_access, size: 32),
        SizedBox(height: 8,),
        Text('Pressure'),
        SizedBox(height: 8,),
        Text('1006',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),)
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<void> _requestPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Request the user to enable location services
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Request the user to grant location permissions
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Request the user to grant location permissions from app settings
    return;
  }
}

Future<String> _getCurrentCity() async {
  await _requestPermission();
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark placemark = placemarks.first;
  String city = placemark.locality ?? '';
  return city;
}

Future<String> getname() async {
  String cityName = await _getCurrentCity();
  print('Current city: $cityName');
  return cityName;
}
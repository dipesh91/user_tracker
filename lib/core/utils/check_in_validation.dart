import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';

Future<bool> checkInValidation() async {
  if (kIsWeb) {
    print('This is web..');
    return true;
  }
  final network = NetworkInfo();
  final wifiIP = await network.getWifiBSSID();
  final inOffice = await getCurrentLocation();
  print('\n-------\n$wifiIP\n${dotenv.get('wifiBSSID')}\n--------\n');
  return dotenv.get('wifiBSSID').contains(wifiIP ?? '') || inOffice;
}

Future<bool> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  double distance = Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    dotenv.getDouble('officeLat'),
    dotenv.getDouble('officeLng'),
  );
  return distance <= 50;
}

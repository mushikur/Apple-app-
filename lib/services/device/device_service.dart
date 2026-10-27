import 'dart:async';

/// Abstract device service for battery and platform info.
abstract class DeviceService {
  Future<void> init();
  Stream<bool> get chargingStream;
  Stream<double> get batteryLevelStream;
  Future<bool> isCharging();
  Future<double> getBatteryLevel();
  Future<bool> isLowBattery();
  void dispose();
}

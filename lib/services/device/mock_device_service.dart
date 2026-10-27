import 'dart:async';
import 'device_service.dart';

/// Mock device service for Windows development and testing.
class MockDeviceService implements DeviceService {
  final _chargingController = StreamController<bool>.broadcast();
  final _batteryController = StreamController<double>.broadcast();
  bool _charging = false;
  double _batteryLevel = 0.85;

  @override
  Future<void> init() async {}

  @override
  Stream<bool> get chargingStream => _chargingController.stream;

  @override
  Stream<double> get batteryLevelStream => _batteryController.stream;

  @override
  Future<bool> isCharging() async => _charging;

  @override
  Future<double> getBatteryLevel() async => _batteryLevel;

  @override
  Future<bool> isLowBattery() async => _batteryLevel < 0.2;

  /// Simulate charging state for development/demo.
  void setCharging(bool value) {
    _charging = value;
    _chargingController.add(value);
  }

  /// Simulate battery level for development/demo.
  void setBatteryLevel(double level) {
    _batteryLevel = level.clamp(0.0, 1.0);
    _batteryController.add(_batteryLevel);
  }

  @override
  void dispose() {
    _chargingController.close();
    _batteryController.close();
  }
}

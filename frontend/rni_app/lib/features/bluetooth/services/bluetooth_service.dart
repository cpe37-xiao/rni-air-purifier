import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/*
  This service handles all BLE communication logic, works closely with BluetoothProvider
*/
class BlueService {
  // Init as Singleton service for managing Bluetooth operations
  static final BlueService instance = BlueService._internal();

  factory BlueService() {
    return instance;
  }

  BlueService._internal();
  // ...

  // FlutterBluePlus Getters
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.onScanResults;
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  Future<void> init() async {
    if (await FlutterBluePlus.isSupported == false) {
      throw Exception('Bluetooth is not supported by this device');
    }
  }

  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    // Check Adapter state
    try {
      await FlutterBluePlus.startScan(timeout: timeout, androidLegacy: true);
    } catch (e) {
      throw "Failed to start scan: $e";
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      throw Exception(e);
    }
  }
}

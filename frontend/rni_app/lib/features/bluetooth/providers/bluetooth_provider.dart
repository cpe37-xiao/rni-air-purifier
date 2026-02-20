import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class BluetoothProvider with ChangeNotifier {
  final BlueService _bluetoothService = BlueService();
  // State
  List<ScanResult> _scanResults = [];
  BluetoothAdapterState _bluetoothAdapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;

  // Getters
  List<ScanResult> get scanResults => _scanResults;
  BluetoothAdapterState get bluetoothAdapterState => _bluetoothAdapterState;
  bool get isScanning => _isScanning;

  void init() async {
    await _bluetoothService.init();
    _listenToScanResults();
    _listenToScanningState();
    _listenToAdapter();
  }

  // Call BluetoothService to start scanning for bluetooth devices
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      // if (!kIsWeb) {
      //   if (Platform.isAndroid) {
      //     await requestPermissions();
      //     await FlutterBluePlus.turnOn();
      //   }
      // }
      if (_bluetoothAdapterState == BluetoothAdapterState.on) {
        _scanResults.clear();
        await _bluetoothService.startScan(timeout: timeout);
        notifyListeners();
      } else {
        print("Bluetooth is not enabled");
      }
    } catch (e) {
      throw "Failed to start scan: $e";
    }
  }

  // Call BluetoothService to stop scanning for bluetooth devices
  Future<void> stopScan() async {
    try {
      await _bluetoothService.stopScan();
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to stop scan: $e");
    }
  }

  // Listen to BluetoothService and notify Comsumers on scan state changed
  void _listenToScanningState() async {
    _bluetoothService.isScanning.listen((scanning) {
      _isScanning = scanning;
      notifyListeners();
    });
  }

  // Listen to BluetoothService and notify Comsumers on scan results
  void _listenToScanResults() async {
    _bluetoothService.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    });
  }

  void _listenToAdapter() {
    _bluetoothService.adapterState.listen((state) {
      print(state);
      _bluetoothAdapterState = state;
      if (state != BluetoothAdapterState.on) {
        _isScanning = false;
        _scanResults.clear();
      }
      notifyListeners();
    });
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }
}

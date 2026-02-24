import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rni_app/features/main/providers/live_chart_provider.dart';
import '../services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class BluetoothProvider with ChangeNotifier {
  final BlueService _bluetoothService = BlueService();
  // State
  List<ScanResult> _scanResults = [];
  BluetoothAdapterState _bluetoothAdapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  BluetoothDevice? _connectedDevice;
  String _receivedData = "";
  Stream<String>? _deviceDataStream;
  final ChartProvider _chartProvider;

  BluetoothProvider(this._chartProvider);

  // Getters
  List<ScanResult> get scanResults => _scanResults;
  BluetoothAdapterState get bluetoothAdapterState => _bluetoothAdapterState;
  bool get isScanning => _isScanning;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String get receivedData => _receivedData;

  void init() async {
    await _bluetoothService.init();
    _listenToScanResults();
    _listenToScanningState();
    _listenToAdapter();
  }

  // Call BluetoothService to start scanning for bluetooth devices
  Future<void> startScan() async {
    try {
      // if (!kIsWeb) {
      //   if (Platform.isAndroid) {
      //     await requestPermissions();
      //     await FlutterBluePlus.turnOn();
      //   }
      // }
      if (_bluetoothAdapterState == BluetoothAdapterState.on) {
        _scanResults.clear();
        await _bluetoothService.startScan();
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

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await _bluetoothService.stopScan();
      await _bluetoothService.connectToDevice(device); // Connect once

      _connectedDevice = device;

      // Discover services
      await _bluetoothService.discoverServices(device);

      // Listen to incoming data
      _deviceDataStream = _bluetoothService.listenToDevice(device);
      if (_deviceDataStream == null) {
        print("characteristics not found!");
        return;
      }
      _deviceDataStream!.listen((data) {
        _receivedData = data;
        print("ESP32 says: $data");

        // Parse and forward to ChartProvider
        final parsed = double.tryParse(data.trim());
        _chartProvider.addData(parsed); // ChartProvider handles null already

        notifyListeners();
      });

      notifyListeners();
    } catch (e) {
      print("Failed to connnect: $e");
      notifyListeners();
    }
  }

  // Disconnect from device
  Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        print("Disconnecting...");
        await _connectedDevice?.disconnect();
        print("Disconnected!");
      } else {
        print("Already disconnected!");
      }
      _connectedDevice = null;
      _receivedData = "";

      notifyListeners();
    } catch (e) {
      print("Failed to disconnect: $e");
    }
  }

  // Send data to ESP32
  Future<void> sendData(String message) async {
    try {
      await _bluetoothService.sendData(message);
    } catch (e) {
      print("Send error: $e");
    }
  }

  // Listen to BluetoothService and notify Comsumers on scan state changed
  void _listenToScanningState() async {
    _bluetoothService.isScanning.listen((scanning) {
      print(scanning);
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
        _connectedDevice = null;
      }
      notifyListeners();
    });
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      //Permission.location,
    ].request();
  }

  bool deviceIsConnected() {
    if (_connectedDevice != null) {
      return true;
    }
    return false;
  }
}

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

  //BLE characteristic
  BluetoothCharacteristic? _txCharacteristic;
  BluetoothCharacteristic? _rxCharacteristic;

  //TODO: remove Hardcode UUID
  String serviceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  String txUUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  String rxUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  Future<void> init() async {
    if (await FlutterBluePlus.isSupported == false) {
      throw Exception('Bluetooth is not supported by this device');
    }
  }

  Future<void> startScan({
    Duration timeout = const Duration(seconds: 60),
    List<String> keywords = const ["ESP32_BT"],
  }) async {
    // Check Adapter state
    try {
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidLegacy: true,
        withKeywords: keywords,
      );
    } catch (e) {
      throw "Failed to start scan: $e";
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      throw "Failed to stop scan: $e";
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // try {
      //   await device.createBond(); // Pre-emptive bonding on Android
      //   await Future.delayed(const Duration(milliseconds: 500));
      // } catch (e) {
      //   print('Bond creation note: $e');
      //   // Continue anyway - not all devices require bonding
      // }

      // Connect to chosen device
      await device.connect(license: License.free);
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  Stream<String>? listenToDevice(BluetoothDevice device) {
    try {
      if (_txCharacteristic == null) return null;

      _txCharacteristic!.setNotifyValue(true);

      return _txCharacteristic!.onValueReceived.map((value) {
        return String.fromCharCodes(value);
      });
    } catch (e) {
      throw "Failed to listen to device: $e";
    }
  }

  Future<void> sendData(String message) async {
    try {
      await _rxCharacteristic!.write(message.codeUnits);
    } catch (e) {
      throw Exception('Failed to send data: $e');
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    try {
      _txCharacteristic = null;
      _rxCharacteristic = null;

      List<BluetoothService> services = await device.discoverServices();
      print("Found ${services.length} services");

      for (BluetoothService service in services) {
        print("Service: ${service.uuid}");
        if (service.uuid.toString().toLowerCase() == serviceUUID) {
          for (BluetoothCharacteristic c in service.characteristics) {
            print("Characteristic: ${c.uuid}");
            if (c.uuid.toString().toLowerCase() == txUUID) {
              _txCharacteristic = c;
              print("TX found");
            }
            if (c.uuid.toString().toLowerCase() == rxUUID) {
              _rxCharacteristic = c;
              print("RX found");
            }
          }
        }
      }

      if (_txCharacteristic == null) {
        throw Exception("TX characteristic not found, check if UUIDs == ESP32");
      }
    } catch (e) {
      throw Exception('Failed to discover services: $e');
    }
  }
}

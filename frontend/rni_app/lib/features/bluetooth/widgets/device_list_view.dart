import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rni_app/features/bluetooth/services/bluetooth_service.dart';
import 'package:rni_app/features/bluetooth/widgets/device_item.dart';

class DeviceListView extends StatefulWidget {
  const DeviceListView({super.key});

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  final BlueService bluetoothService = BlueService.instance;
  List<ScanResult> _cachedDevices = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: bluetoothService.scanResults,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Only update if we received a non-empty list
        final incoming = snapshot.data ?? [];
        if (incoming.isNotEmpty) {
          _cachedDevices = incoming;
        }

        if (_cachedDevices.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bluetooth_searching, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('Waiting for devices...'),
              ],
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: _cachedDevices.length,
            itemBuilder: (context, index) {
              final result = _cachedDevices[index];
              final device = result.device;
              final rssi = result.rssi;
              final name = device.platformName.isNotEmpty
                  ? device.platformName
                  : 'Unknown Device';

              return DeviceItem(name: name, device: device, rssi: rssi);
            },
          ),
        );
      },
    );
  }
}

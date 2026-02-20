import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceItem extends StatelessWidget {
  const DeviceItem({
    super.key,
    required this.name,
    required this.device,
    required this.rssi,
  });

  final String name;
  final BluetoothDevice device;
  final int rssi;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          //TODO: Connect to device via device.connect()
          device.connect(license: License.free);
        },
        leading: const Icon(Icons.bluetooth, color: Colors.blue),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('ID: ${device.remoteId}'), Text('RSSI: $rssi dBm')],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rni_app/features/bluetooth/providers/bluetooth_provider.dart';
import 'package:rni_app/features/bluetooth/widgets/bluetooth_scanning_button.dart';
import 'package:rni_app/features/bluetooth/widgets/device_list_view.dart';
import 'package:rni_app/features/bluetooth/widgets/is_scanning_indicator.dart';

class BluetoothSettingsPage extends StatefulWidget {
  const BluetoothSettingsPage({super.key});

  @override
  State<BluetoothSettingsPage> createState() => _BluetoothSettingsPageState();
}

class _BluetoothSettingsPageState extends State<BluetoothSettingsPage> {
  @override
  void initState() {
    super.initState();
    // Initialize BluetoothProvider when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BluetoothProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BluetoothScanningPage();
  }
}

class BluetoothScanningPage extends StatelessWidget {
  const BluetoothScanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetooth = context.watch<BluetoothProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Scanner'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: IsScanningIndicator(bluetooth: bluetooth),
          ),
          const Expanded(child: DeviceListView()),
        ],
      ),
      floatingActionButton: const BluetoothScanButton(),
    );
  }
}

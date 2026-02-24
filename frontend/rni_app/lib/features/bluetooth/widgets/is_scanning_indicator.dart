import 'package:flutter/material.dart';
import 'package:rni_app/features/bluetooth/providers/bluetooth_provider.dart';

class IsScanningIndicator extends StatelessWidget {
  const IsScanningIndicator({super.key, required this.bluetooth});

  final BluetoothProvider bluetooth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (bluetooth.isScanning) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          bluetooth.isScanning
              ? 'Scanning... (${bluetooth.scanResults.length} devices)'
              : 'Found ${bluetooth.scanResults.length} devices',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

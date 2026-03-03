import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rni_app/features/bluetooth/providers/bluetooth_provider.dart';

class LiveSensorSummary extends StatefulWidget {
  const LiveSensorSummary({super.key});

  @override
  State<LiveSensorSummary> createState() => _LiveSensorSummaryState();
}

class _LiveSensorSummaryState extends State<LiveSensorSummary> {
  @override
  Widget build(BuildContext context) {
    final deviceConnected = context
        .watch<BluetoothProvider>()
        .deviceIsConnected();
    return (deviceConnected)
        ? Consumer<BluetoothProvider>(
            builder: (context, bluetooth, _) {
              return Column(
                children: [
                  Text("Dust: ${bluetooth.dustData} µg/m³"),
                  Text("Temp: ${bluetooth.tempData} °C"),
                  Text("Humidity: ${bluetooth.humData} %"),
                ],
              );
            },
          )
        : const SizedBox.shrink();
  }
}

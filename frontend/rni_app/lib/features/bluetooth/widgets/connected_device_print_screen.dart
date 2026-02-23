import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rni_app/features/bluetooth/providers/bluetooth_provider.dart';

class ConnectedDevicePrintScreen extends StatelessWidget {
  const ConnectedDevicePrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Connection status
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: provider.connectedDevice != null
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.connectedDevice != null
                        ? "Connected"
                        : "Disconnected",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Data display terminal
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      provider.receivedData.isEmpty
                          ? "Waiting for data from ESP32..."
                          : provider.receivedData,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Send button
              ElevatedButton.icon(
                onPressed: () => provider.sendData("Hello ESP32!"),
                icon: const Icon(Icons.send),
                label: const Text("Send Test Message"),
              ),
            ],
          ),
        );
      },
    );
  }
}

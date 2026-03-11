import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:rni_app/features/bluetooth/providers/bluetooth_provider.dart';
import 'package:rni_app/features/bluetooth/widgets/send_Data_button.dart';
import 'package:rni_app/features/main/widgets/settings_switch.dart';

class FanModeControl extends StatelessWidget {
  const FanModeControl({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetooth = context.watch<BluetoothProvider>();
    final isAuto = bluetooth.fanAuto;
    final isConnected = bluetooth.deviceIsConnected();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Auto/Manual Toggle
        SettingsSwitch(
          inactiveThumbColor: Colors.blue,
          text: 'Auto Fan Mode',
          value: isAuto,
          onChanged: (isConnected)
              ? (bool _) {
                  context.read<BluetoothProvider>().toggleFanMode();
                }
              : null,
          height: 30,
        ),
        if (!isAuto) ...[
          const SizedBox(height: 8),
          const SafeArea(
            child: Row(
              children: [
                Gap(10),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: SendDataButton(
                    fontSize: 12,
                    message: "Fan Manual On",
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
                Gap(4),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: SendDataButton(
                    fontSize: 12,
                    message: "Fan Manual Off",
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

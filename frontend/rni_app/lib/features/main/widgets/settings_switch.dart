import 'package:flutter/material.dart';

//Reusable Switch Widget
class SettingsSwitch extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double? width;
  final double? height;
  final Color? activeTrackColor; // Track color when ON
  final Color? inactiveThumbColor; // Thumb color when OFF
  final Color? inactiveTrackColor; // Track color when OFF

  const SettingsSwitch({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Transform.scale(
        scaleX: width != null ? width! / 51.0 : 1.0,
        scaleY: height != null ? height! / 31.0 : 1.0,
        alignment: Alignment.centerLeft,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: activeTrackColor,
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
        ),
      ),
      title: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rni_app/features/main/providers/live_chart_provider.dart';

class ChartTimeStepSetting extends StatelessWidget {
  const ChartTimeStepSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextFormFieldExample();
  }
}

class TextFormFieldExample extends StatefulWidget {
  const TextFormFieldExample({super.key});

  @override
  State<TextFormFieldExample> createState() => _TextFormFieldExampleState();
}

class _TextFormFieldExampleState extends State<TextFormFieldExample> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? forceErrorText;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final double? valueToDouble = double.tryParse(value);
    if (valueToDouble == null) {
      return 'Please input numbers';
    }
    if (valueToDouble <= 0) {
      return 'Invalid value';
    }
    return null;
  }

  void onChanged(String value) {
    // Nullify forceErrorText if the input changed.
    if (forceErrorText != null) {
      setState(() {
        forceErrorText = null;
      });
    }
  }

  Future<void> onSave() async {
    // Providing a default value in case this was called on the
    // first frame, the [fromKey.currentState] will be null.
    final bool isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    context.read<ChartProvider>().changeChartTime(
      double.parse(controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 100,
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              forceErrorText: forceErrorText,
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Chart Time Steps (seconds)',
              ),
              validator: validator,
              onChanged: onChanged,
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else
              TextButton(onPressed: onSave, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

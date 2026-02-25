import 'package:flutter/material.dart';
import 'package:rni_app/features/main/widgets/live_pm_chart.dart';
import 'package:rni_app/features/main/widgets/toggle_pm_chart_button.dart';

/*
Index 1: Main Page
  Contain Graphs, Charts and device controls
*/
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Center(child: Column(children: [LivePMChart()])),
      floatingActionButton: TogglePMChartButton(),
    );
  }
}

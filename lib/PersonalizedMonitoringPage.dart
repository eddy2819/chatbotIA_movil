import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PersonalizedMonitoringPage extends StatelessWidget {
  const PersonalizedMonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoreo Personalizado', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Personalizado',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildChartCard('Niveles de Glucosa', _glucoseData()),
              SizedBox(height: 20),
              _buildChartCard('Insulina Administrada', _insulinData()),
              SizedBox(height: 20),
              _buildChartCard('Carbohidratos Consumidos', _carbsData()),
              SizedBox(height: 20),
              _buildChartCard('Actividades Físicas', _activityData()),
              SizedBox(height: 20),
              Text(
                'Notificaciones Inteligentes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard('Recordatorio: Tomar Medicamentos'),
              _buildNotificationCard('Recordatorio: Registrar Niveles de Glucosa'),
              _buildNotificationCard('Recordatorio: Comer algo (Niveles bajos)'),
              SizedBox(height: 20),
              Text(
                'Predicciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPredictionCard('Sugerencia: Ajustar dieta'),
              _buildPredictionCard('Sugerencia: Aumentar actividad física'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, List<FlSpot> data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String text) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.purple),
        title: Text(text),
      ),
    );
  }

  Widget _buildPredictionCard(String text) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.trending_up, color: Colors.purple),
        title: Text(text),
      ),
    );
  }

  List<FlSpot> _glucoseData() {
    return [
      FlSpot(0, 100),
      FlSpot(1, 110),
      FlSpot(2, 105),
      FlSpot(3, 115),
      FlSpot(4, 120),
      FlSpot(5, 130),
    ];
  }

  List<FlSpot> _insulinData() {
    return [
      FlSpot(0, 10),
      FlSpot(1, 12),
      FlSpot(2, 8),
      FlSpot(3, 15),
      FlSpot(4, 10),
      FlSpot(5, 14),
    ];
  }

  List<FlSpot> _carbsData() {
    return [
      FlSpot(0, 50),
      FlSpot(1, 60),
      FlSpot(2, 55),
      FlSpot(3, 70),
      FlSpot(4, 65),
      FlSpot(5, 75),
    ];
  }

  List<FlSpot> _activityData() {
    return [
      FlSpot(0, 30),
      FlSpot(1, 40),
      FlSpot(2, 35),
      FlSpot(3, 45),
      FlSpot(4, 50),
      FlSpot(5, 55),
    ];
  }
}

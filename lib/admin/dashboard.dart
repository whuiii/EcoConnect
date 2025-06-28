import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigate/color.dart';

enum ViewMode { weekly, monthly }

enum ChartType { orders, weight }

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  ViewMode _selectedMode = ViewMode.monthly;
  ChartType _selectedChart = ChartType.orders;

  Map<String, int> deliveryCountPerKey = {};
  Map<String, double> weightPerKey = {};
  int totalOrders = 0;
  double totalWeight = 0.0;
  double averageWeight = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('deliveries')
        .orderBy('completedAt', descending: false)
        .get();

    final now = DateTime.now();
    Map<String, int> counts = {};
    Map<String, double> weights = {};
    double weightSum = 0.0;
    int orderSum = 0;

    for (var doc in snapshot.docs) {
      final completedAt = (doc['completedAt'] as Timestamp).toDate();
      final weight =
          double.tryParse(doc['bagWeight']?.toString() ?? '0') ?? 0.0;

      bool include = false;
      String key = '';

      switch (_selectedMode) {
        case ViewMode.weekly:
          final difference = now.difference(completedAt).inDays;
          include = difference <= 7;
          key = '${DateFormat('yyyy-MM-dd').format(completedAt)}';
          break;
        case ViewMode.monthly:
          include =
              completedAt.year == now.year && completedAt.month == now.month;
          key = DateFormat('yyyy-MM').format(completedAt);
          break;
      }

      if (include) {
        counts[key] = (counts[key] ?? 0) + 1;
        weights[key] = (weights[key] ?? 0.0) + weight;
        orderSum++;
        weightSum += weight;
      }
    }

    setState(() {
      deliveryCountPerKey = counts;
      weightPerKey = weights;
      totalOrders = orderSum;
      totalWeight = weightSum;
      averageWeight = (orderSum == 0) ? 0.0 : (weightSum / orderSum);
      isLoading = false;
    });
  }

  Widget _infoCard(String title, String value, IconData icon, ChartType type) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedChart = type;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _selectedChart == type
                ? Colors.green.shade200
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            children: [
              Icon(icon, color: green2, size: 28),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = deliveryCountPerKey.keys.toList()..sort();

    final maxY = _selectedChart == ChartType.orders
        ? (deliveryCountPerKey.values.isNotEmpty
            ? deliveryCountPerKey.values
                .reduce((a, b) => a > b ? a : b)
                .toDouble()
            : 1)
        : (weightPerKey.values.isNotEmpty
            ? weightPerKey.values.reduce((a, b) => a > b ? a : b)
            : 1);

    final interval = (maxY / 10).ceilToDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons
                .share), // or Icons.file_download / Icons.download_outlined
            tooltip: 'Export CSV',
            onPressed: () {
              // Your CSV export logic here
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recycle Stats",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<ViewMode>(
                        value: _selectedMode,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedMode = value);
                            fetchData();
                          }
                        },
                        items: ViewMode.values.map((mode) {
                          return DropdownMenuItem<ViewMode>(
                            value: mode,
                            child: Text(mode.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoCard("Total Orders", totalOrders.toString(),
                          Icons.receipt, ChartType.orders),
                      _infoCard(
                          "Total Weight",
                          "${totalWeight.toStringAsFixed(2)} kg",
                          Icons.scale,
                          ChartType.weight),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, _) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < sortedKeys.length) {
                                    final key = sortedKeys[index];
                                    final parts = key.split('-');

                                    if (parts.length == 3) {
                                      // 🟢 weekly: "yyyy-MM-dd"
                                      final day = parts[2];
                                      final month = DateFormat('MMM').format(
                                        DateTime(
                                            0, int.tryParse(parts[1]) ?? 1),
                                      );
                                      return Text('$day $month',
                                          style: const TextStyle(fontSize: 12));
                                    } else if (parts.length == 2) {
                                      // 🟢 monthly: "yyyy-MM"
                                      final month = DateFormat('MMM').format(
                                        DateTime(
                                            0, int.tryParse(parts[1]) ?? 1),
                                      );
                                      return Text(month,
                                          style: const TextStyle(fontSize: 12));
                                    }
                                  }
                                  return const SizedBox();
                                }),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: interval,
                              getTitlesWidget: (value, _) {
                                return value % interval == 0
                                    ? Text('${value.toInt()}')
                                    : const SizedBox();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(sortedKeys.length, (index) {
                          final key = sortedKeys[index];
                          final value = _selectedChart == ChartType.orders
                              ? deliveryCountPerKey[key]!.toDouble()
                              : weightPerKey[key] ?? 0.0;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                width: 20,
                                color: green3,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

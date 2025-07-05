import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:navigate/color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

//Enum for toggle between weekly, monthly, orders and weight
enum ViewMode { weekly, monthly }

enum ChartType { orders, weight }

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  //State/ Initial Variable
  ViewMode _selectedMode = ViewMode.monthly;
  ChartType _selectedChart = ChartType.orders;
  DateTime _viewDate = DateTime.now();
  int? _selectedBarIndex;

  //Data maps for charts
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

  //Fetch Delivery Data from Deliveries
  Future<void> fetchData() async {
    setState(() => isLoading = true);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('deliveries')
        .orderBy('completedAt', descending: false)
        .get();

    final now = _viewDate;
    Map<String, int> counts = {};
    Map<String, double> weights = {};
    double weightSum = 0.0;
    int orderSum = 0;

    //Get totalWeightKG from completedAt
    for (var doc in snapshot.docs) {
      if (!doc.data().toString().contains('completedAt')) continue;

      final completedAt = (doc['completedAt'] as Timestamp).toDate();
      final weight =
          double.tryParse(doc['totalWeightKg']?.toString() ?? '0') ?? 0.0;

      bool include = false;
      String key = '';

      // Check it is selected on weekly or monthly
      switch (_selectedMode) {
        case ViewMode.weekly:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          include = completedAt
                  .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              completedAt.isBefore(endOfWeek.add(const Duration(days: 1)));
          key = DateFormat('yyyy-MM-dd').format(completedAt);
          break;

        case ViewMode.monthly:
          include =
              completedAt.year == now.year && completedAt.month == now.month;
          key = DateFormat('yyyy-MM').format(completedAt);
          break;
      }

      // Update count and weight existed within the time period
      if (include) {
        counts[key] = (counts[key] ?? 0) + 1;
        weights[key] = (weights[key] ?? 0.0) + weight;
        orderSum++;
        weightSum += weight;
      }
    }

    // Update the state with processed results
    setState(() {
      deliveryCountPerKey = counts;
      weightPerKey = weights;
      totalOrders = orderSum;
      totalWeight = weightSum;
      averageWeight = (orderSum == 0) ? 0.0 : (weightSum / orderSum);
      isLoading = false;
    });
  }

  // Move to the next week/month
  void _onSwipeLeft() {
    setState(() {
      if (_selectedMode == ViewMode.weekly) {
        _viewDate = _viewDate.add(const Duration(days: 7));
      } else {
        _viewDate = DateTime(_viewDate.year, _viewDate.month + 1, 1);
      }
    });
    fetchData();
  }

  // Move to the previous week/month
  void _onSwipeRight() {
    setState(() {
      if (_selectedMode == ViewMode.weekly) {
        _viewDate = _viewDate.subtract(const Duration(days: 7));
      } else {
        _viewDate = DateTime(_viewDate.year, _viewDate.month - 1, 1);
      }
    });
    fetchData();
  }

  //Export CSV Monthly
  Future<void> exportMonthlyCSV() async {
    final now = _viewDate;
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('deliveries')
        .orderBy('completedAt', descending: false)
        .get();

    List<List<dynamic>> rows = [
      [
        'Username',
        'Phone Number',
        'Material',
        'Weight (kg)',
        'Point',
        'Completed At'
      ]
    ];

    int totalOrders = 0;
    double totalWeight = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('completedAt')) continue;

      final completedAt = (data['completedAt'] as Timestamp).toDate();
      if (completedAt.isBefore(start) || completedAt.isAfter(end)) continue;

      final username = data['username'] ?? '';
      final phone = data['phoneNumber'] ?? '';
      final breakdown = data['materialsBreakdown'] ?? [];
      final weightThis = (data['totalWeightKg'] ?? 0).toDouble();

      totalOrders++;
      totalWeight += weightThis;

      for (var item in breakdown) {
        rows.add([
          username,
          phone,
          item['material'] ?? '',
          item['weight']?.toString() ?? '0',
          item['point']?.toString() ?? '0',
          DateFormat('yyyy-MM-dd HH:mm').format(completedAt),
        ]);
      }
    }

    rows.add([]);
    rows.add(['Total Orders', totalOrders]);
    rows.add(['Total Weight (kg)', totalWeight.toStringAsFixed(2)]);

    final csv = const ListToCsvConverter().convert(rows);
    final fileName =
        '${DateFormat('MMMM yyyy').format(now)} Monthly Report.csv';

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$fileName';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Exported Monthly Report');
  }

  //Export CSV Weekly
  Future<void> exportWeeklyCSV() async {
    final now = _viewDate;
    final start =
        _viewDate.subtract(Duration(days: _viewDate.weekday - 1)); // Monday
    final end = start.add(const Duration(days: 6)); // Sunday

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('deliveries')
        .orderBy('completedAt', descending: false)
        .get();

    List<List<dynamic>> rows = [
      [
        'Username',
        'Phone Number',
        'Material',
        'Weight (kg)',
        'Point',
        'Completed At'
      ]
    ];

    int totalOrders = 0;
    double totalWeight = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('completedAt')) continue;

      final completedAt = (data['completedAt'] as Timestamp).toDate();
      if (completedAt.isBefore(start) || completedAt.isAfter(end)) continue;

      final username = data['username'] ?? '';
      final phone = data['phoneNumber'] ?? '';
      final breakdown = data['materialsBreakdown'] ?? [];
      final weightThis = (data['totalWeightKg'] ?? 0).toDouble();

      totalOrders++;
      totalWeight += weightThis;

      for (var item in breakdown) {
        rows.add([
          username,
          phone,
          item['material'] ?? '',
          item['weight']?.toString() ?? '0',
          item['point']?.toString() ?? '0',
          DateFormat('yyyy-MM-dd HH:mm').format(completedAt),
        ]);
      }
    }

    rows.add([]);
    rows.add(['Total Orders', totalOrders]);
    rows.add(['Total Weight (kg)', totalWeight.toStringAsFixed(2)]);

    final fileName =
        '${DateFormat('d MMMM').format(start)} - ${DateFormat('d MMMM yyyy').format(end)} Weekly Report.csv';

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$fileName';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Exported Weekly Report');
  }

  // Build small summary card for total orders or weight
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
            icon: const Icon(Icons.share),
            tooltip: 'Export CSV',
            onPressed: () async {
              if (_selectedMode == ViewMode.monthly) {
                await exportMonthlyCSV();
              } else {
                await exportWeeklyCSV();
              }
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
                            setState(() {
                              _selectedMode = value;
                              _viewDate = DateTime.now();
                            });
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
                  const SizedBox(height: 16),

                  //Bar Chart Title
                  Text(
                    _selectedMode == ViewMode.weekly
                        ? '${DateFormat('d MMM').format(_viewDate.subtract(Duration(days: _viewDate.weekday - 1)))} - '
                            '${DateFormat('d MMM').format(_viewDate.add(Duration(days: 7 - _viewDate.weekday)))}'
                        : DateFormat('MMMM yyyy').format(_viewDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  //Function for Swiping Left and Right
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        _onSwipeLeft();
                      } else if (details.primaryVelocity! > 0) {
                        _onSwipeRight();
                      }
                    },

                    //Bar Chart
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              //X-Axis Value
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, _) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < sortedKeys.length) {
                                    final key = sortedKeys[index];
                                    final parts = key.split('-');

                                    // Show label as "12 Mar" or "Mar"
                                    if (parts.length == 3) {
                                      final day = parts[2];
                                      final month = DateFormat('MMM').format(
                                        DateTime(
                                            0, int.tryParse(parts[1]) ?? 1),
                                      );

                                      //"12 Mar"
                                      return Text('$day $month',
                                          style: const TextStyle(fontSize: 12));
                                    } else if (parts.length == 2) {
                                      final month = DateFormat('MMM').format(
                                        DateTime(
                                            0, int.tryParse(parts[1]) ?? 1),
                                      );

                                      //"Mar"
                                      return Text(month,
                                          style: const TextStyle(fontSize: 12));
                                    }
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            //Y-Axis
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

                            final isSelected = _selectedBarIndex == index;

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: value,
                                  width: 20,
                                  color: isSelected
                                      ? green3
                                      : Colors
                                          .grey[400], // 🌟 Highlight selected
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }),

                          //Show Horizontal Line
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false, // ❌ No vertical lines
                            drawHorizontalLine: true, // ✅ Show horizontal lines
                            horizontalInterval:
                                interval, // Set interval between horizontal lines
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: green1, // Optional: customize line color
                              strokeWidth: 0.5, // Optional: line thickness
                              dashArray: [4, 4], // Optional: make it solid line
                            ),
                          ),

                          //Touch Then Change Color
                          barTouchData: BarTouchData(
                            touchCallback: (event, response) {
                              if (response != null && response.spot != null) {
                                setState(() {
                                  _selectedBarIndex =
                                      response.spot!.touchedBarGroupIndex;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

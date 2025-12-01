import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../Firebase/focus_service.dart';
import '../../theme/app_colors.dart';

class FocusHistoryChart extends StatefulWidget {
  final FocusService focusService;

  const FocusHistoryChart({super.key, required this.focusService});

  @override
  State<FocusHistoryChart> createState() => _FocusHistoryChartState();
}

class _FocusHistoryChartState extends State<FocusHistoryChart> {
  int _selectedRange = 7; // 7 or 30 days
  bool _isLoading = true;
  Map<String, double> _data = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final data = await widget.focusService.getHistoryStats(_selectedRange);
    if (mounted) {
      setState(() {
        _data = data;
        _isLoading = false;
      });
    }
  }

  void _onRangeChanged(int days) {
    if (_selectedRange == days) return;
    setState(() => _selectedRange = days);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Focus History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepSapphire,
                ),
              ),
              // Range Selector
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _buildRangeButton(7, "7 Days"),
                    _buildRangeButton(30, "30 Days"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Area
          AspectRatio(
            aspectRatio: 1.5,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _data.isEmpty
                    ? const Center(child: Text("No data available"))
                    : LineChart(
                        _buildLineChartData(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeButton(int value, String text) {
    final isSelected = _selectedRange == value;
    return GestureDetector(
      onTap: () => _onRangeChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  )
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.deepSapphire : AppColors.grey,
          ),
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 30, // Grid line every 30 minutes
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
            dashArray: [5, 5], // Soft dashed lines
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _selectedRange == 7 ? 1 : 5, // Show fewer labels for 30 days
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 60, // Label every 60 minutes (1 hour)
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // No hard border
      ),
      minX: 0,
      maxX: (_data.length - 1).toDouble(),
      minY: 0,
      maxY: _calculateMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _generateSpots(),
          isCurved: true,
          color: AppColors.oceanBlue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: _selectedRange == 7, // Only show dots for 7 days view
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: AppColors.oceanBlue,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.oceanBlue.withValues(alpha: 0.3),
                AppColors.oceanBlue.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.deepSapphire,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final dateKey = _data.keys.elementAt(barSpot.x.toInt());
              final minutes = barSpot.y.toInt();
              
              // Format tooltip text
              String timeText;
              if (minutes >= 60) {
                 int h = minutes ~/ 60;
                 int m = minutes % 60;
                 timeText = "${h}h ${m}m";
              } else {
                 timeText = "${minutes}m";
              }

              return LineTooltipItem(
                '$dateKey\n',
                const TextStyle(
                  color: Colors.white70, 
                  fontWeight: FontWeight.normal, 
                  fontSize: 12
                ),
                children: [
                  TextSpan(
                    text: timeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // --- Helpers for Data and Labels ---

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    int index = 0;
    _data.forEach((key, value) {
      spots.add(FlSpot(index.toDouble(), value));
      index++;
    });
    return spots;
  }

  double _calculateMaxY() {
    double max = 0;
    for (var val in _data.values) {
      if (val > max) max = val;
    }
    // Ensure chart has some headroom. Defaults to 60m (1h) if empty.
    return max < 60 ? 60 : max * 1.2;
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _data.length) return const SizedBox();

    // Logic to skip labels if too crowded (handled by interval, but extra safety here)
    if (_selectedRange == 30 && index % 5 != 0) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        _data.keys.elementAt(index), // "MM-DD"
        style: const TextStyle(
          color: AppColors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if (value == 0) return const SizedBox(); // Don't show 0

    // Format minutes to Hours
    // e.g., 60 -> "1h", 120 -> "2h", 90 -> "1.5h"
    String text;
    if (value % 60 == 0) {
      text = '${(value / 60).toInt()}h';
    } else {
       // Only show major minute markers if range is small, otherwise hide
       return const SizedBox(); 
    }

    return Text(
      text,
      style: const TextStyle(
        color: AppColors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      textAlign: TextAlign.left,
    );
  }
}
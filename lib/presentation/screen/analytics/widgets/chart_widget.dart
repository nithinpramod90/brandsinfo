import 'package:brandsinfo/presentation/screen/analytics/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class RevenueChart extends StatefulWidget {
  final String title;
  final List<String> filterOptions;
  const RevenueChart({
    Key? key,
    this.title = "Daily Revenue",
    this.filterOptions = const [],
  }) : super(key: key);
  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;
  double _scrollVelocity = 0;
  double _scrollEffect = 0;
  final RevenueChartController controller = Get.put(RevenueChartController());
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _scrollController.addListener(_handleScroll);

    ever(controller.chartData, (_) => _resetAnimation());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted) return;
    setState(() {
      final currentOffset = _scrollController.offset;
      _scrollVelocity = (currentOffset - _lastScrollOffset);
      _lastScrollOffset = currentOffset;

      _scrollEffect = math.min(1.0, math.max(-1.0, _scrollVelocity / 10));
    });
  }

  void _resetAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : _buildChart()),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Obx(() {
                  final data = controller.chartData;
                  if (data.isEmpty) {
                    return Center(child: Text("No data available"));
                  }

                  return SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_scrollEffect * 0.05),
                      transformAlignment: Alignment.center,
                      width: math.max(500, data.length * 45.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 20.0),
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: (data.length - 1).toDouble(),
                            minY: 0,
                            maxY: _getChartMaxY(),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: _calculateYAxisInterval(),
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.2),
                                  strokeWidth: 0.5,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: _calculateYAxisInterval(),
                                  getTitlesWidget: (value, meta) {
                                    // Format the y-axis value (revenue amount)
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        _formatYAxisValue(value),
                                        style: TextStyle(
                                          // color: Colors.black54,
                                          fontSize: 9,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  interval:
                                      _calculateXAxisInterval(data.length),
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= data.length)
                                      return Container();

                                    // Skip labels based on interval
                                    if (index %
                                            _calculateXAxisInterval(data.length)
                                                .toInt() !=
                                        0) return Container();

                                    double opacity = _fadeAnimation.value;
                                    if (opacity < 0.2) opacity = 0;

                                    double labelShift = (index.toDouble() -
                                            _scrollController.offset / 50) *
                                        0.5;
                                    double verticalOffset =
                                        _scrollEffect * labelShift;

                                    String label = _getFormattedDate(
                                        data[index]['date'], "Daily");

                                    return Opacity(
                                      opacity: opacity,
                                      child: Transform.translate(
                                        offset: Offset(0, verticalOffset),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: index ==
                                                      _getVisibleCenterIndex()
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            // Added lineTouchData to format integer values on touch
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems:
                                    (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    // Format the value as an integer by removing decimal places
                                    final intValue = spot.y.toInt();
                                    final dateIndex = spot.x.toInt();
                                    String date = "";
                                    if (dateIndex >= 0 &&
                                        dateIndex < data.length) {
                                      date = _getFormattedDate(
                                          data[dateIndex]['date'], "Daily");
                                    }

                                    return LineTooltipItem(
                                      '$date: $intValue',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                              handleBuiltInTouches: true,
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                      List<int> spotIndexes) {
                                return spotIndexes.map((spotIndex) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                        color: Colors.orange, strokeWidth: 2),
                                    FlDotData(
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 5,
                                          color: Colors.orange,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getAnimatedSpots(),
                                isCurved: true,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.indigo.shade50 // Dark mode color
                                    : Colors.black26, // Light mode color,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.black
                                      .withOpacity(0.1 * _fadeAnimation.value),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.withOpacity(
                                          0.1 + _scrollEffect.abs() * 0.05),
                                      Colors.black.withOpacity(
                                          0.05 + _scrollEffect.abs() * 0.03),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(
                                  show: _animationController.isCompleted,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    final centerIndex =
                                        _getVisibleCenterIndex();
                                    final distanceFromCenter =
                                        (index - centerIndex).abs();
                                    final scaleFactor = 1.0 -
                                        (distanceFromCenter * 0.1)
                                            .clamp(0.0, 0.3);

                                    double radius = 3.0 * scaleFactor;

                                    if (index == data.length - 1) {
                                      double pulseValue = 1 +
                                          0.5 *
                                              math.sin(
                                                  _animationController.value *
                                                      5 *
                                                      math.pi);
                                      radius *= pulseValue;
                                    }

                                    if ((index - centerIndex).abs() < 2) {
                                      radius += _scrollEffect.abs() * 0.5;
                                    }

                                    return FlDotCirclePainter(
                                      radius: radius,
                                      color: index == centerIndex
                                          ? Colors.black
                                          : Colors.grey
                                              .withOpacity(scaleFactor),
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(String dateString, String filterType) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMM').format(date);
    } catch (e) {
      print('Date parsing error: $e');
      return dateString;
    }
  }

  double _getChartMaxY() {
    if (controller.chartData.isEmpty) return 500;
    final max = controller.getMax();
    return (max * 1.2).ceilToDouble();
  }

  // Format y-axis values to be readable (e.g., 1K, 2.5K)
  String _formatYAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value
          .toInt()
          .toString(); // Convert to integer for y-axis labels too
    }
  }

  // Calculate appropriate interval for y-axis based on data
  double _calculateYAxisInterval() {
    double maxY = _getChartMaxY();
    // Show 4-5 intervals on y-axis
    return (maxY / 4).ceilToDouble();
  }

  // Calculate appropriate interval for x-axis based on data length
  double _calculateXAxisInterval(int dataLength) {
    // Adjust based on data length to prevent overcrowding
    if (dataLength <= 7) return 1; // Show all labels for small datasets
    if (dataLength <= 14) return 2; // Show every other label
    if (dataLength <= 30) return 3; // Show every third label
    return (dataLength / 10)
        .ceil()
        .toDouble(); // Show ~10 labels for large datasets
  }

  int _getVisibleCenterIndex() {
    if (_scrollController.positions.isEmpty) return 0;
    final data = controller.chartData;
    if (data.isEmpty) return 0;

    final scrollPos = _scrollController.offset;
    final viewportWidth = _scrollController.position.viewportDimension;
    final centerPos = scrollPos + (viewportWidth / 2);
    final estimatedIndex = (centerPos / 45).round().clamp(0, data.length - 1);
    return estimatedIndex;
  }

  List<FlSpot> _getAnimatedSpots() {
    final data = controller.chartData;
    if (data.isEmpty) return [];
    if (!_animationController.isCompleted) {
      final spots = <FlSpot>[];
      final pointCount = data.length;

      for (int i = 0; i < pointCount; i++) {
        final pointProgress = _lineAnimation.value * pointCount - i;
        if (pointProgress <= 0) continue;

        final visibleY =
            math.min(1.0, pointProgress) * data[i]["count"].toDouble();
        spots.add(FlSpot(i.toDouble(), visibleY));
      }

      return spots;
    } else {
      final spots = <FlSpot>[];
      final centerIndex = _getVisibleCenterIndex();

      for (int i = 0; i < data.length; i++) {
        double y = data[i]["count"].toDouble();

        if (_scrollVelocity.abs() > 0.1) {
          final distanceFromCenter = (i - centerIndex).abs();
          if (distanceFromCenter < 3) {
            final scrollImpact =
                _scrollEffect * (1.0 - distanceFromCenter * 0.3);
            y += scrollImpact * 10;
          }
        }

        spots.add(FlSpot(i.toDouble(), y));
      }

      return spots;
    }
  }
}

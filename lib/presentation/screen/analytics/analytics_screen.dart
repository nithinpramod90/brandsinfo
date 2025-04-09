import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/analytics/analytics_controller.dart';
import 'package:brandsinfo/presentation/screen/analytics/widgets/chart_widget.dart';
import 'package:brandsinfo/presentation/screen/analytics/widgets/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // You might need to add this package

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key, required this.bid})
      : super(key: key);
  final String bid;
  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final AnalyticsController _controller = AnalyticsController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.fetchAnalyticsData(widget.bid);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${_controller.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              _buildProgressGrid(),

              const SizedBox(height: 24),

              // Visits chart
              RevenueChart(),
              const SizedBox(height: 24),

              // Most searched products
              _buildMostSearchedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressGrid() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        ProgressContainer(
          number: _controller.leads,
          text: "Leads",
          progress: 0.6, // Set progress (0.0 - 1.0)
          color: Colors.black,
          txtcolour: Colors.white,
        ),
        ProgressContainer(
          number: _controller.searchedCount,
          text: "Searched",
          progress: 0.8,
          color: Colors.white,
          txtcolour: Colors.black,
        ),
        ProgressContainer(
          txtcolour: Colors.black,
          number: _controller.averageTimeSpent,
          text: "Avg Time",
          progress: 0.5,
          color: Colors.white,
        ),
        ProgressContainer(
          txtcolour: Colors.black,
          number: _controller.profileViewsProgress,
          text: "Profile Progress",
          progress: 0.3,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildMostSearchedProducts() {
    final products = _controller.mostSearchedProducts;

    if (products.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No product data available')),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Searched Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = product['product_images'][0]['image'];

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${ApiConstants.apiurl}$imageUrl",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                title: Text(product['name']),
                subtitle: Text(
                    '${product['price']} • Searched ${product['searched']} times'),
              );
            },
          ),
        ],
      ),
    );
  }
}

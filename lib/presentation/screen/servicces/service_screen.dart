import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/add_service/add_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'service_controller.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key, required this.bid});
  final String bid;

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ServiceController controller;

  @override
  void initState() {
    super.initState();
    controller = ServiceController(bid: widget.bid);
    controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Get.off(
                    () => AddServiceScreen(business: int.parse(widget.bid)));
              },
              icon: Icon(Icons.add)),
        ],
        elevation: 2,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${controller.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchServices,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.services.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.services.length,
              itemBuilder: (context, index) {
                final service = controller.services[index];
                return ServiceCard(
                  service: service,
                  onDelete: () async {
                    // Show confirmation dialog
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Service'),
                        content: Text(
                            'Are you sure you want to delete ${service.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      controller.deleteService(service.id);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchServices,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Service Card Widget
class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  '${ApiConstants.apiurl}${service.image}',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    iconSize: 1,
                    icon:
                        const Icon(Icons.delete, color: Colors.white, size: 20),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      service.cat,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

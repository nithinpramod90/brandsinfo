import 'package:brandsinfo/presentation/screen/enquiries/enquiry_controller.dart';
import 'package:brandsinfo/presentation/screen/enquiries/enquiry_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnquiriesScreen extends StatelessWidget {
  final EnquiriesController controller = Get.put(EnquiriesController());

  EnquiriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Enquiries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshEnquiries,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading enquiries',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(controller.errorMessage.value),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.fetchEnquiries,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.enquiries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.inbox,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No enquiries yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchEnquiries();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.enquiries.length,
            itemBuilder: (context, index) {
              final enquiry = controller.enquiries[index];
              return EnquiryCard(
                enquiry: enquiry,
                formattedDateTime: controller.formatDateAndTime(
                  enquiry.date,
                  enquiry.time,
                ),
                onTap: () {
                  if (!enquiry.isRead) {
                    controller.markAsRead(enquiry.id);
                  }
                  showEnquiryDetails(context, enquiry);
                },
                // onTap: () {
                //   if (!enquiry.isRead) {
                //     controller.markAsRead(enquiry.id);
                //   }
                //   showEnquiryDetails(context, enquiry);
                // },
              );
            },
          ),
        );
      }),
    );
  }

  void showEnquiryDetails(BuildContext context, EnquiryModel enquiry) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black // Dark mode color
              : Colors.indigo.shade50, // Light mode color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    enquiry.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enquiry.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        enquiry.mobileNumber,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Message',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              enquiry.message ?? 'No message provided',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class EnquiryCard extends StatelessWidget {
  final EnquiryModel enquiry;
  final String formattedDateTime;
  final VoidCallback onTap;

  const EnquiryCard({
    super.key,
    required this.enquiry,
    required this.formattedDateTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 27, 27, 27) // Dark mode color
          : Colors.indigo.shade50, // Light mode color,,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  enquiry.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          enquiry.name,
                          style: TextStyle(
                            fontWeight: enquiry.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mobile: ${enquiry.mobileNumber}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      enquiry.message != null && enquiry.message!.isNotEmpty
                          ? enquiry.message!
                          : 'No message provided',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDateTime,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        // Text(
                        //   'Business: ${enquiry.business}',
                        //   style: TextStyle(
                        //     color: Colors.grey[500],
                        //     fontSize: 12,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

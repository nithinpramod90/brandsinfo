import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/information/bottom_model.dart';
import 'package:brandsinfo/presentation/screen/information/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key, required this.bid});
  final String bid;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final DetailsController controller = Get.put(DetailsController());

  @override
  void initState() {
    super.initState();

    // Fetch business data when screen loads
    controller.fetchBusinessData(widget.bid);
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        // Ensure the widget is still in the tree
        WelcomeBottomSheet.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
            () => Text(controller.business.value?.name ?? 'Business Details')),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final business = controller.business.value;
        if (business == null) {
          return const Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Center(
                    child: business.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "${ApiConstants.apiurl}${business.image}",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(Icons.business,
                                    size: 80, color: Colors.grey),
                              ),
                            ),
                          )
                        : Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.business,
                                size: 80, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 20,
                      child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            controller.pickImage();
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Business Details sections - reuse your existing code
              _buildSection('Basic Information', [
                _buildEditableField(context, 'Name', business.name, 'name'),
                _buildEditableField(context, 'Description',
                    business.description, 'description'),
                _buildEditableField(context, 'Since', business.since, 'since'),
                _buildEditableField(
                    context, 'Opens', business.opensAt, 'opens_at'),
                _buildEditableField(
                    context, 'Closes', business.closesAt, 'closes_at'),
              ]),

              // Include the rest of your sections here...
              _buildSection('Contact Details', [
                _buildEditableField(context, 'Email', business.email, 'email'),
                _buildEditableField(
                    context, 'Manager', business.managerName, 'managerName'),
                _buildEditableField(context, 'WhatsApp',
                    business.whatsappNumber, 'whatsappNumber'),
                _buildEditableField(context, 'Contact Number',
                    business.inchargeNumber, 'inchargeNumber'),
              ]),
              _buildSection('Address', [
                _buildEditableField(context, 'Building', business.buildingName,
                    'building_name'),
                _buildEditableField(
                    context, 'Locality', business.locality, 'locality'),
                _buildEditableField(context, 'City', business.city, 'city'),
                _buildEditableField(context, 'State', business.state, 'state'),
                _buildEditableField(
                    context, 'Pincode', business.pincode, 'pincode'),
              ]),
              _buildSection('Socials', [
                _buildEditableField(context, 'Instagram',
                    business.instagramLink, 'instagram_link'),
                _buildEditableField(context, 'Facebook', business.facebookLink,
                    'facebook_link'),
                _buildEditableField(
                    context, 'Website', business.webLink, 'web_link'),
                _buildEditableField(context, 'X', business.xLink, 'x_link'),
                _buildEditableField(
                    context, 'Youtube', business.youtubeLink, 'youtube_link'),
              ])
            ],
          ),
        );
      }),
    );
  }

  // Your helper methods remain the same
  Widget _buildSection(String title, List<Widget> children) {
    // Same implementation as your original code
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableField(
      BuildContext context, String label, String value, String? field) {
    return Obx(() {
      final isEditing = controller.currentEditing.value == field;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            if (isEditing)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.editController,
                      readOnly: field == 'opens_at' ||
                          field == 'closes_at' ||
                          field == 'since',
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () {
                        if (field == 'opens_at' || field == 'closes_at') {
                          _selectTime(context, field!);
                        } else if (field == 'since') {
                          _selectDate(context, field!);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => controller.saveField(field!),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: controller.cancelEditing,
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value.isNotEmpty ? value : 'Not provided',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  if (field != null)
                    IconButton(
                      icon: const Icon(Icons.edit,
                          size: 20, color: Colors.orange),
                      onPressed: () => controller.startEditing(field, value),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Future<void> _selectTime(BuildContext context, String field) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      controller.editController.text = formattedTime;
      controller.startEditing(field, formattedTime);
    }
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      controller.editController.text = formattedDate;
      controller.startEditing(field, formattedDate);
    }
  }
}

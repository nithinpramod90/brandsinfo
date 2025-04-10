import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/network/api_service.dart';
import 'package:brandsinfo/presentation/screen/business/information_controller.dart';
import 'package:brandsinfo/presentation/screen/business/widgets/locality_popup.dart';
import 'package:brandsinfo/presentation/screen/business/widgets/pincode_fetch.dart';
import 'package:brandsinfo/widgets/common_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:brandsinfo/presentation/screen/business/widgets/custom_dropdown.dart';
import 'package:brandsinfo/presentation/widgets/custom_textfield.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:get/get.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});
  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  String? selectedBusinessType = "Products & Services";
  String? selectedLocality;
  int? selectedLocalityId; // Change type to int
  int? cityid; // Change type to int
  final InformationController controller = InformationController();
  List<String> localities = [];
  final ApiService _apiService = ApiService();

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      controller.sendinfo(
        businessNameController.text,
        pincodeController.text,
        selectedLocalityId.toString(),
        districtController.text,
        cityid.toString(),
        stateController.text,
        whatsappController.text,
        selectedBusinessType ?? "",
        addresscontroller.text,
      );
      print("Business Name: ${businessNameController.text}");
      print("Business Type: $selectedBusinessType");
      print("Pincode: ${pincodeController.text}");
      print("State: ${stateController.text}");
      print("District: ${districtController.text}");
      print("WhatsApp: ${whatsappController.text}");
      print("City ID: $cityid");
      print("Selected Locality: $selectedLocality");
      print("Selected Locality ID: $selectedLocalityId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonSizedBox.h20,
                      CircularImageWidget(),
                      CommonSizedBox.h25,
                      Text(
                        'Business Information',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      CommonSizedBox.h25,
                      CustomTextField(
                        controller: businessNameController,
                        hintText: "Enter your Business name",
                        validator: (value) =>
                            value!.isEmpty ? 'Business name is required' : null,
                      ),
                      CommonSizedBox.h10,
                      CustomDropdown(
                        items: ["Products & Services", "Product", "Service"],
                        selectedItem: selectedBusinessType,
                        onChanged: (value) {
                          setState(() {
                            selectedBusinessType = value;
                          });
                        },
                      ),
                      CommonSizedBox.h10,
                      CustomTextField(
                        controller: pincodeController,
                        hintText: "Pincode",
                        keyboardType: TextInputType.number,
                        maxlength: 6,
                        validator: (value) =>
                            value!.isEmpty ? 'Pincode is required' : null,
                        onChanged: fetchAndSetCityState,
                      ),
                      CommonSizedBox.h10,
                      CustomTextField(
                        controller: addresscontroller,
                        hintText: "Address Line",
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Address is required' : null,
                      ),
                      CommonSizedBox.h10,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: stateController,
                              hintText: "State",
                              validator: (value) =>
                                  value!.isEmpty ? 'State is required' : null,
                            ),
                          ),
                          CommonSizedBox.w5,
                          Expanded(
                            child: CustomTextField(
                              controller: districtController,
                              hintText: "District",
                              validator: (value) => value!.isEmpty
                                  ? 'District is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      CommonSizedBox.h10, // In your main widget file
                      GestureDetector(
                        onTap: () {
                          selectedLocality == null
                              ? CommonSnackbar.show(
                                  title: "Info",
                                  message: "Please enter pincode",
                                  isError: false)
                              : showDialog(
                                  context: context,
                                  builder: (context) => LocalityPopup(
                                    localities: localities,
                                    selectedLocality: selectedLocality,
                                    onSelected: (selectedLocality) {
                                      setState(() {
                                        this.selectedLocality =
                                            selectedLocality;

                                        // Find corresponding ID from data
                                        final selectedItem =
                                            localityData.firstWhere(
                                          (element) =>
                                              element['locality_name'] ==
                                              selectedLocality,
                                          orElse: () => {'id': null},
                                        );
                                        selectedLocalityId =
                                            selectedItem['id'] as int?;
                                        print(
                                            "Updated Locality ID: $selectedLocalityId");
                                      });
                                    },
                                  ),
                                );
                        },
                        child: Container(
                          width: Get.size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white // Dark mode color
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            selectedLocality ?? 'Select Locality',
                            style: TextStyle(
                              color: selectedLocality == null
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // DropdownButtonFormField<String>(
                      //   value: selectedLocality,
                      //   items: localities.map((String locality) {
                      //     return DropdownMenuItem<String>(
                      //       value: locality,
                      //       child: Text(locality),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedLocality = value;

                      //       // Ensure we find the locality correctly
                      //       final selectedItem = localityData.firstWhere(
                      //         (element) =>
                      //             element['locality_name']
                      //                 .toString()
                      //                 .trim()
                      //                 .toLowerCase() ==
                      //             value!.trim().toLowerCase(),
                      //         orElse: () => {
                      //           'id': null
                      //         }, // Prevents crash if no match is found
                      //       );

                      //       selectedLocalityId = selectedItem['id'] as int?;
                      //       print("Updated Locality ID: $selectedLocalityId");
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       borderSide:
                      //           const BorderSide(color: Color(0xffFF750C)),
                      //     ),
                      //   ),
                      // ),
                      CommonSizedBox.h10,
                      CustomTextField(
                        controller: whatsappController,
                        hintText: "Enter your WhatsApp number",
                        keyboardType: TextInputType.phone,
                        prefixText: "+91 ",
                        maxlength: 10,
                        validator: (value) => value!.isEmpty
                            ? 'WhatsApp number is required'
                            : null,
                      ),
                      CommonSizedBox.h30,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveAndContinue,
                          child: const Text(
                            'Save and Continue',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> localityData = []; // Store fetched locality data

  void fetchLocalities(String city) async {
    try {
      final response = await Dio()
          .get('${ApiConstants.apiurl}/users/getlocality/?city=$city');

      if (response.statusCode == 200) {
        final data = response.data;
        print("API Response: $data"); // Debugging

        setState(() {
          cityid = data['city'];
          localityData = List<Map<String, dynamic>>.from(
              data['data']); // Store full locality data

          localities =
              localityData.map((e) => e['locality_name'].toString()).toList();

          print("Localities Loaded: $localities"); // Debugging

          if (localityData.isNotEmpty) {
            selectedLocality = localityData[0]['locality_name'].toString();
            selectedLocalityId = localityData[0]['id'] as int?;
            print(
                "Default Selected Locality ID: $selectedLocalityId"); // Debugging
          }
        });
      }
    } catch (e) {
      print("Error fetching localities: $e");
    }
  }

  void fetchAndSetCityState(String pincode) async {
    if (pincode.length == 6) {
      final data = await fetchCityState(pincode);
      print(data);
      setState(() {
        stateController.text = data['state'] ?? '';
        districtController.text = data['district'] ?? '';
      });
      fetchLocalities(data['district'] ?? '');
    }
  }
}

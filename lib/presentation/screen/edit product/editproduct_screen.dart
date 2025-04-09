import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brandsinfo/network/api_constants.dart';
import 'package:brandsinfo/presentation/screen/products/productview_controller.dart';

class EditProductScreen extends StatefulWidget {
  final dynamic product;
  final String bid;

  const EditProductScreen({
    Key? key,
    required this.product,
    required this.bid,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  // For storing new images selected from gallery
  List<File> _newImages = [];

  // For storing existing image URLs
  List<dynamic> _existingImages = [];

  bool _isLoading = false;
  bool _isDeletingImage = false;
  bool _isAddingImage = false;

  final ProductViewController _productController =
      Get.find<ProductViewController>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing product data
    _nameController = TextEditingController(text: widget.product['name'] ?? '');
    _priceController =
        TextEditingController(text: widget.product['price']?.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.product['description'] ?? '');

    // Load existing images if available
    if (widget.product['product_images'] != null) {
      _existingImages = List.from(widget.product['product_images']);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _newImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      Get.snackbar('Error', 'Failed to pick images');
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _deleteExistingImage(int imageId, int index) async {
    try {
      setState(() {
        _isDeletingImage = true;
      });

      // Call the API to delete the image
      await _productController.deleteProductImage(imageId);

      // Remove from UI after successful deletion
      setState(() {
        _existingImages.removeAt(index);
      });

      Get.snackbar('Success', 'Image deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete image: $e');
    } finally {
      setState(() {
        _isDeletingImage = false;
      });
    }
  }

  Future<void> _uploadNewImages() async {
    if (_newImages.isEmpty) return;

    try {
      setState(() {
        _isAddingImage = true;
      });

      // Upload new images
      await _productController.addProductImages(
          widget.product['id'], _newImages);

      // Clear new images after successful upload
      setState(() {
        _newImages = [];
      });

      // Refresh product data to get updated images
      await _refreshProductData();

      Get.snackbar('Success', 'Images uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload images: $e');
    } finally {
      setState(() {
        _isAddingImage = false;
      });
    }
  }

  Future<void> _refreshProductData() async {
    try {
      // Refresh the product data to get updated image list
      await _productController.fetchProducts(widget.bid);

      // Find the updated product and refresh the existing images
      final updatedProduct = _productController.products.firstWhere(
        (product) => product['id'] == widget.product['id'],
        orElse: () => widget.product,
      );

      if (updatedProduct['product_images'] != null) {
        setState(() {
          _existingImages = List.from(updatedProduct['product_images']);
        });
      }
    } catch (e) {
      print('Error refreshing product data: $e');
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare product data
      final Map<String, dynamic> productData = {
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
      };

      // Update product basic info
      await _productController.updateProductBasicInfo(
        widget.product['id'],
        productData,
      );

      // Upload any new images if present
      if (_newImages.isNotEmpty) {
        await _uploadNewImages();
      }

      Get.back(); // Return to products screen
      Get.snackbar('Success', 'Product updated successfully');

      // Refresh products list
      _productController.fetchProducts(widget.bid);
    } catch (e) {
      print('Error updating product: $e');
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Images Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Add Images Button
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate, size: 18),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Existing Images
                  if (_existingImages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Images:'),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _existingImages.length,
                            itemBuilder: (context, index) {
                              final image = _existingImages[index];
                              final imageUrl = image['image'];
                              final imageId = image['id'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${ApiConstants.apiurl}$imageUrl"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => _deleteExistingImage(
                                            imageId, index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // New Images
                  if (_newImages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('New Images:'),
                            ElevatedButton(
                              onPressed: _uploadNewImages,
                              child: const Text('Upload All'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _newImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(_newImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => _removeNewImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Product Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Product Price
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (Rs.)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      try {
                        double.parse(value);
                      } catch (e) {
                        return 'Please enter valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Product Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _updateProduct,
                      child: const Text(
                        'Update Product',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlays
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          if (_isDeletingImage)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Deleting image...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

          if (_isAddingImage)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading images...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:brandsinfo/presentation/screen/products/products_screen.dart';
import 'package:brandsinfo/presentation/screen/servicces/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProductsandserviceButton extends StatelessWidget {
  ProductsandserviceButton({
    super.key,
    required this.type,
    required this.bid,
  });

  final String type;
  final String bid;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (type == 'Product' || type == 'Products & Services') {
      buttons.add(
        GlassmorphicContainer(
          title: 'Products',
          icon: Icons.shopping_bag_outlined,
          onTap: () {
            Get.to(() => ProductScreen(
                  bid: bid,
                ));
          },
        ),
      );
    }

    if (type == 'Service' || type == 'Products & Services') {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 20));
      }
      buttons.add(
        GlassmorphicContainer(
          title: 'Services',
          icon: Icons.miscellaneous_services_outlined,
          onTap: () {
            Get.to(() => ServiceScreen(
                  bid: bid,
                ));
          },
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
    );
  }
}

class GlassmorphicContainer extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const GlassmorphicContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<GlassmorphicContainer> createState() => _GlassmorphicContainerState();
}

class _GlassmorphicContainerState extends State<GlassmorphicContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: Container(
          width: Get.width / 2.4,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                // padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: 30,
                      // color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.title,
                      style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

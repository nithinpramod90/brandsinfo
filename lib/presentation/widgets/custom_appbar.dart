import 'package:brandsinfo/presentation/screen/enquiries/enquires_screen.dart';
import 'package:brandsinfo/presentation/screen/notification/notification_screen.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final String name;
  const CustomAppBar(
      {super.key, required this.notificationCount, required this.name});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.blue,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align everything at the bottom
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // To place items on the left and right
              children: [
                Row(
                  children: [
                    CommonSizedBox.w10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        // CommonSizedBox.h5,
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => EnquiriesScreen());
                      },
                      icon: Icon(LucideIcons.messageCircle),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.bell),
                          onPressed: () {
                            Get.to(() => NotificationScreen());
                          },
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              notificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight) * 1.2;
}

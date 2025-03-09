import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffFF750C)),
        ),
      ),
    );
  }
}

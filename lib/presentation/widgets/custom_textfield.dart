import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? prefixText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? height;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.validator,
    this.onChanged,
    this.height,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefix: widget.prefixText != null ? Text(widget.prefixText!) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        contentPadding: widget.height != null
            ? EdgeInsets.symmetric(
                vertical: (widget.height! - 20) / 2, horizontal: 12)
            : const EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 12), // Default padding
      ),
    );
  }
}

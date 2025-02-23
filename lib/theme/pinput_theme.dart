import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInputThemes {
  static PinTheme getDefaultPinTheme(BuildContext context) {
    final theme = Theme.of(context);
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: theme.colorScheme.onSurface, // Dynamic text color
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: theme.colorScheme.onSurface), // Dynamic border color
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static PinTheme getFocusedPinTheme(BuildContext context) {
    final defaultPinTheme = getDefaultPinTheme(context);
    return defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.circular(20),
    );
  }

  static PinTheme getSubmittedPinTheme(BuildContext context) {
    final defaultPinTheme = getDefaultPinTheme(context);
    return defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color:
            Theme.of(context).colorScheme.surface, // Dynamic background color
      ),
    );
  }
}

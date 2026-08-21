import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';

SnackBar buildCharactersErrorSnackBar({
  required BuildContext context,
  required String message,
  required VoidCallback onRetry,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorScheme.errorContainer,
    content: Row(
      children: [
        Iconify(Mdi.alert_circle_outline, color: colorScheme.onErrorContainer),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: colorScheme.onErrorContainer),
          ),
        ),
      ],
    ),
    action: SnackBarAction(
      label: 'Retry',
      textColor: colorScheme.onErrorContainer,
      onPressed: onRetry,
    ),
  );
}

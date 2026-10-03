import 'package:flutter/material.dart';
import '../theme/extensions/build_context_extensions.dart';

/// Współdzielony widok prezentacji błędu z ikoną i komunikatem tekstowym.
class AppErrorView extends StatelessWidget {
  final String errorMessage;

  const AppErrorView({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.spacing.errorBoxPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: context.dimensions.iconHuge,
              color: context.colors.error,
            ),
            SizedBox(height: context.spacing.base),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.typography.bodyLarge.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

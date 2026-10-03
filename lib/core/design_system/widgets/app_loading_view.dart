import 'package:flutter/material.dart';
import '../theme/extensions/build_context_extensions.dart';

/// Współdzielony widok ładowania danych z komunikatem tekstowym.
class AppLoadingView extends StatelessWidget {
  final String message;

  const AppLoadingView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: context.colors.primary,
          ),
          SizedBox(height: context.spacing.base),
          Text(
            message,
            style: context.typography.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

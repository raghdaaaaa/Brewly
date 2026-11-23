import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// A simple centered loading spinner.
/// Used by FutureBuilder while the data is loading.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefinitionSkeleton extends StatelessWidget {
  const DefinitionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    Widget _buildPlaceholder({double? width, required double height}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlaceholder(width: 150, height: 28),
                        const SizedBox(height: 8),
                        _buildPlaceholder(width: 100, height: 18),
                      ],
                    ),
                  ),
                  _buildPlaceholder(width: 30, height: 30),
                ],
              ),
              const SizedBox(height: 24),

              // Meaning 1
              _buildPlaceholder(width: 100, height: 32), // Chip
              const SizedBox(height: 12),
              _buildPlaceholder(height: 20),
              const SizedBox(height: 8),
              _buildPlaceholder(height: 20),
              const SizedBox(height: 12),
              _buildPlaceholder(width: 250, height: 16), // Example

              const Divider(height: 32),

              // Meaning 2
              _buildPlaceholder(width: 120, height: 32), // Chip
              const SizedBox(height: 12),
              _buildPlaceholder(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

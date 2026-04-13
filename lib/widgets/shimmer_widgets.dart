import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for cards
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;

  const ShimmerCard({
    super.key,
    this.height = 100,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A4A) : const Color(0xFFE8E5FF),
      highlightColor:
          isDark ? const Color(0xFF3D3D6B) : const Color(0xFFF3F1FF),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Shimmer loading for a list of items
class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerCard(height: 76),
        ),
      ),
    );
  }
}

/// Shimmer loading for the dashboard
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerCard(height: 160),
          const SizedBox(height: 24),
          const ShimmerCard(height: 24, width: 140),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i < 2 ? 8 : 0,
                    left: i > 0 ? 8 : 0,
                  ),
                  child: const ShimmerCard(height: 90),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ShimmerCard(height: 24, width: 180),
          const SizedBox(height: 12),
          const ShimmerList(itemCount: 4),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable product image widget supporting both local assets and network URLs
/// with smooth loading indicator and graceful error fallback.
class ProductImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (!isNetwork) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _buildFallback(),
      );
    }

    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _buildFallback(),
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: AppColors.lightGrey,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.gold,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: AppColors.mediumGrey,
          size: 32,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class CachedImageView extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImageView({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        height: height,
        width: width,
        fit: fit,
        placeholder: (_, _) => const Center(child: Loader()),
        errorWidget: (_, _, _) => Image.asset(
          'assets/images/no_product.png',
          height: height,
          width: width,
          fit: fit,
        ),
      ),
    );
  }
}

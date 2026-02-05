import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/models/banner/banner_model.dart';
import 'package:samruddha_kirana/providers/orders/banner_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final bannerCount = context.read<BannerProvider>().banners.length;

      if (bannerCount <= 1) return;

      _currentIndex = (_currentIndex + 1) % bannerCount;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = context.watch<BannerProvider>();

    if (bannerProvider.isLoading) {
      return const SizedBox(height: 160, child: Center(child: Loader()));
    }

    if (bannerProvider.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: bannerProvider.banners.length,
            itemBuilder: (context, index) {
              final AppBanner banner = bannerProvider.banners[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: banner.image,
                  fit: BoxFit.cover,

                  placeholder: (context, url) => const SizedBox(
                    height: 32,
                    width: 32,
                    child: Loader(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported_outlined,
                    size: 28,
                    color: Colors.grey.shade400,
                  ),
                  // placeholder: (_, _) =>
                  //     const Center(child: Loader()),
                  // errorWidget: (_, _, _) => const Icon(Icons.broken_image),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // 🔵 DOT INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerProvider.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.darkGreen
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

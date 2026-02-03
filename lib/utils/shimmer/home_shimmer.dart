import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'shimmer_effect.dart';

/// Grey-box helper — used everywhere in this file.
Widget shimmerBox({
  double w = double.infinity,
  double h = 14,
  double r = 6,
  Color c = const Color(0xFFE0E0E0),
}) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(r)),
  );
}

/// Full-screen shimmer that replaces the ENTIRE home screen while loading.
/// Layout mirrors RealHome exactly: top bar + scroll body.
class HomeShimmerScreen extends StatelessWidget {
  const HomeShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ShimmerEffect(
          child: Column(
            children: [
              // ─── TOP BAR ───────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        // avatar circle
                        shimmerBox(
                          w: 44,
                          h: 44,
                          r: 22,
                          c: const Color(0xFFE0E0E0),
                        ),
                        const SizedBox(width: 10),

                        // "DELIVER TO" label + address line
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerBox(w: 70, h: 12, r: 4),
                            const SizedBox(height: 6),
                            shimmerBox(w: 160, h: 16, r: 4),
                          ],
                        ),

                        const Spacer(),

                        // notification circle
                        shimmerBox(
                          w: 40,
                          h: 40,
                          r: 20,
                          c: const Color(0xFFE0E0E0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // search bar pill
                    shimmerBox(h: 48, r: 25),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // ─── SCROLL BODY ───────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Banner
                      shimmerBox(h: 160, r: 20, c: const Color(0xFFDDDDDD)),

                      const SizedBox(height: 24),

                      // "Browse by Category" title
                      shimmerBox(w: 180, h: 22),

                      const SizedBox(height: 16),

                      // Category chips row
                      Row(
                        children: List.generate(
                          5,
                          (i) => Padding(
                            padding: EdgeInsets.only(right: i < 4 ? 14 : 0),
                            child: shimmerBox(w: 100, h: 84, r: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // "Explore Sub-Categories" title
                      shimmerBox(w: 210, h: 22),

                      const SizedBox(height: 16),

                      // Sub-category grid  2 col × 3 row
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 2.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          6,
                          (_) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: shimmerBox(
                              h: double.infinity,
                              r: 16,
                              c: const Color(0xFFE4E4E4),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // "Our Partner Brands" title
                      shimmerBox(w: 190, h: 22),

                      const SizedBox(height: 16),

                      // Brand cards row
                      Row(
                        children: List.generate(
                          4,
                          (i) => Padding(
                            padding: EdgeInsets.only(right: i < 3 ? 15 : 0),
                            child: shimmerBox(w: 110, h: 120, r: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

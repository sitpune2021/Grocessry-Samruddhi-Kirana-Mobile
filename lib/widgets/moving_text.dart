import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:samruddha_kirana/constants/app_colors.dart';

class InfiniteMarqueeText extends StatefulWidget {
  final String text;
  final double speed; // pixels per second

  const InfiniteMarqueeText({
    super.key,
    required this.text,
    this.speed = 60, // adjust speed here
  });

  @override
  State<InfiniteMarqueeText> createState() => _InfiniteMarqueeTextState();
}

class _InfiniteMarqueeTextState extends State<InfiniteMarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // dummy, driven manually
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          /// distance traveled based on time
          final dx =
              -(_controller.lastElapsedDuration?.inMilliseconds ?? 0) /
              1000 *
              widget.speed %
              (screenWidth + 200);

          return Transform.translate(
            offset: Offset(screenWidth - dx, 0),
            child: child,
          );
        },
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.greenAccent[700],
          ),
        ),
      ),
    );
  }
}

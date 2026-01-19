// import 'package:flutter/material.dart';

// class AddQtyButton extends StatefulWidget {
//   final int qty;
//   final int maxQty;
//   final VoidCallback onAdd;
//   final VoidCallback onRemove;

//   const AddQtyButton({
//     super.key,
//     required this.qty,
//     required this.maxQty,
//     required this.onAdd,
//     required this.onRemove,
//   });

//   @override
//   State<AddQtyButton> createState() => _AddQtyButtonState();
// }

// class _AddQtyButtonState extends State<AddQtyButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _bounceController;
//   late Animation<double> _bounceAnimation;

//   static const double _height = 36;
//   static const double _width = 110; // 🔥 FIXED WIDTH (IMPORTANT)

//   @override
//   void initState() {
//     super.initState();

//     _bounceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );

//     _bounceAnimation = Tween<double>(begin: 1, end: 1.2).animate(
//       CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
//     );
//   }

//   @override
//   void dispose() {
//     _bounceController.dispose();
//     super.dispose();
//   }

//   void _onAddTap() {
//     _bounceController.forward().then((_) => _bounceController.reverse());
//     widget.onAdd();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: _width, // ✅ SAME WIDTH ALWAYS
//       height: _height,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: BoxDecoration(
//           color: const Color(0xFFEFFBF5),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 250),
//           switchInCurve: Curves.easeOut,
//           switchOutCurve: Curves.easeIn,
//           transitionBuilder: (child, animation) {
//             return FadeTransition(
//               opacity: animation,
//               child: ScaleTransition(scale: animation, child: child),
//             );
//           },
//           child: widget.qty == 0 ? _addView() : _counterView(),
//         ),
//       ),
//     );
//   }

//   // ---------------- ADD ----------------
//   Widget _addView() {
//     return InkWell(
//       key: const ValueKey('add'),
//       borderRadius: BorderRadius.circular(20),
//       onTap: _onAddTap,
//       child: const Center(
//         child: Text(
//           "ADD",
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
//         ),
//       ),
//     );
//   }

//   // ---------------- COUNTER ----------------
//   Widget _counterView() {
//     final bool isMaxReached = widget.qty >= widget.maxQty;

//     return Row(
//       key: const ValueKey('counter'),
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _iconButton(Icons.remove, widget.onRemove),

//         /// 🔢 SLIDE NUMBER
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 200),
//           transitionBuilder: (child, animation) {
//             return SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0, 0.4),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: FadeTransition(opacity: animation, child: child),
//             );
//           },
//           child: Text(
//             "${widget.qty}",
//             key: ValueKey(widget.qty),
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//         ),

//         /// ➕ BOUNCE
//         ScaleTransition(
//           scale: _bounceAnimation,
//           child: _iconButton(Icons.add, isMaxReached ? null : _onAddTap),
//         ),
//       ],
//     );
//   }

//   Widget _iconButton(IconData icon, VoidCallback? onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: SizedBox(
//         width: 28,
//         height: 28,
//         child: Icon(
//           icon,
//           size: 18,
//           color: onTap == null ? Colors.grey : Colors.green,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class AddQtyButton extends StatefulWidget {
  final int qty;
  final int maxQty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const AddQtyButton({
    super.key,
    required this.qty,
    required this.maxQty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<AddQtyButton> createState() => _AddQtyButtonState();
}

class _AddQtyButtonState extends State<AddQtyButton>
    with SingleTickerProviderStateMixin {
  static const double _width = 110;
  static const double _height = 36;

  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.2,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onAddTap() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEFFBF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: widget.qty == 0 ? _addView() : _counterView(),
        ),
      ),
    );
  }

  Widget _addView() => InkWell(
    key: const ValueKey('add'),
    onTap: _onAddTap,
    child: const Center(
      child: Text(
        "ADD",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
      ),
    ),
  );

  Widget _counterView() {
    final isMaxReached = widget.qty >= widget.maxQty;

    return Row(
      key: const ValueKey('counter'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _icon(Icons.remove, widget.onRemove),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            "${widget.qty}",
            key: ValueKey(widget.qty),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.2).animate(_bounceController),
          child: _icon(Icons.add, isMaxReached ? null : _onAddTap),
        ),
      ],
    );
  }

  Widget _icon(IconData icon, VoidCallback? onTap) => InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 28,
      height: 28,
      child: Icon(
        icon,
        size: 18,
        color: onTap == null ? Colors.grey : Colors.green,
      ),
    ),
  );
}

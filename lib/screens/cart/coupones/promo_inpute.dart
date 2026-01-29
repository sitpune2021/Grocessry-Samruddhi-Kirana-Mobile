import 'package:flutter/material.dart';

class PromoInput extends StatelessWidget {
  final double height;
  final TextEditingController controller;
  final VoidCallback onApply;

  const PromoInput({
    super.key,
    required this.height,
    required this.controller,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              cursorColor: Colors.green,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 6),
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                hintText: "Enter promo code",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onApply,
            child: const Text("APPLY", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

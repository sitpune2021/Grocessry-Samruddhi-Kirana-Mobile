import 'package:flutter/material.dart';

class PromoInput extends StatelessWidget {
  final double height;
  const PromoInput({super.key, required this.height});

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
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.local_offer_outlined),
                hintText: "Enter promo code",
                border: InputBorder.none,
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
            onPressed: () {},
            child: const Text("APPLY", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

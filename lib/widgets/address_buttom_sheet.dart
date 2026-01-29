import 'package:flutter/material.dart';
import 'package:samruddha_kirana/screens/address/address_buttom_sheet_screen.dart';

void showAddressBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const AddressBottomSheet(),
  );
}

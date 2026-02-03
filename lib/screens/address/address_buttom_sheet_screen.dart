import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({super.key});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAllAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      child: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          final addresses = provider.addresses;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Select Delivery Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Choose where you want your order delivered",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Address List (REAL DATA)
              if (provider.isLoading && addresses.isEmpty)
                const Padding(padding: EdgeInsets.all(40), child: Loader())
              else if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text("No address found"),
                )
              else
                ...List.generate(addresses.length, (index) {
                  final item = addresses[index];
                  final isSelected = item.isDefault;

                  return GestureDetector(
                    onTap: provider.isLoading
                        ? null
                        : () async {
                            await context.read<AddressProvider>().switchDefault(
                              item.id,
                            );
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Radio
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),

                          // Address Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.addressLine,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                if (item.landmark.isNotEmpty)
                                  Text(
                                    item.landmark,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () async {
                              final result = await context.push(
                                Routes.addAddress,
                                extra: item,
                              );

                              if (context.mounted && result == true) {
                                context
                                    .read<AddressProvider>()
                                    .fetchAllAddresses();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              // Add New Address
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(Routes.addAddress);
                },
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text(
                  "Add New Address",
                  style: TextStyle(color: Colors.green),
                ),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: Colors.green),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: addresses.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text(
                    "CONFIRM ADDRESS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

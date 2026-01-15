import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/widgets/address_card.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAllAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ================= RESPONSIVE VALUES =================
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const [
        Condition.largerThan(name: TABLET, value: 24),
        Condition.largerThan(name: DESKTOP, value: 60),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 24)],
    ).value;

    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 56,
      conditionalValues: const [Condition.largerThan(name: TABLET, value: 64)],
    ).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Manage Saved Addresses',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'HELP',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Consumer<AddressProvider>(
          builder: (context, provider, _) {
            // if (provider.isLoading) {
            //   return const Center(child: Loader());
            // }

            final List<GetAddress> addresses = provider.addresses;

            return Column(
              children: [
                const SizedBox(height: 16),

                /// ================= ADDRESS LIST =================
                Expanded(
                  child: provider.isLoading && addresses.isEmpty
                      ? const Center(child: Loader())
                      : addresses.isEmpty
                      ? const Center(
                          child: Text(
                            'No address found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: addresses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = addresses[index];
                            final isSelected = selectedIndex == index;

                            return AddressCard(
                              data: item,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },

                              /// ✅ EDIT
                              onEdit: () async {
                                final result = await context.push(
                                  Routes.addAddress,
                                  extra: item, // ✅ PASS ADDRESS
                                );

                                if (context.mounted && result == true) {
                                  context
                                      .read<AddressProvider>()
                                      .fetchAllAddresses();
                                }
                              },

                              onDelete: () {
                                _showDeleteBottomSheet(
                                  context: context,
                                  address: item,
                                );
                              },
                            );
                          },
                        ),
                ),

                /// ================= ADD NEW ADDRESS =================
                _AddNewAddressButton(),

                const SizedBox(height: 16),

                /// ================= BOTTOM BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: addresses.isEmpty
                        ? null
                        : () {
                            final selectedAddress = addresses[selectedIndex];
                            // use selectedAddress where needed
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'DELIVER TO THIS ADDRESS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDeleteBottomSheet({
    required BuildContext context,
    required GetAddress address,
  }) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Consumer<AddressProvider>(
          builder: (context, provider, _) {
            final isLoading = provider.isDeleting;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.delete_outline, color: Colors.red, size: 36),
                  const SizedBox(height: 12),
                  const Text(
                    'Delete Address?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure you want to delete this address?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  /// Buttons / Loader
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.darkGreen),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: AppColors.textOnDark,
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await context
                                      .read<AddressProvider>()
                                      .deleteAddress(address.id);

                                  if (!context.mounted) return;

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Address deleted successfully',
                                      ),
                                    ),
                                  );
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: Loader(),
                                )
                              : const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AddNewAddressButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: TextButton.icon(
        onPressed: () async {
          final result = await context.push(Routes.addAddress);

          if (context.mounted && result == true) {
            context.read<AddressProvider>().fetchAllAddresses();
          }
        },
        icon: const Icon(Icons.add, color: Colors.green),
        label: const Text(
          'ADD NEW ADDRESS',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

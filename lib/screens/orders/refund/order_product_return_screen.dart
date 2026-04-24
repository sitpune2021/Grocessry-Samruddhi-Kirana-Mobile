import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/providers/orders/order_provider.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class RefundRequestScreen extends StatefulWidget {
  final int orderId;
  const RefundRequestScreen({super.key, required this.orderId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

  static const int maxImages = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OrderProvider>();
      provider.getRefundReasons();
      provider.getRefundProducts(widget.orderId);
    });
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Refund Request',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          12,
          horizontalPadding,
          20,
        ),
        child: SizedBox(
          height: buttonHeight,
          child: Consumer<OrderProvider>(
            builder: (context, provider, _) {
              final bool isLoading =
                  provider.refundSubmitStatus == ProviderStatus.loading;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!provider.hasSelectedRefundProducts) {
                          _toast('Please select at least one product');
                          return;
                        }

                        if (provider.selectedRefundReasonId == null) {
                          _toast('Please select refund reason');
                          return;
                        }

                        final response = await provider.submitRefundRequest(
                          orderId: widget.orderId,
                          images: _images,
                        );

                        _toast(response.message);

                        if (!context.mounted) return;
                        if (response.success) {
                          provider.resetRefundState();
                          Navigator.pop(context, true);
                        }
                      },
                child: isLoading
                    ? const Loader()
                    : const Text(
                        'Initiate Refund',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Product Details'),
            const SizedBox(height: 12),
            // _productCard(),
            /// ===== PRODUCT LIST =====
            Consumer<OrderProvider>(
              builder: (context, provider, _) {
                if (provider.isRefundProductLoading) {
                  return const Loader();
                }

                if (provider.refundSelections.isEmpty) {
                  return const Text('No refundable products found');
                }

                return Column(
                  children: List.generate(
                    provider.refundSelections.length,
                    (index) => _refundProductTile(
                      provider,
                      provider.refundSelections[index],
                      index,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            _sectionTitle('Return Reason'),
            const SizedBox(height: 12),
            _selectedReasonCard(),
            const SizedBox(height: 6),
            const Text(
              'DEFAULT REASON FOR DIRECT REFUND',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 28),

            _imagesHeader(),
            const SizedBox(height: 12),
            _imagesRow(),
            const SizedBox(height: 8),
            const Text(
              'Please provide clear photos of the defect and the shipping box. '
              'This helps us process your refund immediately without a return shipment.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _infoCard(),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// ================= IMAGE PICK + COMPRESSION =================

  void _pickImageSource() {
    if (_images.length >= maxImages) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximum 5 photos allowed')));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (picked == null) return;

    final XFile? compressed = await _compressImage(File(picked.path));
    if (compressed != null) {
      setState(() => _images.add(File(compressed.path)));
    }
  }

  Future<XFile?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    return FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 92,
      minWidth: 1080,
      minHeight: 1080,
      format: CompressFormat.jpeg,
    );
  }

  /// ================= IMAGE UI =================

  Widget _imagesRow() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_images.length < maxImages) _addPhotoBox(),
          ...List.generate(_images.length, (index) => _uploadedImageBox(index)),
        ],
      ),
    );
  }

  Widget _addPhotoBox() {
    return InkWell(
      onTap: _pickImageSource,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt_outlined),
            SizedBox(height: 4),
            Text('Add Photo', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _uploadedImageBox(int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_images[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () {
              setState(() => _images.removeAt(index));
            },
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= PRODUCT TILE =================
  Widget _refundProductTile(
    OrderProvider provider,
    RefundSelection item,
    int index,
  ) {
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isSelected
              ? const Color(0xFF18C964)
              : Colors.grey.shade300,
        ),
        color: item.isSelected ? const Color(0xFFE9FBF1) : Colors.white,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => provider.toggleRefundProduct(index),
            child: Icon(
              item.isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: const Color(0xFF18C964),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            child: product.returnImageUrls.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.returnImageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.inventory),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Max Qty: ${product.returnableQty}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (item.isSelected)
            Row(
              children: [
                _qtyBtn(
                  icon: Icons.remove,
                  onTap: () =>
                      provider.updateRefundQuantity(index, item.quantity - 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                _qtyBtn(
                  icon: Icons.add,
                  onTap: () =>
                      provider.updateRefundQuantity(index, item.quantity + 1),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  /// ======= REFUND REASON CARD (DROPDOWN) =======
  Widget _selectedReasonCard() {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final selected = provider.selectedRefundReason;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openRefundReasonSheet(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE9FBF1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF18C964), width: 1.5),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF18C964),
                  child: Icon(Icons.warning, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selected?.label ?? 'Select return reason',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF18C964),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF18C964)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ======= FIXED HEIGHT BOTTOM SHEET WITH TOP-CENTER CLOSE =======
  void _openRefundReasonSheet(BuildContext context) {
    const double sheetHeight = 480;
    const double iconSize = 44;
    const double gap = 12;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return Consumer<OrderProvider>(
          builder: (context, provider, _) {
            return Stack(
              clipBehavior: Clip.none, // ⭐ IMPORTANT
              alignment: Alignment.bottomCenter,
              children: [
                /// ===== BOTTOM SHEET =====
                Container(
                  height: sheetHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        height: 4,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Select Return Reason',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),

                      /// ===== LIST =====
                      Expanded(
                        child:
                            provider.refundReasonStatus ==
                                ProviderStatus.loading
                            ? const Center(child: Loader())
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                itemCount: provider.refundReasons.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final reason = provider.refundReasons[index];
                                  final isSelected =
                                      provider.selectedRefundReason?.id ==
                                      reason.id;

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () {
                                      provider.setSelectedRefundReason(reason);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF18C964)
                                              : Colors.grey.shade300,
                                        ),
                                        color: isSelected
                                            ? const Color(0xFFE9FBF1)
                                            : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reason.label,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? const Color(0xFF18C964)
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF18C964),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                /// ===== CLOSE ICON (TOP CENTER) =====
                Positioned(
                  top: -(iconSize + gap),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: iconSize,
                      width: iconSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, size: 22),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _imagesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Images of Damage',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          'Max 5 photos',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This is a Premium Direct Refund. Once approved, the funds will be '
              'returned to your original payment method. No replacement will be shipped.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

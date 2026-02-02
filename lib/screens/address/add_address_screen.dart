import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/constants/app_colors.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/address/location_provider.dart';
import 'package:samruddha_kirana/widgets/animation_location.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

enum AddressType { home, work, other }

class AddAddressScreen extends StatefulWidget {
  final GetAddress? address;
  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  /// ================= FORM & STATE =================
  final _formKey = GlobalKey<FormState>();

  bool isDefaultAddress = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final addresses = context.read<AddressProvider>().addresses;
    if (widget.address == null) {
      // ADD MODE
      isDefaultAddress = addresses.isEmpty;
      // true only if first address
    } else {
      // EDIT MODE
      isDefaultAddress = widget.address!.isDefault;
    }

    if (widget.address != null) {
      // ✏️ EDIT ADDRESS
      nameController.text = widget.address!.name;
      phoneController.text = widget.address!.mobile;
      pincodeController.text = widget.address!.pincode;
      cityController.text = widget.address!.city;
      areaController.text = widget.address!.landmark;
      stateController.text = widget.address!.state;
      houseController.text = widget.address!.addressLine;

      // ✅ EDIT FALLBACK FOR LOCATION
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressProvider>().setTypeFromBackend(
          widget.address!.type,
        );

        final lp = context.read<LocationProvider>();
        lp.latitude = widget.address!.latitude;
        lp.longitude = widget.address!.longitude;
      });
    } else {
      // ➕ ADD ADDRESS → AUTO FETCH LOCATION
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LocationProvider>().fetchCurrentLocation();
        context.read<AddressProvider>().resetType();
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pincodeController.dispose();
    houseController.dispose();
    areaController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final locationProvider = context.watch<LocationProvider>(); // ✅ ADD THIS

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(),
        title: Text(
          widget.address == null ? 'Add Address' : 'Edit Address',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        _sectionTitle('CONTACT INFORMATION'),
                        _inputField(
                          controller: nameController,
                          hint: 'Full Name',
                          icon: Icons.person_outline,
                          validator: _requiredValidator,
                        ),
                        _inputField(
                          controller: phoneController,
                          hint: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: _phoneValidator,
                        ),

                        const SizedBox(height: 24),
                        _sectionTitle('ADDRESS DETAILS'),
                        _inputField(
                          controller: pincodeController,
                          hint: 'Pincode / ZIP',
                          icon: Icons.location_on_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _pincodeValidator,
                          // onChanged: _sanitizePincode,
                        ),
                        _inputField(
                          controller: houseController,
                          hint: 'Flat / House No. / Floor',
                          icon: Icons.tag,
                          validator: _requiredValidator,
                        ),
                        _inputField(
                          controller: areaController,
                          hint: 'Building Name / Area / Street',
                          icon: Icons.apartment_outlined,
                          validator: _requiredValidator,
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                controller: cityController,
                                hint: 'City',
                                icon: Icons.location_city_outlined,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z ]'),
                                  ),
                                ],
                                validator: _alphaValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _inputField(
                                controller: stateController,
                                hint: 'State',
                                icon: Icons.map_outlined,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z ]'),
                                  ),
                                ],
                                validator: _alphaValidator,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // location
                        GestureDetector(
                          onTap: locationProvider.isLoading
                              ? null
                              : () async {
                                  await context
                                      .read<LocationProvider>()
                                      .fetchCurrentLocation();
                                  if (!context.mounted) return;
                                  final lp = context.read<LocationProvider>();
                                  debugPrint('Saved Lat: ${lp.latitude}');
                                  debugPrint('Saved Lng: ${lp.longitude}');

                                  setState(() {
                                    cityController.text = lp.city;
                                    stateController.text = lp.state;
                                    pincodeController.text = lp.pincode;
                                    areaController.text = lp.area;
                                  });
                                },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),

                                child: Row(
                                  children: [
                                    locationProvider.isLoading
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: Loader(),
                                          )
                                        : const AnimatedLocationIcon(),

                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Use my current location',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // ✅ RIGHT SIDE TICK
                                    if (locationProvider.hasLocation &&
                                        !locationProvider.isLoading)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                              // ✅ GREEN HINT TEXT
                              if (locationProvider.locationMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 4,
                                  ),
                                  child: Text(
                                    locationProvider.locationMessage,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        _sectionTitle('SAVE ADDRESS AS'),

                        /// ================= ADDRESS TYPE =================
                        ///
                        Row(
                          children: [
                            _AddressTypeChip(
                              label: 'Home',
                              icon: Icons.home,
                              isSelected:
                                  addressProvider.selectedType ==
                                  AddressType.home,
                              onTap: addressProvider.hasType(1)
                                  ? null // 🚫 disable if already exists
                                  : () => addressProvider.setAddressType(
                                      AddressType.home,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            _AddressTypeChip(
                              label: 'Work',
                              icon: Icons.work,
                              isSelected:
                                  addressProvider.selectedType ==
                                  AddressType.work,
                              onTap: addressProvider.hasType(2)
                                  ? null
                                  : () => addressProvider.setAddressType(
                                      AddressType.work,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            _AddressTypeChip(
                              label: 'Other',
                              icon: Icons.more_horiz,
                              isSelected:
                                  addressProvider.selectedType ==
                                  AddressType.other,
                              onTap:
                                  addressProvider.hasType(3) ||
                                      addressProvider.hasType(4) ||
                                      addressProvider.hasType(5)
                                  ? null
                                  : () => addressProvider.setAddressType(
                                      AddressType.other,
                                    ),
                            ),
                          ],
                        ),

                        /// ================= DEFAULT TOGGLE =================
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            final addresses = addressProvider.addresses;
                            final bool isEditing = widget.address != null;

                            // CASE 1: First address ever
                            if (addresses.isEmpty && !isEditing) {
                              isDefaultAddress = true;
                            }

                            // CASE 2: Only one address & editing
                            final bool isLocked =
                                addresses.length == 1 && isEditing;

                            return GestureDetector(
                              onTap: () {
                                if (!isLocked) {
                                  setState(() {
                                    isDefaultAddress = !isDefaultAddress;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6FFF8),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isDefaultAddress
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isDefaultAddress
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'Set as default address',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: isDefaultAddress,
                                      activeThumbColor: Colors.green,
                                      onChanged: isLocked
                                          ? null // 🔒 locked
                                          : (v) {
                                              setState(() {
                                                isDefaultAddress = v;
                                              });
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),

              /// ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: addressProvider.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final lp = context.read<LocationProvider>();

                          // 🚨 REQUIRED LOCATION CHECK
                          if (lp.latitude == null || lp.longitude == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please use current location'),
                              ),
                            );
                            return;
                          }

                          // ================= ADD =================
                          if (widget.address == null) {
                            final response = await context
                                .read<AddressProvider>()
                                .addAddress(
                                  name: nameController.text,
                                  mobile: phoneController.text,
                                  addressLine: houseController.text,
                                  landmark: areaController.text,
                                  city: cityController.text,
                                  state: stateController.text,
                                  pincode: pincodeController.text,
                                  latitude: lp.latitude!.toString(),
                                  longitude: lp.longitude!.toString(),
                                  type: addressProvider.selectedType,
                                  isDefault: isDefaultAddress,
                                );

                            if (response.success && context.mounted) {
                              context.pop(true);
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.message)),
                              );
                            }
                          }
                          // ================= EDIT =================
                          else {
                            final response = await context
                                .read<AddressProvider>()
                                .updateAddress(
                                  id: widget.address!.id,
                                  name: nameController.text,
                                  mobile: phoneController.text,
                                  addressLine: houseController.text,
                                  landmark: areaController.text,
                                  city: cityController.text,
                                  state: stateController.text,
                                  pincode: pincodeController.text,
                                  latitude: lp.latitude!,
                                  longitude: lp.longitude!,
                                  type: addressProvider.selectedType,
                                  isDefault: isDefaultAddress,
                                );

                            if (response.success && context.mounted) {
                              context.pop(true);
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.message)),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: addressProvider.isLoading
                      ? const Loader()
                      : Text(
                          widget.address == null
                              ? 'Save Address'
                              : 'Update Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appBarText,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HELPERS =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: AppColors.appBarBackground,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: const Color(0xFFF6FFF8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? v) =>
      v == null || v.trim().isEmpty ? 'This field is required' : null;

  String? _phoneValidator(String? v) =>
      v != null && v.length == 10 ? null : 'Enter valid phone number';

  String? _pincodeValidator(String? v) =>
      v != null && v.length == 6 ? null : 'Enter 6 digit pincode';

  String? _alphaValidator(String? v) => v == null || v.trim().isEmpty
      ? 'This field is required'
      : RegExp(r'^[a-zA-Z ]+$').hasMatch(v)
      ? null
      : 'Only alphabets allowed';
}

/// ================= ADDRESS TYPE CHIP =================
class _AddressTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _AddressTypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: disabled ? 0.4 : 1,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

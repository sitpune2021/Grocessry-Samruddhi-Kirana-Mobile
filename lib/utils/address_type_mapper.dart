import 'package:samruddha_kirana/screens/address/add_address_screen.dart';

int addressTypeToInt(AddressType type) {
  switch (type) {
    case AddressType.home:
      return 1;
    case AddressType.work:
      return 2;
    case AddressType.other:
      return 3; // backend can also store 4 or 5
  }
}

AddressType intToAddressType(int type) {
  switch (type) {
    case 1:
      return AddressType.home;
    case 2:
      return AddressType.work;
    case 3:
    case 4:
    case 5:
    default:
      return AddressType.other;
  }
}

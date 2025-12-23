enum DeviceType { phone, tablet, desktop }

class Breakpoints {
  // Default width breakpoints (logical pixels)
  static const double phoneMax = 599; // <= 599 → phone
  static const double tabletMax = 1023; // 600–1023 → tablet
  // >= 1024 → desktop
}

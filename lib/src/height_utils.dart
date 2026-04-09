class HeightUtils {
  static double inchesToCm(int inches) => inches * 2.54;

  static Map<String, int> toFeetInches(int inches) {
    return {
      "feet": inches ~/ 12,
      "inch": inches % 12,
    };
  }
}
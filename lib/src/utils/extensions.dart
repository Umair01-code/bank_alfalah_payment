/// Extension methods used throughout the package
extension StringExtensions on String {
  /// Checks if this string contains another string, ignoring case
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}

class BankAlfalahConfig {
  /// Merchant ID provided by Bank Alfalah
  final String merchantId;

  /// Merchant password provided by Bank Alfalah
  final String merchantPassword;

  /// Merchant username provided by Bank Alfalah
  final String merchantUsername;

  /// Merchant hash key provided by Bank Alfalah
  final String merchantHash;

  /// Store ID provided by Bank Alfalah
  final String storeId;

  /// Channel ID provided by Bank Alfalah (default: '1001')
  final String channelId;

  /// Return URL to which the payment gateway will redirect after payment
  final String returnUrl;

  /// First key for hash generation
  final String firstKey;

  /// Second key for hash generation
  final String secondKey;

  /// Flag to enable debug mode
  final bool debugMode;

  BankAlfalahConfig({
    required this.merchantId,
    required this.merchantPassword,
    required this.merchantUsername,
    required this.merchantHash,
    required this.storeId,
    required this.returnUrl,
    required this.firstKey,
    required this.secondKey,
    this.channelId = '1001',
    this.debugMode = false,
  });
}

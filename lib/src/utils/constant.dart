class BankAlfalahConstants {
  // API endpoints
  static const String paymentBaseUrl = 'https://payments.bankalfalah.com';
  static const String paymentEndpoint = '/HS/HS/HS';

  // Response codes
  static const String successCode = 'RC-00';
  static const String failureCode = 'RC-01';

  // Parameter keys
  static const String channelIdKey = 'HS_ChannelId';
  static const String isRedirectionRequestKey = 'HS_IsRedirectionRequest';
  static const String merchantHashKey = 'HS_MerchantHash';
  static const String merchantIdKey = 'HS_MerchantId';
  static const String merchantPasswordKey = 'HS_MerchantPassword';
  static const String merchantUsernameKey = 'HS_MerchantUsername';
  static const String returnUrlKey = 'HS_ReturnURL';
  static const String storeIdKey = 'HS_StoreId';
  static const String transactionReferenceNumberKey =
      'HS_TransactionReferenceNumber';
  static const String requestHashKey = 'HS_RequestHash';
  static const String requestVerificationTokenKey = 'RequestVerificationToken';

  // Parameters for second request
  static const String authTokenKey = 'AuthToken';
  static const String currencyKey = 'Currency';
  static const String isBinKey = 'IsBIN';
  static const String transactionTypeIdKey = 'TransactionTypeId';
  static const String transactionAmountKey = 'TransactionAmount';

  // Default values
  static const String defaultCurrency = 'PKR';
  static const String defaultIsBin = '0';
  static const String defaultIsRedirectionRequest = '0';
  static const String defaultTransactionTypeId = '';

  // Not instantiable
  BankAlfalahConstants._();
}

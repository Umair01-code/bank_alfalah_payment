import 'package:flutter_test/flutter_test.dart';
import 'package:bank_alfalah_payment/src/models/payment_config.dart';
import 'package:bank_alfalah_payment/src/models/payment_request.dart';
import 'package:bank_alfalah_payment/src/services/hash_service.dart';

void main() {
  group('BankAlfalahConfig', () {
    test('should create a valid config object', () {
      final config = BankAlfalahConfig(
        merchantId: 'test_merchant_id',
        merchantPassword: 'test_password',
        merchantUsername: 'test_username',
        merchantHash: 'test_hash',
        storeId: 'test_store_id',
        returnUrl: 'https://example.com/return',
        firstKey: 'test_first_key',
        secondKey: 'test_second_key',
      );

      expect(config.merchantId, 'test_merchant_id');
      expect(config.merchantPassword, 'test_password');
      expect(config.merchantUsername, 'test_username');
      expect(config.merchantHash, 'test_hash');
      expect(config.storeId, 'test_store_id');
      expect(config.returnUrl, 'https://example.com/return');
      expect(config.firstKey, 'test_first_key');
      expect(config.secondKey, 'test_second_key');
      expect(config.channelId, '1001'); // Default value
      expect(config.debugMode, false); // Default value
    });
  });

  group('PaymentRequest', () {
    test('should convert to map correctly', () {
      final request = PaymentRequest(
        amount: '1000.00',
        orderId: 'ORDER-123',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '03001234567',
        additionalData: {'custom_field': 'custom_value'},
      );

      final map = request.toMap();

      expect(map['amount'], '1000.00');
      expect(map['orderId'], 'ORDER-123');
      expect(map['customerName'], 'John Doe');
      expect(map['customerEmail'], 'john@example.com');
      expect(map['customerPhone'], '03001234567');
      expect(map['custom_field'], 'custom_value');
    });
  });

  group('HashService', () {
    test('should generate hash correctly', () {
      final hashService = HashService(
        firstKey: 'test_first_key',
        secondKey: 'test_second_key',
      );

      final data = {
        'key1': 'value1',
        'key2': 'value2',
      };

      final hash = hashService.generateHash(data);

      // The hash will depend on the encryption implementation
      // This just verifies that a non-empty string is returned
      expect(hash, isNotEmpty);
      expect(hash, isA<String>());
    });
  });
}

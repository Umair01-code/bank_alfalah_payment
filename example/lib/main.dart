import 'package:flutter/material.dart';
import 'package:bank_alfalah_payment/bank_alfalah_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Alfalah Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  String _paymentResult = '';

  // Create payment service instance
  late final BankAlfalahPaymentService _paymentService;

  @override
  void initState() {
    super.initState();

    // Initialize payment service with configuration
    _paymentService = BankAlfalahPaymentService(
      config: BankAlfalahConfig(
        merchantId: 'YOUR_MERCHANT_ID',
        merchantPassword: 'YOUR_MERCHANT_PASSWORD',
        merchantUsername: 'YOUR_MERCHANT_USERNAME',
        merchantHash: 'YOUR_MERCHANT_HASH',
        storeId: 'YOUR_STORE_ID',
        returnUrl: 'YOUR_RETURN_URL',
        firstKey: 'YOUR_FIRST_KEY',
        secondKey: 'YOUR_SECOND_KEY',
        debugMode: true,
      ),
    );
  }

  Future<void> _initiatePayment() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _paymentResult = 'Please enter an amount';
      });
      return;
    }

    final amount = _amountController.text;

    // Create payment request
    final request = PaymentRequest(
      amount: amount,
      orderId: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
    );

    // Initiate payment
    final result = await _paymentService.initiatePayment(
      request: request,
      context: context,
    );

    // Handle result
    setState(() {
      if (result.isSuccess) {
        _paymentResult = 'Payment Successful!';
      } else {
        _paymentResult =
            'Payment Failed: ${result.errorMessage ?? result.response?.message ?? 'Unknown error'}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Alfalah Payment Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount in PKR',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initiatePayment,
              child: const Text('Pay Now'),
            ),
            const SizedBox(height: 20),
            if (_paymentResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                color: _paymentResult.contains('Successful')
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Text(_paymentResult),
              ),
          ],
        ),
      ),
    );
  }
}

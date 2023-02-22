
import 'package:flutter/material.dart';

import 'helper_functions.dart';
void showMultipleTextFieldInputDialog({
  required BuildContext context,
  required String title,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(List) onSubmit,
}) {
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final minimumBidPriceController = TextEditingController();
  final productPhotoController = TextEditingController();
  final auctionEndDateController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Product Name',
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: productDescriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Product Description',
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: minimumBidPriceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Product Minimum Bid Price',
                    ),
                  ),
                  const SizedBox(height: 5,),
                ],
              ),
            )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(negativeButton),
          ),
          TextButton(
            onPressed: () {
              if (productNameController.text.isEmpty) return;
              if (productDescriptionController.text.isEmpty) return;
              if (minimumBidPriceController.text.isEmpty) return;
              final name = productNameController.text;
              final description = productDescriptionController.text;
              final bidPrice = double.parse(minimumBidPriceController.text);
              final List value = [];
              value.add(name);
              value.add(description);
              value.add(bidPrice);
              Navigator.pop(context);
              onSubmit(value);
            },
            child: Text(positiveButton),
          ),
        ],
      ));
}

void showSingleTextFieldInputDialog({
  required BuildContext context,
  required String title,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final textController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: title,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(negativeButton),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isEmpty) return;
              final value = textController.text;
              Navigator.pop(context);
              onSubmit(value);
            },
            child: Text(positiveButton),
          ),
        ],
      ));
}

showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String positiveButtonText = 'OK',
  required VoidCallback onPressed,
}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                onPressed();
              },
              child: Text(positiveButtonText)),
        ],
      ));
}

String get generateOrderId => 'PB_${getFormattedDate(DateTime.now(),pattern: 'yyyyMMdd_HH:MM:ss')}';

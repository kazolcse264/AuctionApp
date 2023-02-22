import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../models/date_model.dart';
import '../models/product_models.dart';
import '../providers/product_provider.dart';
import '../utils/helper_functions.dart';

class CreateAuctionPage extends StatefulWidget {
  static const String routeName = '/create_auction_page';

  const CreateAuctionPage({Key? key}) : super(key: key);

  @override
  State<CreateAuctionPage> createState() => _CreateAuctionPageState();
}

class _CreateAuctionPageState extends State<CreateAuctionPage> {
  final _formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final auctionPriceController = TextEditingController();
  DateTime? auctionExpiredDate;
  final ImageSource _imageSource = ImageSource.gallery;
  String? thumbnail;
  late ProductProvider productProvider;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Auction Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 8.0),
                          child: TextFormField(
                            controller: productNameController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.description),
                                hintText: 'Enter Product Name',
                                labelText: 'Enter Product Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 8.0),
                          child: TextFormField(
                            controller: productDescriptionController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.description),
                                hintText: 'Enter Product Description',
                                labelText: 'Enter Product Description',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 8.0),
                          child: TextFormField(
                            controller: auctionPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.currency_rupee),
                                hintText: 'Enter Product Auction Price',
                                labelText: 'Enter Product Auction Price',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            color: Colors.tealAccent.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    onPressed: _selectDate,
                                    icon: const Icon(Icons.calendar_month),
                                    label: const Text(
                                        'Select auction Expired Date'),
                                  ),
                                  Text(auctionExpiredDate == null
                                      ? 'No date chosen'
                                      : getFormattedDate(
                                          auctionExpiredDate!,
                                        ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36.0,
                            vertical: 8.0,
                          ),
                          child: InkWell(
                            onTap: _getImage,
                            child: Card(
                              color: Colors.tealAccent.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 18,
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Center(
                                        child: Text('Upload product photo')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Picked Image Show Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 4.0,
                          ),
                          child: Card(
                            color: Colors.white.withOpacity(0.90),
                            child: (thumbnail == null)
                                ? Image.asset('images/online_auction.gif')
                                : Image.file(
                                    File(thumbnail!),
                                    height: 200,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36.0, vertical: 8.0),
                          child: FloatingActionButton.extended(
                            label: const Text(
                              'Submit Auction',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            // <-- Text
                            backgroundColor: Colors.tealAccent.shade100,
                            icon: const Icon(
                              // <-- Icon
                              Icons.upload,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _saveAuctionProduct();
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selectedDate != null) {
      setState(() {
        auctionExpiredDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final file =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 70);
    if (file != null) {
      setState(() {
        thumbnail = file.path;
      });
    }
  }

  void _saveAuctionProduct() async {
    if (thumbnail == null) {
      showMsg(context, 'Please Select an Image');
      return;
    }
    if (auctionExpiredDate == null) {
      showMsg(context, 'Please Select a auction expired date');
      return;
    }

    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      try {
        final imageModel = await productProvider.uploadImage(thumbnail!);
        final productModel = ProductModel(
          userId: AuthService.currentUser!.uid,
          productName: productNameController.text,
          description: productDescriptionController.text,
          auctionPrice: num.parse(auctionPriceController.text),
          thumbnailImageModel: imageModel,
          auctionExpiredDateModel: DateModel(
            timestamp: Timestamp.fromDate(auctionExpiredDate!),
            day: auctionExpiredDate!.day,
            month: auctionExpiredDate!.month,
            year: auctionExpiredDate!.year,
          ),
        );
        await productProvider.addAuction(productModel);
        EasyLoading.dismiss();
        if (mounted) showMsg(context, 'Auction Product Saved Successfully');
        resetFields();
        if (mounted) Navigator.pop(context);
      } catch (error) {
        EasyLoading.dismiss();
        if (mounted) showMsg(context, 'Something wrong');
        showMsg(context, error.toString());
      }
    }
  }

  void resetFields() {
    setState(() {
      productNameController.clear();
      productDescriptionController.clear();
      auctionPriceController.clear();
      auctionExpiredDate = null;
      thumbnail = null;
    });
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ADDPRoduct extends StatefulWidget {
  final String storeId;

  const ADDPRoduct({Key? key, required this.storeId}) : super(key: key);

  @override
  State<ADDPRoduct> createState() => _ADDPRoductState();
}

class _ADDPRoductState extends State<ADDPRoduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  File? storeImage;
  var items = ["kg", "gram"];
  var product = ["Fruit", "vegetable", "grocery"];
  String dropdownProduct = 'Fruit';
  String dropdownValue = 'kg';

  Future<void> addProductToFirebase() async {
    try {
      String? imageURL = await uploadImageToStorage();

      if (imageURL != null) {
        CollectionReference productsCollection =
            FirebaseFirestore.instance.collection('add_product');

        DocumentReference productRef = await productsCollection.add({
          'name': nameController.text,
          'category': dropdownProduct,
          'description': descriptionController.text,
          'weight': dropdownValue,
          'price': double.parse(priceController.text),
          'stock': double.parse(stockController.text),
          'storeId': widget.storeId,
          'imageUrl': imageURL,
        });

        await productRef.update({'productId': productRef.id});

        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        stockController.clear();
        setState(() {
          dropdownProduct = 'Fruit';
          dropdownValue = 'kg';
          storeImage = null;
        });

        Fluttertoast.showToast(
          msg: "Product added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.pop(context, widget.storeId);
      }
    } catch (e) {
      print('Error adding product to Firestore: $e');

      Fluttertoast.showToast(
        msg: "Error adding product. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<String?> uploadImageToStorage() async {
    try {
      if (storeImage != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(storeImage!);
        await uploadTask.whenComplete(() => null);
        return await storageReference.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image to storage: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 760.h,
            width: 330.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffD5F1E9),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Container(
                      width: 280.w,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: storeImage != null
                          ? Image.file(storeImage!)
                          : InkWell(
                              onTap: () async {
                                final img = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  storeImage = File(img!.path);
                                });
                              },
                              child: Icon(Icons.add_photo_alternate_outlined),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 20.h),
                    child: Row(
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.w,
                          height: 50.h,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "  Enter name",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20.sp),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 20.h),
                    child: Row(
                      children: [
                        Text(
                          "Product Category",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Row(
                      children: [
                        DropdownButton(
                          value: dropdownProduct,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: product.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownProduct = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 20.h),
                    child: Row(
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.w,
                          height: 100.h,
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "  Enter Description",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20.sp),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 20.h),
                    child: Row(
                      children: [
                        Text(
                          "Product Weight",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            DropdownButton(
                              value: dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Price"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 50.h,
                                  child: TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          double.tryParse(value) == null) {
                                        return 'Please enter a valid price';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "  Enter Price",
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    style: TextStyle(
                                      color: priceController.text.isEmpty ||
                                              double.tryParse(
                                                      priceController.text) ==
                                                  null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: priceController.text.isEmpty ||
                                              double.tryParse(
                                                      priceController.text) ==
                                                  null
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20.sp),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.w,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Stock",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220.w,
                          height: 50.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: stockController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        double.tryParse(value) == null) {
                                      return 'Please enter a valid stock';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "  Enter Stock",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                    color: stockController.text.isEmpty ||
                                            double.tryParse(
                                                    stockController.text) ==
                                                null
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                " Kg",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: stockController.text.isEmpty ||
                                      double.tryParse(stockController.text) ==
                                          null
                                  ? Colors.grey
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20.sp),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.w,
                          height: 50.h,
                          child: TextButton(
                            onPressed: () {
                              addProductToFirebase();
                            },
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            color: Color(0xff4D6877),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

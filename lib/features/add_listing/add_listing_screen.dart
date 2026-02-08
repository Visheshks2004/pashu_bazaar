import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pashu_bazaar/features/location/location_picker_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class AddListingScreen extends StatefulWidget {
  final DocumentSnapshot? existingDoc;

  const AddListingScreen({super.key, this.existingDoc});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  File? selectedImage;
  String? imageUrl;

  double? latitude;
  double? longitude;
  String? selectedAddress;

  String? pincode;
  String? area;

  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final ageController = TextEditingController();
  final milkController = TextEditingController();
  final lactationController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  @override
  void initState() {
    super.initState();

    if (widget.existingDoc != null) {
      final data = widget.existingDoc!.data() as Map<String, dynamic>;

      titleController.text = data["title"] ?? "";
      priceController.text = data["price"].toString();
      ageController.text = data["age"].toString();
      milkController.text = data["milk"].toString();
      lactationController.text = data["lactation"] ?? "";
      quantityController.text = data["quantity"].toString();
      descriptionController.text = data["description"] ?? "";

      imageUrl = data["image"];
      latitude = data["lat"];
      longitude = data["lng"];
      selectedAddress = data["address"];
      pincode = data["pincode"];
      area = data["area"];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    ageController.dispose();
    milkController.dispose();
    lactationController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingDoc != null;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? t.editListing : t.addListing,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: selectedImage == null && imageUrl == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(t.addPhoto),
                          ],
                        ),
                      )
                    : null,
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 20),

            buildField("Title", titleController),
            buildField("Price", priceController,
                keyboard: TextInputType.number),
            buildField("Age (Years)", ageController,
                keyboard: TextInputType.number),
            buildField("Milk / Day (Litre)", milkController,
                keyboard: TextInputType.number),
            buildField("Lactation", lactationController),
            buildField("Quantity", quantityController,
                keyboard: TextInputType.number),

            const SizedBox(height: 10),

            const Text("Description"),
            const SizedBox(height: 6),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: t.enterFullDetails,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              icon: const Icon(Icons.location_on),
              label: Text(
                selectedAddress == null
                    ? t.pickLocation
                    : "📍 $selectedAddress",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationPickerScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    latitude = result.lat;
                    longitude = result.lng;
                    selectedAddress = result.address;
                    pincode = result.pincode;
                    area = result.area;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: uploading ? null : submitListing,
                child: uploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? t.updateListing : t.addListing),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitListing() async {
    final t = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (latitude == null ||
        longitude == null ||
        selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pickLocationError)),
      );
      return;
    }

    if (selectedImage == null && imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.selectImage)),
      );
      return;
    }

    try {
      setState(() => uploading = true);

      final user = FirebaseAuth.instance.currentUser!;

      String finalImageUrl = imageUrl ?? "";

      if (selectedImage != null) {
        final fileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        final ref = FirebaseStorage.instance
            .ref()
            .child("listings")
            .child("$fileName.jpg");

        await ref.putFile(selectedImage!);
        finalImageUrl = await ref.getDownloadURL();
      }

      final dataMap = {
        "title": titleController.text.trim(),
        "price": int.parse(priceController.text.trim()),
        "age": int.parse(ageController.text.trim()),
        "milk": int.parse(milkController.text.trim()),
        "lactation": lactationController.text.trim(),
        "quantity": int.parse(quantityController.text.trim()),
        "description": descriptionController.text.trim(),
        "image": finalImageUrl,
        "sellerId": user.uid,
        "phone": user.phoneNumber,
        "lat": latitude,
        "lng": longitude,
        "address": selectedAddress,
        "pincode": pincode,
        "area": area,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      if (widget.existingDoc == null) {
        await FirebaseFirestore.instance
            .collection("listings")
            .add({
          ...dataMap,
          "createdAt": FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("listings")
            .doc(widget.existingDoc!.id)
            .update(dataMap);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.genericError(e.toString()),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() => uploading = false);
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }
}

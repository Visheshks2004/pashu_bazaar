import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:pashu_bazaar/features/location/location_picker_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class AddListingScreen extends StatefulWidget {
  final DocumentSnapshot? existingDoc;

  const AddListingScreen({super.key, this.existingDoc});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  // Multiple images and videos
  List<File> selectedImages = [];
  List<File> selectedVideos = [];
  List<String> existingImageUrls = [];
  List<String> existingVideoUrls = [];

  // For video preview
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final bool _isVideoInitialized = false;

  double? latitude;
  double? longitude;
  String? selectedAddress;
  String? pincode;
  String? area;
  String? _selectedCategory;

  final ImagePicker _picker = ImagePicker();
  bool uploading = false;
  double uploadProgress = 0;
  int totalFiles = 0;

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final ageController = TextEditingController();
  final milkController = TextEditingController();
  final lactationController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

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
      
      _selectedCategory = data["category"];

      // Load existing images
      if (data["images"] != null && data["images"] is List) {
        existingImageUrls = List<String>.from(data["images"]);
      } else if (data["image"] != null) {
        // For backward compatibility
        existingImageUrls = [data["image"]];
      }

      // Load existing videos
      if (data["videos"] != null && data["videos"] is List) {
        existingVideoUrls = List<String>.from(data["videos"]);
      }

      latitude = data["lat"];
      longitude = data["lng"];
      selectedAddress = data["address"];
      pincode = data["pincode"];
      area = data["area"];
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    titleController.dispose();
    priceController.dispose();
    ageController.dispose();
    milkController.dispose();
    lactationController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String _getCategoryDisplay(String? category, AppLocalizations l10n) {
    if (category == null) return '';
    
    switch (category) {
      case 'cow': return l10n.cow;
      case 'buffalo': return l10n.buffalo;
      case 'bull': return l10n.bull;
      case 'ox': return l10n.ox;
      case 'dog': return l10n.dog;
      case 'sheep': return l10n.sheep;
      case 'goat': return l10n.goat;
      case 'horse': return l10n.horse;
      case 'donkey': return l10n.donkey;
      case 'camel': return l10n.camel;
      case 'pig': return l10n.pig;
      case 'rabbit': return l10n.rabbit;
      case 'chicken': return l10n.chicken;
      case 'duck': return l10n.duck;
      case 'other': return l10n.others;
      default: return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingDoc != null;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? l10n.editListing : l10n.addListing,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Upload Progress Indicator
            if (uploading) _buildUploadProgress(),

            // Media Selection Section
            _buildMediaSection(l10n),

            const SizedBox(height: 20),

            // Form Fields
            _buildField(l10n.titleField, titleController),
            _buildField(l10n.priceField, priceController,
                keyboard: TextInputType.number),
            _buildField(l10n.ageYearsField, ageController,
                keyboard: TextInputType.number),
            _buildField(l10n.milkPerDayField, milkController,
                keyboard: TextInputType.number),
            _buildField(l10n.lactationField, lactationController),
            _buildField(l10n.quantityField, quantityController,
                keyboard: TextInputType.number),

            const SizedBox(height: 10),

            // Category Selection
            Text(
              l10n.category,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              hint: Text(l10n.selectCategory),
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: [
                DropdownMenuItem(value: 'cow', child: Text(l10n.cow)),
                DropdownMenuItem(value: 'buffalo', child: Text(l10n.buffalo)),
                DropdownMenuItem(value: 'bull', child: Text(l10n.bull)),
                DropdownMenuItem(value: 'ox', child: Text(l10n.ox)),
                DropdownMenuItem(value: 'dog', child: Text(l10n.dog)),
                DropdownMenuItem(value: 'sheep', child: Text(l10n.sheep)),
                DropdownMenuItem(value: 'goat', child: Text(l10n.goat)),
                DropdownMenuItem(value: 'horse', child: Text(l10n.horse)),
                DropdownMenuItem(value: 'donkey', child: Text(l10n.donkey)),
                DropdownMenuItem(value: 'camel', child: Text(l10n.camel)),
                DropdownMenuItem(value: 'pig', child: Text(l10n.pig)),
                DropdownMenuItem(value: 'rabbit', child: Text(l10n.rabbit)),
                DropdownMenuItem(value: 'chicken', child: Text(l10n.chicken)),
                DropdownMenuItem(value: 'duck', child: Text(l10n.duck)),
                DropdownMenuItem(value: 'other', child: Text(l10n.others)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.categoryError;
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            // Description Field
            Text(
              l10n.descriptionField,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.enterFullDetails,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Location Picker
            OutlinedButton.icon(
              icon: const Icon(Icons.location_on),
              label: Text(
                selectedAddress == null
                    ? l10n.pickLocation
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

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: uploading ? null : () => _submitListing(isEdit, l10n),
                child: uploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Uploading ${uploadProgress.toInt()}%'),
                        ],
                      )
                    : Text(isEdit ? l10n.updateListing : l10n.addListing),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_upload, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Uploading ${selectedImages.length + selectedVideos.length} files...',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: uploadProgress / 100,
            backgroundColor: Colors.blue.shade100,
            color: Colors.blue,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(AppLocalizations l10n) {
    final totalImages = selectedImages.length + existingImageUrls.length;
    final totalVideos = selectedVideos.length + existingVideoUrls.length;
    final canAddMoreImages = totalImages < 5;
    final canAddMoreVideos = totalVideos < 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photos ($totalImages/5)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (canAddMoreImages || canAddMoreVideos)
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Media'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: _showMediaPicker,
              ),
          ],
        ),

        const SizedBox(height: 10),

        // Existing Images
        if (existingImageUrls.isNotEmpty)
          _buildMediaGrid(
            items: existingImageUrls,
            isVideo: false,
            onRemove: (index) {
              setState(() {
                existingImageUrls.removeAt(index);
              });
            },
          ),

        // Selected Images
        if (selectedImages.isNotEmpty)
          _buildMediaGrid(
            items: selectedImages,
            isVideo: false,
            onRemove: (index) {
              setState(() {
                selectedImages.removeAt(index);
              });
            },
          ),

        const SizedBox(height: 16),

        // Video Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Videos ($totalVideos/1)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Existing Videos
        if (existingVideoUrls.isNotEmpty)
          _buildMediaGrid(
            items: existingVideoUrls,
            isVideo: true,
            onRemove: (index) {
              setState(() {
                existingVideoUrls.removeAt(index);
              });
            },
          ),

        // Selected Videos
        if (selectedVideos.isNotEmpty)
          _buildVideoPreviewGrid(),

        // Placeholder when no media
        if (totalImages == 0 && totalVideos == 0)
          GestureDetector(
            onTap: _showMediaPicker,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 2,),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to add photos/video',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Max 5 photos + 1 video',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Info Text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You can add up to 5 photos and 1 video. First photo will be the cover image.',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaGrid({
    required List<dynamic> items,
    required bool isVideo,
    required Function(int) onRemove,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isVideo
                    ? _buildVideoThumbnail(items[index] is String 
                        ? items[index] as String 
                        : items[index].path)
                    : (items[index] is String
                        ? Image.network(
                            items[index] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          )
                        : Image.file(
                            items[index] as File,
                            fit: BoxFit.cover,
                          )),
              ),
            ),
            if (index == 0)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'COVER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (isVideo)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.videocam, size: 10, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'VIDEO',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildVideoThumbnail(String videoPath) {
    return FutureBuilder<Uint8List?>(
      future: _getVideoThumbnail(videoPath),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.videocam, color: Colors.grey),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _getVideoThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );
      return thumbnail;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  Widget _buildVideoPreviewGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: selectedVideos.length,
      itemBuilder: (context, index) {
        final videoFile = selectedVideos[index];
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: FutureBuilder<Uint8List?>(
                future: _getVideoThumbnail(videoFile.path),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedVideos.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 4,
              right: 4,
              child: Icon(Icons.videocam, color: Colors.white, size: 16),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMediaPicker() async {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Media',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Pick Multiple Photos'),
                subtitle: const Text('Select up to 5 images'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: Colors.blue),
                title: const Text('Pick Video'),
                subtitle: const Text('Select 1 video (max 50MB, 2 minutes)'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        final currentImageCount = selectedImages.length + existingImageUrls.length;
        final availableSlots = 5 - currentImageCount;
        
        if (availableSlots <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 5 photos allowed'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        final imagesToAdd = images.length > availableSlots 
            ? images.sublist(0, availableSlots)
            : images;
        
        for (var image in imagesToAdd) {
          final file = File(image.path);
          // Check file size (max 5MB per image)
          final size = await file.length();
          if (size > 5 * 1024 * 1024) {
            if (!mounted) continue;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image ${path.basename(image.path)} exceeds 5MB limit'),
                backgroundColor: Colors.orange,
              ),
            );
            continue;
          }
          
          setState(() {
            selectedImages.add(file);
          });
        }
        
        if (images.length > availableSlots && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added $availableSlots photos (max 5 total)'),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    try {
      // Check if video slot is available
      if (selectedVideos.length + existingVideoUrls.length >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 1 video allowed'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2),
      );
      
      if (video != null) {
        final file = File(video.path);
        // Check file size (max 50MB for video)
        final size = await file.length();
        if (size > 50 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video exceeds 50MB limit'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        
        setState(() {
          selectedVideos.add(file);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      // Check if image slot is available
      if (selectedImages.length + existingImageUrls.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 5 photos allowed'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        final file = File(image.path);
        // Check file size (max 5MB per image)
        final size = await file.length();
        if (size > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image exceeds 5MB limit'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        
        setState(() {
          selectedImages.add(file);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildField(
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

  Future<void> _submitListing(bool isEdit, AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    if (latitude == null || longitude == null || selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pickLocationError)),
      );
      return;
    }

    if (selectedImages.isEmpty && existingImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryError)),
      );
      return;
    }

    try {
      setState(() {
        uploading = true;
        uploadProgress = 0;
        totalFiles = selectedImages.length + selectedVideos.length;
      });

      final user = FirebaseAuth.instance.currentUser!;

      // Upload new images
      final List<String> finalImageUrls = List.from(existingImageUrls);
      if (selectedImages.isNotEmpty) {
        for (int i = 0; i < selectedImages.length; i++) {
          final imageUrl = await _uploadFile(
            selectedImages[i], 
            'images', 
            i,
            (progress) {
              setState(() {
                uploadProgress = ((i / totalFiles * 100) + (progress / totalFiles)).round() as double;
              });
            },
          );
          finalImageUrls.add(imageUrl);
        }
      }

      // Upload new videos
      final List<String> finalVideoUrls = List.from(existingVideoUrls);
      if (selectedVideos.isNotEmpty) {
        for (int i = 0; i < selectedVideos.length; i++) {
          final videoUrl = await _uploadFile(
            selectedVideos[i], 
            'videos', 
            i,
            (progress) {
              setState(() {
                uploadProgress = ((selectedImages.length + i) / totalFiles * 100).round() as double;
              });
            },
          );
          finalVideoUrls.add(videoUrl);
        }
      }

      // Prepare data for Firestore
      final dataMap = {
        "title": titleController.text.trim(),
        "price": int.parse(priceController.text.trim()),
        "age": int.parse(ageController.text.trim()),
        "milk": int.parse(milkController.text.trim()),
        "lactation": lactationController.text.trim(),
        "quantity": int.parse(quantityController.text.trim()),
        "description": descriptionController.text.trim(),
        "category": _selectedCategory,
        "categoryDisplay": _getCategoryDisplay(_selectedCategory, l10n),
        "images": finalImageUrls,
        "videos": finalVideoUrls,
        "image": finalImageUrls.isNotEmpty ? finalImageUrls[0] : "", // First image as thumbnail
        "imageCount": finalImageUrls.length,
        "videoCount": finalVideoUrls.length,
        "hasVideo": finalVideoUrls.isNotEmpty,
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Listing updated successfully!' : 'Listing added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.genericError(e.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        uploading = false;
        uploadProgress = 0;
      });
    }
  }

  Future<String> _uploadFile(
    File file, 
    String folder, 
    int index,
    Function(double) onProgress,
  ) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$index.${file.path.split('.').last}';
      final ref = FirebaseStorage.instance
          .ref()
          .child("listings")
          .child(folder)
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: folder == 'videos' ? 'video/mp4' : 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = ref.putFile(file, metadata);
      
      // Listen to upload progress
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
        onProgress(progress * 100);
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload $folder: $e');
    }
  }
}
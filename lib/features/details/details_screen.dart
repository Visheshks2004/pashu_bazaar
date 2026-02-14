import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> animal;

  const DetailsScreen({super.key, required this.animal});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videos = widget.animal["videos"] as List<dynamic>?;
    if (videos != null && videos.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videos[0]));
      _videoController!.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoController!.value.aspectRatio,
          autoInitialize: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                'Error loading video',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        );
        setState(() {
          _isVideoInitialized = true;
        });
      }).catchError((error) {
        print('Error initializing video: $error');
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  List<String> _getAllImages() {
    final images = widget.animal["images"] as List<dynamic>?;
    if (images != null && images.isNotEmpty) {
      return List<String>.from(images);
    }
    final singleImage = widget.animal["image"] as String?;
    if (singleImage != null && singleImage.isNotEmpty) {
      return [singleImage];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final images = _getAllImages();
    final videos = widget.animal["videos"] as List<dynamic>? ?? [];
    final hasVideo = videos.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal["title"] ?? "Details"),
      ),
      body: Column(
        children: [
          // Media Gallery
          if (images.isNotEmpty || hasVideo)
            _buildMediaGallery(images, hasVideo, l10n),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.animal["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${widget.animal["price"] ?? 0}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(height: 24),

                  // Category
                  if (widget.animal["categoryDisplay"] != null)
                    _buildInfoRow(
                      Icons.category,
                      l10n.category,
                      widget.animal["categoryDisplay"],
                    ),

                  // Milk
                  _buildInfoRow(
                    Icons.water_drop,
                    l10n.milk,
                    "${widget.animal["milk"] ?? 0} ${l10n.literPerDay}",
                  ),

                  // Age
                  _buildInfoRow(
                    Icons.cake,
                    l10n.age,
                    "${widget.animal["age"] ?? 0} years",
                  ),

                  // Lactation
                  if (widget.animal["lactation"] != null)
                    _buildInfoRow(
                      Icons.agriculture,
                      l10n.lactation,
                      widget.animal["lactation"],
                    ),

                  // Quantity
                  _buildInfoRow(
                    Icons.numbers,
                    l10n.quantity,
                    "${widget.animal["quantity"] ?? 1}",
                  ),

                  const Divider(height: 24),

                  // Description
                  Text(
                    l10n.description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.animal["description"] ?? l10n.noDescription,
                    style: const TextStyle(fontSize: 14),
                  ),

                  const Divider(height: 24),

                  // Location
                  Text(
                    l10n.location,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.animal["address"] ?? l10n.noAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action Buttons
          _buildActionButtons(context, l10n),
        ],
      ),
    );
  }

  Widget _buildMediaGallery(List<String> images, bool hasVideo, AppLocalizations l10n) {
    return Container(
      height: 300,
      color: Colors.black,
      child: Stack(
        children: [
          // Images PageView
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                  ),
                ),
              );
            },
          ),

          // Video overlay if available
          if (hasVideo && _isVideoInitialized && _chewieController != null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
                    onPressed: () {
                      _showVideoDialog(context, l10n);
                    },
                  ),
                ),
              ),
            ),

          // Image counter
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${images.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showVideoDialog(BuildContext context, AppLocalizations l10n) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('Video Preview', style: const TextStyle(color: Colors.white)),
          ),
          body: Center(
            child: _isVideoInitialized && _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.map),
              label: Text(l10n.openInGoogleMaps),
              onPressed: () async {
                final lat = widget.animal["lat"];
                final lng = widget.animal["lng"];
                if (lat != null && lng != null) {
                  final url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: Text(l10n.call),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final phone = widget.animal["phone"];
                if (phone != null) {
                  launchUrl(Uri.parse("tel:$phone"));
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: Text(l10n.whatsapp),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final phone = widget.animal["phone"];
                final msg = "Hi, I'm interested in your ${widget.animal["title"]}";
                if (phone != null) {
                  final url = "https://wa.me/$phone?text=${Uri.encodeComponent(msg)}";
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
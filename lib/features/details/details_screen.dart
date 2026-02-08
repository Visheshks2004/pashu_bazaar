import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> animal;

  const DetailsScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal["title"] ?? "Details"),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Open in map
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.map),
                label: Text(l10n.openInGoogleMaps),
                onPressed: () async {
                  final lat = animal["lat"];
                  final lng = animal["lng"];

                  final url =
                      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

                  final uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // Call
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final phone = animal["phone"];
                      if (phone != null) {
                        launchUrl(Uri.parse("tel:$phone"));
                      }
                    },
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: Text(
                      l10n.call,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // WhatsApp
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final phone = animal["phone"];
                      final msg =
                          "Hi, I'm interested in your ${animal["title"]}";
                      final url =
                          "https://wa.me/$phone?text=${Uri.encodeComponent(msg)}";

                      launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: Text(
                      l10n.whatsapp,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: ListView(
        children: [
          Image.network(
            animal["image"] ?? "https://via.placeholder.com/300",
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ).animate().fadeIn().slideY(begin: -0.1, end: 0),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "₹${animal["price"] ?? 0}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 12),

                const Divider(),

                Text("${l10n.milk}: ${animal["milk"] ?? 0} ${l10n.literPerDay}"),
                Text("${l10n.age}: ${animal["age"] ?? "-"}"),
                Text("${l10n.lactation}: ${animal["lactation"] ?? "-"}"),
                Text("${l10n.quantity}: ${animal["quantity"] ?? 1}"),

                const Divider(),

                Text(
                  l10n.location,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  animal["address"] ?? "-",
                  style: const TextStyle(color: Colors.black87),
                ),

                const Divider(),

                Text(
                  l10n.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(animal["description"] ?? "-"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

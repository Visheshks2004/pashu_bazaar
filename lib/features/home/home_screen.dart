import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pashu_bazaar/app_start_screen.dart';
import 'package:pashu_bazaar/features/add_listing/add_listing_screen.dart';
import 'package:pashu_bazaar/features/details/details_screen.dart';
import 'package:pashu_bazaar/features/profile/profile_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";
  int? maxPrice;
  int? minMilk;

  List<QueryDocumentSnapshot> filteredByPincode = [];

  Future<void> searchByPincode(String pincode) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("listings")
        .where("pincode", isEqualTo: pincode)
        .get();

    setState(() {
      filteredByPincode = snapshot.docs;
    });
  }

  void openFilterSheet() {
    final priceController = TextEditingController();
    final milkController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.applyFilters,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.maxPrice),
            ),
            TextField(
              controller: milkController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.minMilk),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  maxPrice = priceController.text.isNotEmpty
                      ? int.parse(priceController.text)
                      : null;
                  minMilk = milkController.text.isNotEmpty
                      ? int.parse(milkController.text)
                      : null;
                });
                Navigator.pop(context);
              },
              child: Text(l10n.apply),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pashuBazaar),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AppStartScreen()),
                (_) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddListingScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) async {
                searchText = value.toLowerCase();

                if (RegExp(r'^\d{6}$').hasMatch(value)) {
                  await searchByPincode(value);
                } else {
                  setState(() {
                    filteredByPincode = [];
                  });
                }
              },
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(l10n.filter),
                  onPressed: openFilterSheet,
                ),
                const SizedBox(width: 10),
                if (maxPrice != null || minMilk != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        maxPrice = null;
                        minMilk = null;
                      });
                    },
                    child: Text(l10n.clearFilters),
                  )
              ],
            ),
          ),

          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                CategoryItem(title: l10n.cow, icon: Icons.pets),
                CategoryItem(title: l10n.buffalo, icon: Icons.agriculture),
                CategoryItem(title: l10n.bull, icon: Icons.pets),
                CategoryItem(title: l10n.ox, icon: Icons.agriculture),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("listings")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allDocs = filteredByPincode.isNotEmpty
                    ? filteredByPincode
                    : snapshot.data!.docs;

                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title =
                      (data["title"] ?? "").toString().toLowerCase();
                  final price = data["price"] ?? 0;
                  final milk = data["milk"] ?? 0;

                  if (searchText.isNotEmpty &&
                      !title.contains(searchText)) {
                    return false;
                  }
                  if (maxPrice != null && price > maxPrice!) return false;
                  if (minMilk != null && milk < minMilk!) return false;

                  return true;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(child: Text(l10n.noResults));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final imageUrl = data["image"] ??
                        "https://via.placeholder.com/300";

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(animal: data),
                          ),
                        );
                      },
                      child: buildListingCard(
                        context: context,
                        title: data["title"] ?? "",
                        image: imageUrl,
                        price: data["price"] ?? 0,
                        milk: data["milk"] ?? 0,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (100 * index).ms)
                        .slideY(begin: 0.2, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildListingCard({
  required BuildContext context,
  required String title,
  required String image,
  required int price,
  required int milk,
}) {
  final l10n = AppLocalizations.of(context)!;

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("🥛 ${l10n.milk}: $milk ${l10n.literPerDay}"),
              const SizedBox(height: 6),
              Text(
                "₹$price",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }
}

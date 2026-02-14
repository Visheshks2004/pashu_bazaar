import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pashu_bazaar/features/add_listing/add_listing_screen.dart';
import 'package:pashu_bazaar/features/details/details_screen.dart';
import 'package:pashu_bazaar/features/profile/profile_screen.dart';
import 'package:pashu_bazaar/features/language/language_screen.dart';
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
  String? selectedCategory; // 'all', 'cow', 'buffalo', 'ox', 'bull', 'others'

  List<QueryDocumentSnapshot> filteredByPincode = [];

  // ✅ Categories with ALL option first
  final List<Map<String, dynamic>> categories = [
    {'key': 'all', 'icon': Icons.grid_view, 'color': Colors.blue, 'label': 'All'},
    {'key': 'cow', 'icon': Icons.pets, 'color': Colors.brown, 'label': 'Cow'},
    {'key': 'buffalo', 'icon': Icons.agriculture, 'color': Colors.grey, 'label': 'Buffalo'},
    {'key': 'ox', 'icon': Icons.pets, 'color': Colors.orange, 'label': 'Ox'},
    {'key': 'bull', 'icon': Icons.pets, 'color': Colors.red, 'label': 'Bull'},
    {'key': 'others', 'icon': Icons.category, 'color': Colors.purple, 'label': 'Others'},
  ];

  // List of other animals (for 'others' category)
  final List<String> otherAnimals = [
    'dog', 'sheep', 'goat', 'horse', 'donkey', 
    'camel', 'pig', 'rabbit', 'chicken', 'duck'
  ];

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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.applyFilters,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.maxPrice,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: milkController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.minMilk,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.water_drop),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        maxPrice = null;
                        minMilk = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(l10n.clearFilters),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(l10n.apply),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Get display name for category
  String _getCategoryDisplay(String categoryKey, AppLocalizations l10n) {
    switch (categoryKey) {
      case 'all': return l10n.allAnimals;
      case 'cow': return l10n.cow;
      case 'buffalo': return l10n.buffalo;
      case 'ox': return l10n.ox;
      case 'bull': return l10n.bull;
      case 'others': return l10n.others;
      default: return categoryKey;
    }
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
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.logout),
                  content: Text(l10n.logoutConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        l10n.logout,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen()),
                    (_) => false,
                  );
                }
              }
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) async {
                setState(() {
                  searchText = value.toLowerCase();
                });

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchText = "";
                            filteredByPincode = [];
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(l10n.filter),
                  onPressed: openFilterSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                if (maxPrice != null || minMilk != null || (selectedCategory != null && selectedCategory != 'all'))
                  TextButton(
                    onPressed: () {
                      setState(() {
                        maxPrice = null;
                        minMilk = null;
                        selectedCategory = 'all'; // Reset to All
                      });
                    },
                    child: Text(
                      l10n.clearFilters,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ✅ CATEGORIES: All, Cow, Buffalo, Ox, Bull, Others
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                final isSelected = selectedCategory == category['key'] || 
                                   (selectedCategory == null && category['key'] == 'all');
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategory == category['key']) {
                          // If already selected, keep it selected
                          // Don't deselect - just stay on same category
                        } else {
                          selectedCategory = category['key']; // Select new category
                        }
                      });
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.green 
                            : category['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? Colors.green 
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'],
                            color: isSelected ? Colors.white : category['color'],
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getCategoryDisplay(category['key'], l10n),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Active Filter Indicator
          if (selectedCategory != null && selectedCategory != 'all')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_alt, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Showing: ${_getCategoryDisplay(selectedCategory!, l10n)}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          // Listings
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("listings")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 10),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allDocs = filteredByPincode.isNotEmpty
                    ? filteredByPincode
                    : snapshot.data!.docs;

                // Apply filters
                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data["title"] ?? "").toString().toLowerCase();
                  final price = data["price"] ?? 0;
                  final milk = data["milk"] ?? 0;

                  // Search filter
                  if (searchText.isNotEmpty && !title.contains(searchText.toLowerCase())) {
                    return false;
                  }
                  
                  // Price filter
                  if (maxPrice != null && price > maxPrice!) return false;
                  
                  // Milk filter
                  if (minMilk != null && milk < minMilk!) return false;
                  
                  // ✅ CATEGORY FILTER
                  if (selectedCategory != null && selectedCategory != 'all') {
                    switch (selectedCategory) {
                      case 'cow':
                        return title.contains('cow') || 
                               title.contains('गाय') || 
                               title.contains('cows');
                      case 'buffalo':
                        return title.contains('buffalo') || 
                               title.contains('भैंस') || 
                               title.contains('म्हैस') ||
                               title.contains('buffaloes');
                      case 'ox':
                        return title.contains('ox') || 
                               title.contains('बैल') ||
                               title.contains('oxen');
                      case 'bull':
                        return title.contains('bull') || 
                               title.contains('सांड') ||
                               title.contains('bulls');
                      case 'others':
                        // Check if it's NOT one of the main categories
                        return !title.contains('cow') && 
                               !title.contains('गाय') &&
                               !title.contains('buffalo') && 
                               !title.contains('भैंस') &&
                               !title.contains('म्हैस') &&
                               !title.contains('ox') && 
                               !title.contains('बैल') &&
                               !title.contains('bull') && 
                               !title.contains('सांड');
                      default:
                        return true;
                    }
                  }

                  return true; // 'all' category shows everything
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          l10n.noResults,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (selectedCategory != null && selectedCategory != 'all')
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = 'all';
                              });
                            },
                            child: Text(l10n.clearFilters),
                          ),
                      ],
                    ),
                  );
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
                      child: _buildListingCard(
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

  Widget _buildListingCard({
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
              errorBuilder: (c, e, s) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text("${l10n.milk}: $milk ${l10n.literPerDay}"),
                  ],
                ),
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
}
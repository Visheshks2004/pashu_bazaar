import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pashu_bazaar/features/add_listing/add_listing_screen.dart';
import 'package:pashu_bazaar/features/favourites/favourites_screen.dart';
import 'package:pashu_bazaar/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myProfile),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // User Profile Picture
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          
          // ✅ LOCALIZED: Phone number or "No phone"
          Text(
            user.phoneNumber ?? l10n.noPhone,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          // ❤️ FAVORITES BUTTON - LOCALIZED
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(l10n.myFavorites),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),

          const Divider(),

          // My Listings Header - LOCALIZED
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              l10n.myListings,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // User's Listings
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("listings")
                  .where("sellerId", isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // ✅ LOCALIZED: No listings yet
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.list_alt,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noListingsYet,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddListingScreen(),
                              ),
                            );
                          },
                          child: Text(l10n.addNewListing),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data["image"] ?? "",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          data["title"] ?? "No Title",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text("₹${data["price"] ?? 0}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ✏️ EDIT BUTTON - LOCALIZED tooltip
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: l10n.edit,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddListingScreen(
                                      existingDoc: docs[index],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // 🗑 DELETE BUTTON - LOCALIZED tooltip
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: l10n.delete,
                              onPressed: () async {
                                // ✅ LOCALIZED: Delete confirmation dialog
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(l10n.deleteListing),
                                    content: Text(l10n.deleteConfirmation),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(l10n.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(
                                          l10n.confirmDelete,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection("listings")
                                      .doc(docs[index].id)
                                      .delete();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
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
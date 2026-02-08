import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pashu_bazaar/features/add_listing/add_listing_screen.dart';
import 'package:pashu_bazaar/features/favourites/favourites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    print("🔥 PROFILE UID = ${user.uid}");

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Column(
        children: [
          const SizedBox(height: 16),

          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 8),
          Text(user.phoneNumber ?? "No phone"),

          const SizedBox(height: 16),
          const Divider(),

          // ❤️ FAVORITES BUTTON
ListTile(
  leading: const Icon(Icons.favorite, color: Colors.red),
  title: const Text("My Favorites"),
  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  },
),

const Divider(),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "My Listings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("listings")
                  .where("sellerId", isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("You have no listings yet"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return Card(
  child: ListTile(
    leading: Image.network(
      data["image"],
      width: 60,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => const Icon(Icons.image),
    ),
    title: Text(data["title"]),
    subtitle: Text("₹${data["price"]}"),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✏️ EDIT
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddListingScreen(existingDoc: docs[index]),
              ),
            );
          },
        ),

        // 🗑 DELETE
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("listings")
                .doc(docs[index].id)
                .delete();
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

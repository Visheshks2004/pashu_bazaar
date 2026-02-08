import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../details/details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites ❤️")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("favorites")
            .snapshots(),
        builder: (context, favSnapshot) {
          if (favSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!favSnapshot.hasData || favSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          final favDocs = favSnapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favDocs.length,
            itemBuilder: (context, index) {
              final favId = favDocs[index].id;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("listings")
                    .doc(favId)
                    .snapshots(),
                builder: (context, listingSnap) {
                  if (!listingSnap.hasData || !listingSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final data =
                      listingSnap.data!.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Image.network(
                        data["image"],
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(data["title"]),
                      subtitle: Text("₹${data["price"]}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(animal: data),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn();
                },
              );
            },
          );
        },
      ),
    );
  }
}

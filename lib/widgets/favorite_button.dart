import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final String listingId;

  const FavoriteButton({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final favRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(listingId);

    return StreamBuilder<DocumentSnapshot>(
      stream: favRef.snapshots(),
      builder: (context, snapshot) {
        final isFav = snapshot.data?.exists ?? false;

        return CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              if (isFav) {
                await favRef.delete(); // remove
              } else {
                await favRef.set({"createdAt": FieldValue.serverTimestamp()});
              }
            },
          ),
        );
      },
    );
  }
}

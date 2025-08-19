import 'dart:io';
import 'package:booking_restaurant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user; 
  final _nameController = TextEditingController();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Not signed in");

    final docRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final snap = await docRef.get();

    if (!snap.exists) {
      final data = {
        "name": user.displayName ?? "No Name",
        "email": user.email,
        "profileImage": user.photoURL,
      };
      await docRef.set(data);
      return data;
    }

    return snap.data() as Map<String, dynamic>;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? imageUrl;

      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("profileImages")
            .child("${user.uid}.jpg");
        await ref.putFile(_pickedImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
            "name": _nameController.text.trim(),
            if (imageUrl != null) "profileImage": imageUrl,
          });

      await user.updateDisplayName(_nameController.text.trim());
      if (imageUrl != null) await user.updatePhotoURL(imageUrl);
      await user.reload();

      setState(() {
        _user = FirebaseAuth.instance.currentUser;
        _pickedImage = null;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final data = snapshot.data!;
        if (_nameController.text.isEmpty) {
          _nameController.text = (data["name"] ?? "").toString();
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              "Profile",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : (data["profileImage"] != null &&
                                    (data["profileImage"] as String).isNotEmpty)
                              ? NetworkImage(data["profileImage"])
                              : const NetworkImage(
                                      "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg",
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (data["name"] ?? "No Name").toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                (data["email"] ?? "No Email").toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: Colors.green),
                    title: const Text("Edit Profile"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text("Edit Profile"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : (data["profileImage"] != null &&
                                                (data["profileImage"] as String)
                                                    .isNotEmpty)
                                          ? NetworkImage(data["profileImage"])
                                          : const NetworkImage(
                                                  "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg",
                                                )
                                                as ImageProvider,
                                    ),
                                    const Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: _updateProfile,
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.language, color: Colors.green),
                        title: Text("Language"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.feedback, color: Colors.green),
                        title: Text("Feedback"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.green),
                        title: Text("Rate Us"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.update, color: Colors.green),
                        title: Text("New Version"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _logout,
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/feature/home/presentation/pages/home.dart';
import 'package:leafcare/feature/ml/data/datasources/history_service.dart';
import 'package:leafcare/feature/ml/presentation/pages/treat_page.dart';

class CureHome extends StatefulWidget {
  const CureHome({super.key});

  @override
  State<CureHome> createState() => _CureHomeState();
}

class _CureHomeState extends State<CureHome> {
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';
    final dateTime = timestamp.toDate();
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} '
        '${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plant Health Diary'),
          centerTitle: true,
          elevation: 3,
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.menu_book), text: "Diary"),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Diary Tab
            _buildDiaryTab(),

            // History Tab
            user == null ? _buildLoginPrompt() : _buildHistoryTab(user),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFeatureCard(
            context,
            title: "🌱 Growth Comparison (Time-lapse AI)",
            description:
                "Track your plant's growth over time by uploading images weekly or monthly. "
                "Each image is linked to a plant profile with a timestamp. The app will soon offer a visual timeline "
                "like a slider, showcasing growth progress.\n\n"
                "You'll also be able to compare growth rates and monitor overall plant health trends using AI.\n\n"
                "📌 *This feature is under development.*",
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            context,
            title: "🧠 Smart Care Recommendations",
            description:
                "This upcoming feature will provide personalized care tips for your plants based on previous diseases, "
                "leaf symptoms, seasonal changes, and environmental conditions.\n\n"
                "Examples:\n"
                "- \"Rainy week ahead & fungal history detected: Avoid overwatering.\"\n"
                "- \"Yellowing leaves: Possible nutrient deficiency. Suggest compost use.\"\n"
                "- \"Winter season: Reduce watering & prune the plant.\"\n\n"
                "📌 *This feature is also currently in development.*",
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: HistoryService.getHistoryStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Error loading history: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No diagnosis history found",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Diagnose a plant leaf to save results here!",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        final docs = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        docs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aTime = aData['timestamp'] as Timestamp?;
          final bTime = bData['timestamp'] as Timestamp?;
          if (aTime == null) return -1;
          if (bTime == null) return 1;
          return bTime.compareTo(aTime);
        });

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final disease = data['disease'] ?? 'Unknown';
            final confidence = (data['confidence'] ?? 0.0).toDouble();
            final survivability = (data['survivability'] ?? 0.0).toDouble();
            final imageBase64 = data['imageBase64'] as String?;
            final timestamp = data['timestamp'] as Timestamp?;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Base64 Image Preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: imageBase64 != null
                            ? Image.memory(
                                base64Decode(imageBase64),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.green[50],
                                  child: const Icon(Icons.image, color: Colors.green),
                                ),
                              )
                            : Container(
                                color: Colors.green[50],
                                child: const Icon(Icons.image, color: Colors.green),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Metadata details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            disease.replaceAll('___', ' ').replaceAll('_', ' '),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Confidence: ${confidence.toStringAsFixed(1)}%",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "Date: ${_formatTimestamp(timestamp)}",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TreatPage(
                                    disease: disease,
                                    confidence: confidence,
                                    survivability: survivability,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "View Treatment ➔",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Confirm deletion
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete History"),
                            content: const Text("Are you sure you want to delete this diagnosis record?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final success = await HistoryService.deleteHistoryItem(doc.id);
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Diagnosis record deleted.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 64, color: Colors.green[300]),
            const SizedBox(height: 16),
            Text(
              "Access Diagnosis History",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please register or log in to automatically sync and store your plant health history in the cloud.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String title, required String description}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    )),
            const SizedBox(height: 10),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

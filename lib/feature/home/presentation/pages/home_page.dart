import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:leafcare/feature/agriculture/presentation/pages/agri_home.dart';
import 'package:leafcare/feature/care_tools/presentation/pages/care_home.dart';
import 'package:leafcare/feature/medicine/presentation/pages/medicine_home.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> carouselImages = [
      'assets/images/banner1.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
    ];

    final List<Map<String, String>> medicineVisuals = [
      {"name": "Fungal Cure", "image": "assets/images/medicine1.png"},
    ];

    final List<Map<String, String>> toolVisuals = [
      {"name": "Hand Rake", "image": "assets/images/tool1.png"},
    ];

    final List<Map<String, String>> agriVisuals = [
      {"name": "Soil Tester", "image": "assets/images/agri1.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafCare'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// Carousel Section
              CarouselSlider(
                items: carouselImages.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(imagePath, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                ),
              ),

              const SizedBox(height: 20),

              /// Plant Medicines Banner
              bannerSection(
                context,
                title: 'Plant Medicines',
                description:
                'Boost your plant\'s immunity with organic and chemical-free cures for fungal and bacterial infections.',
                backgroundImage: medicineVisuals[0]['image']!,
                navigateTo: const MedicineHome(),
              ),

              /// Plant Care Tools Banner
              bannerSection(
                context,
                title: 'Plant Care Tools',
                description:
                'Simplify your gardening with user-friendly and efficient plant care tools made for every home gardener.',
                backgroundImage: toolVisuals[0]['image']!,
                navigateTo: const CareHome(), // You can replace with another page
              ),

              /// Agricultural Equipment Banner
              bannerSection(
                context,
                title: 'Agricultural Expert',
                description:
                'Upgrade your farming techniques with precision tools like soil testers and fertilizer kits.',
                backgroundImage: agriVisuals[0]['image']!,
                navigateTo: const AgriHome(), // You can replace with another page
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget bannerSection(
      BuildContext context, {
        required String title,
        required String description,
        required String backgroundImage,
        required Widget navigateTo,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => navigateTo),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Explore",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


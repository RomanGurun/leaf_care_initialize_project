import 'package:flutter/material.dart';
import 'package:leafcare/feature/home/presentation/pages/home.dart';


class CareHome extends StatefulWidget {
  const CareHome({super.key});

  @override
  State<CareHome> createState() => _CareHomeState();
}

class _CareHomeState extends State<CareHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Tools'),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/tool2.png',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Essential Tools for Plant Care',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Proper tools make plant care easier, more efficient, and enjoyable. From pruning to soil testing, explore these essential instruments to maintain your garden or home plants with precision and love.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            _buildToolCard(
              icon: Icons.content_cut,
              title: 'Pruning Shears',
              description:
              'Used for trimming leaves, branches, and dead parts of plants to encourage healthier growth.',
            ),
            _buildToolCard(
              icon: Icons.water_drop,
              title: 'Watering Can / Hose',
              description:
              'A must-have for maintaining hydration. Choose cans with narrow spouts for precise indoor watering.',
            ),
            _buildToolCard(
              icon: Icons.science,
              title: 'Soil Tester Kit',
              description:
              'Helps check pH, moisture, and nutrients to maintain the optimal growing environment.',
            ),
            _buildToolCard(
              icon: Icons.energy_savings_leaf,
              title: 'Hand Trowel',
              description:
              'Perfect for digging small holes, transplanting seedlings, and mixing soil.',
            ),
            _buildToolCard(
              icon: Icons.cleaning_services,
              title: 'Gardening Gloves',
              description:
              'Protects hands from thorns, soil, and harmful chemicals during plant care.',
            ),
            _buildToolCard(
              icon: Icons.grass,
              title: 'Plant Support Stakes',
              description:
              'Keeps tall or weak plants upright and prevents damage due to wind or weight.',
            ),
            _buildToolCard(
              icon: Icons.bug_report,
              title: 'Sprayer / Misting Bottle',
              description:
              'Used for applying pesticides, foliar fertilizers, or keeping humidity-loving plants moist.',
            ),
            _buildToolCard(
              icon: Icons.autorenew,
              title: 'Compost Bin',
              description:
              'Stores organic waste for decomposition into compost, enriching soil with nutrients.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.green[800]),
          const SizedBox(width: 12),
          Expanded(
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
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

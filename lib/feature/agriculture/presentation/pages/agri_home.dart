import 'package:flutter/material.dart';
import 'package:leafcare/feature/home/presentation/pages/home.dart';



class AgriHome extends StatefulWidget {
  const AgriHome({super.key});

  @override
  State<AgriHome> createState() => _AgriHomeState();
}

class _AgriHomeState extends State<AgriHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agricultural Expert'),
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/agri2.png',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upgrade your farming techniques with precision tools like soil testers and fertilizer kits.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'How to Become an Agricultural Expert',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          _buildMilestone(
            icon: Icons.book,
            title: '1. Learn the Basics',
            subtitle: 'Understand crops, soil types, and climates.',
          ),
          _buildMilestone(
            icon: Icons.agriculture,
            title: '2. Hands-on Practice',
            subtitle: 'Work on a farm to gain real experience.',
          ),
          _buildMilestone(
            icon: Icons.science,
            title: '3. Use Modern Tools',
            subtitle: 'Adopt soil testers, drones, and smart irrigation.',
          ),
          _buildMilestone(
            icon: Icons.school,
            title: '4. Get Certified',
            subtitle: 'Take agricultural courses and certifications.',
          ),
          _buildMilestone(
            icon: Icons.public,
            title: '5. Stay Updated',
            subtitle: 'Follow the latest research and trends.',
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.info_outline,color: Colors.white,),
            label: const Text('Explore Expert Tools',style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(icon, color: Colors.green[800]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

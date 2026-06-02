import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:leafcare/core/presentation/components/bottom_nav_bar.dart';
import 'package:leafcare/core/presentation/components/notice_popup.dart';
import 'package:leafcare/core/utils/session_state.dart';
import 'package:leafcare/feature/auth/presentation/pages/login_or_register_page.dart';
import 'package:leafcare/feature/home/presentation/pages/home_page.dart';
import 'package:leafcare/feature/ml/presentation/pages/ml_home.dart';
import 'package:leafcare/feature/plant_diary/presentation/pages/cure_home.dart';
import 'package:leafcare/feature/shop/presentation/pages/shop_page.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomePopupOnce());
  }

  void _showWelcomePopupOnce() {
    if (!SessionState.hasShownWelcomePopup) {
      SessionState.hasShownWelcomePopup = true; // ✅ Set globally
      showDialog(
        context: context,
        builder: (_) => NoticePopup(
          message: 'welcome'.getString(context),
        ),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.hasData;

        return Scaffold(
          bottomNavigationBar: BottomNavBar(
            SelectedItem: currentIndex,
            onTap: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              setState(() {
                currentIndex = index;
              });
            },
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomePage(),
              const MlHome(),
              const CureHome(),
              isLoggedIn ? const ShopPage() : const LoginOrRegisterPage(),
            ],
          ),
        );
      },
    );
  }
}

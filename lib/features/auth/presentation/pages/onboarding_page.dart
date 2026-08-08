import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/core/storage/secure_storage_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> pages = [
    _OnboardingData(
      image: "assets/images/money.png",
      title: "Welcome",
      description:
          "Manage your money securely anytime, anywhere with Veegil Pay.",
    ),
    _OnboardingData(
      image: "assets/images/transfer.png",
      title: "Instant Transfers",
      description:
          "Send and receive money instantly with just an account number.",
    ),
    _OnboardingData(
      image: "assets/images/analytics.png",
      title: "Track Transactions",
      description:
          "View your deposits, withdrawals, and transfers in one place.",
    ),
  ];

  void _nextPage() async {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final storage = SecureStorageService();

      await storage.saveOnboardingSeen();

      if (context.mounted) {
        context.go('/loginOrSignup');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(page.image, height: 300,),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.indigo
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == pages.length - 1 ? "Get Started" : "Next",
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () async {
                final storage = SecureStorageService();

                await storage.saveOnboardingSeen();

                if (context.mounted) {
                  context.go('/loginOrSignup');
                }
              },
              child: const Text("Skip"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String image;
  final String title;
  final String description;

  _OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

import 'package:flutter/material.dart';

class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bills = [
      {"title": "Electricity", "icon": Icons.bolt, "color": Colors.orange},
      {"title": "Airtime", "icon": Icons.phone_android, "color": Colors.green},
      {"title": "Data", "icon": Icons.wifi, "color": Colors.blue},
      {"title": "TV Subscription", "icon": Icons.tv, "color": Colors.purple},
      {"title": "Internet", "icon": Icons.language, "color": Colors.indigo},
      {"title": "Betting", "icon": Icons.sports_soccer, "color": Colors.red},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Bills")),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Pay Bills",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Choose a service to pay for",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: GridView.builder(
                  itemCount: bills.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),

                  itemBuilder: (context, index) {
                    final bill = bills[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to specific bill payment page
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              height: 60,
                              width: 60,

                              decoration: BoxDecoration(
                                color: (bill["color"] as Color).withValues(
                                  alpha: 0.15,
                                ),
                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                bill["icon"] as IconData,
                                color: bill["color"] as Color,
                                size: 30,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              bill["title"] as String,

                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

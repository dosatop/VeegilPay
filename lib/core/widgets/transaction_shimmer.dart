import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TransactionShimmer extends StatelessWidget {
  const TransactionShimmer({super.key});

  Widget box({
    required double height,
    double? width,
    double radius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // FILTERS
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,

                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: box(
                      height: 45,
                      width: 90,
                      radius: 14,
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 15),


            // CHART PLACEHOLDER
            box(
              height: 180,
              width: double.infinity,
              radius: 16,
            ),


            const SizedBox(height: 20),


            // TRANSACTION CARDS
            Expanded(
              child: ListView.builder(
                itemCount: 6,

                itemBuilder: (_, index) {

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      children: [

                        box(
                          height: 45,
                          width: 45,
                          radius: 50,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              box(
                                height: 15,
                                width: 140,
                              ),

                              const SizedBox(height: 8),

                              box(
                                height: 12,
                                width: 90,
                              ),
                            ],
                          ),
                        ),


                        box(
                          height: 15,
                          width: 80,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
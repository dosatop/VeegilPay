import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoneyOverviewChart extends StatelessWidget {
  final double deposit;
  final double withdrawal;
  final double transferReceived;
  final double transferSent;

  const MoneyOverviewChart({
    super.key,
    required this.deposit,
    required this.withdrawal,
    required this.transferReceived,
    required this.transferSent,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");

    final moneyIn = deposit + transferReceived;

    final moneyOut = withdrawal + transferSent;

    final netFlow = moneyIn - moneyOut;

    final data = [
      ChartData("Deposit", deposit, Colors.green, Icons.add_circle_outline),

      ChartData(
        "Withdrawal",
        withdrawal,
        Colors.red,
        Icons.remove_circle_outline,
      ),

      ChartData(
        "Incoming Transfer",
        transferReceived,
        Colors.blue,
        Icons.arrow_downward_rounded,
      ),

      ChartData(
        "Outgoing Transfer",
        transferSent,
        Colors.orange,
        Icons.arrow_upward_rounded,
      ),
    ].where((e) => e.amount > 0).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Money Overview",

                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Transaction summary",

                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: .1),

                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.pie_chart_outline, color: Colors.blue),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 220,
                  child: SfCircularChart(
                    margin: EdgeInsets.zero,

                    tooltipBehavior: TooltipBehavior(enable: true),

                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: data,

                        xValueMapper: (item, _) => item.name,

                        yValueMapper: (item, _) => item.amount,

                        pointColorMapper: (item, _) => item.color,

                        radius: "80%",

                        innerRadius: "68%",

                        explode: false,

                        strokeColor: Colors.white,

                        strokeWidth: 3,

                        animationDuration: 800,
                      ),
                    ],

                    annotations: [
                      CircularChartAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Net Flow",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "${netFlow >= 0 ? '+' : '-'}₦${formatter.format(netFlow.abs())}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: netFlow >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(width: 5),

                          Text(
                            "₦${formatter.format(item.amount)}",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: item.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: MoneySummaryCard(
                  title: "Money In",

                  amount: moneyIn,

                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: MoneySummaryCard(
                  title: "Money Out",

                  amount: moneyOut,

                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MoneySummaryCard extends StatelessWidget {
  final String title;

  final double amount;

  final Color color;

  const MoneySummaryCard({
    super.key,

    required this.title,

    required this.amount,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),

          const SizedBox(height: 5),

          Text(
            "₦${NumberFormat("#,###").format(amount)}",

            style: TextStyle(
              color: color,

              fontWeight: FontWeight.bold,

              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String name;

  final double amount;

  final Color color;

  final IconData icon;

  ChartData(this.name, this.amount, this.color, this.icon);
}

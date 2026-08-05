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
        "Transfer Received",
        transferReceived,
        Colors.blue,
        Icons.arrow_downward_rounded,
      ),

      ChartData(
        "Transfer Sent",
        transferSent,
        Colors.orange,
        Icons.arrow_upward_rounded,
      ),
    ].where((e) => e.amount > 0).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

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

          SizedBox(
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

                  radius: "75%",

                  innerRadius: "68%",

                  // keeps slices perfectly round
                  explode: false,

                  // clean separation
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

                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      Text(
                        "${netFlow >= 0 ? '+' : '-'}₦${formatter.format(netFlow.abs())}",

                        style: TextStyle(
                          fontSize: 17,

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

          const SizedBox(height: 15),

          Wrap(
            spacing: 10,

            runSpacing: 10,

            children: data.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,

                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: .12),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(item.icon, size: 15, color: item.color),

                    const SizedBox(width: 5),

                    Text(
                      item.name,

                      style: TextStyle(
                        fontSize: 12,

                        color: item.color,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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

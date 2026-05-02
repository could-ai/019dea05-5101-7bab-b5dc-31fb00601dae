import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate simple metrics from mock data
    final activeDeals = MockData.deals.where((d) => d.stage != DealStage.won && d.stage != DealStage.lost).toList();
    final pipelineValue = activeDeals.fold(0.0, (sum, deal) => sum + deal.value);
    
    final wonDeals = MockData.deals.where((d) => d.stage == DealStage.won).toList();
    final wonValue = wonDeals.fold(0.0, (sum, deal) => sum + deal.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 400 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildKPICard(
                      context, 
                      title: 'Pipeline Value', 
                      value: NumberFormat.currency(symbol: '\$').format(pipelineValue),
                      icon: Icons.monetization_on_outlined,
                      color: Colors.blue,
                    ),
                    _buildKPICard(
                      context, 
                      title: 'Active Deals', 
                      value: activeDeals.length.toString(),
                      icon: Icons.business_center_outlined,
                      color: Colors.orange,
                    ),
                    _buildKPICard(
                      context, 
                      title: 'Total Won', 
                      value: NumberFormat.currency(symbol: '\$').format(wonValue),
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                    _buildKPICard(
                      context, 
                      title: 'Win Rate', 
                      value: '42%',
                      icon: Icons.trending_up,
                      color: Colors.purple,
                    ),
                  ],
                );
              }
            ),
            
            const SizedBox(height: 24),
            
            // Charts & Lists section
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChartSection(context),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildUpcomingActivities(context),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildChartSection(context),
                    const SizedBox(height: 24),
                    _buildUpcomingActivities(context),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pipeline Growth',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: Colors.grey, fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 1: text = 'Jan'; break;
                            case 3: text = 'Feb'; break;
                            case 5: text = 'Mar'; break;
                            case 7: text = 'Apr'; break;
                            case 9: text = 'May'; break;
                            default: return Container();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(2, 5),
                        FlSpot(4, 4),
                        FlSpot(6, 8),
                        FlSpot(8, 7),
                        FlSpot(10, 10),
                      ],
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingActivities(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...MockData.activities.take(4).map((activity) {
              final contact = MockData.contacts.firstWhere((c) => c.id == activity.contactId);
              IconData icon;
              Color iconColor;
              
              switch(activity.type) {
                case 'call':
                  icon = Icons.phone;
                  iconColor = Colors.green;
                  break;
                case 'email':
                  icon = Icons.email;
                  iconColor = Colors.blue;
                  break;
                case 'meeting':
                  icon = Icons.event;
                  iconColor = Colors.purple;
                  break;
                default:
                  icon = Icons.task;
                  iconColor = Colors.grey;
              }

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.1),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text('With ${contact.name}'),
                trailing: Text(
                  DateFormat('MMM d').format(activity.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

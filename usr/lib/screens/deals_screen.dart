import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  // In a real app we'd use Drag and Drop, but for simplicity here we'll render the board.
  
  String _getStageName(DealStage stage) {
    switch (stage) {
      case DealStage.lead: return 'Leads';
      case DealStage.qualified: return 'Qualified';
      case DealStage.proposal: return 'Proposal';
      case DealStage.negotiation: return 'Negotiation';
      case DealStage.won: return 'Closed Won';
      case DealStage.lost: return 'Closed Lost';
    }
  }

  Color _getStageColor(DealStage stage) {
    switch (stage) {
      case DealStage.lead: return Colors.grey;
      case DealStage.qualified: return Colors.blue;
      case DealStage.proposal: return Colors.orange;
      case DealStage.negotiation: return Colors.purple;
      case DealStage.won: return Colors.green;
      case DealStage.lost: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pipeline', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // If wide screen, try to show more stages without scroll, otherwise horizontal scroll
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: DealStage.values.map((stage) {
                return _buildKanbanColumn(stage);
              }).toList(),
            ),
          );
        }
      ),
    );
  }

  Widget _buildKanbanColumn(DealStage stage) {
    final dealsInStage = MockData.deals.where((d) => d.stage == stage).toList();
    final totalValue = dealsInStage.fold(0.0, (sum, deal) => sum + deal.value);
    
    return Container(
      width: 300,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStageColor(stage),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStageName(stage),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                         dealsInStage.length.toString(),
                         style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (dealsInStage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                NumberFormat.currency(symbol: '\$').format(totalValue),
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ),
          // Deals List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dealsInStage.length,
              itemBuilder: (context, index) {
                final deal = dealsInStage[index];
                return _buildDealCard(deal);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(Deal deal) {
    final contact = MockData.contacts.firstWhere((c) => c.id == deal.contactId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deal.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              deal.company,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  NumberFormat.currency(symbol: '\$').format(deal.value),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(contact.avatarUrl),
                  radius: 12,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM d, yyyy').format(deal.expectedCloseDate),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

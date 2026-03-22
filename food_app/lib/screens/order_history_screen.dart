import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const Color primaryGreen = Color(0xFF00C853);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryOrange = Color(0xFFFF6B35);
  
  String _selectedTab = 'All Orders';

  // Sample order data with different statuses
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#B4291',
      'items': '3 Items • Gourmet Burger, Fries...',
      'price': '\$24.50',
      'date': 'Oct 24, 2023 • 12:45 PM',
      'status': 'Ongoing',
      'statusColor': primaryOrange,
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#B4290',
      'items': '2 Items • Sushi Platter, Miso Soup',
      'price': '\$32.00',
      'date': 'Oct 24, 2023 • 11:20 AM',
      'status': 'Ongoing',
      'statusColor': primaryOrange,
      'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#B3304',
      'items': '1 Item • Large Pepperoni',
      'price': '\$18.00',
      'date': 'Oct 20, 2023 • 08:15 PM',
      'status': 'Completed',
      'statusColor': primaryGreen,
      'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#B3100',
      'items': '4 Items • Pasta Carbonara, Garlic Bread...',
      'price': '\$28.75',
      'date': 'Oct 19, 2023 • 07:30 PM',
      'status': 'Completed',
      'statusColor': primaryGreen,
      'imageUrl': 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#D1001',
      'items': '2 Items • Caesar Salad, Lemonade',
      'price': '\$15.50',
      'date': 'Oct 24, 2023 • 09:00 AM',
      'status': 'Draft',
      'statusColor': Colors.grey,
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#D1002',
      'items': '1 Item • Chicken Wrap',
      'price': '\$12.00',
      'date': 'Oct 23, 2023 • 02:15 PM',
      'status': 'Draft',
      'statusColor': Colors.grey,
      'imageUrl': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#B2995',
      'items': '2 Items • Garden Salad, Coke',
      'price': '\$12.20',
      'date': 'Oct 18, 2023 • 01:30 PM',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=100',
    },
    {
      'id': '#B1692',
      'items': '3 Items • Assorted Donuts',
      'price': '\$12.99',
      'date': 'Oct 12, 2023 • 10:30 AM',
      'status': 'Completed',
      'statusColor': primaryGreen,
      'imageUrl': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&q=80&w=100',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedTab == 'All Orders') {
      return _allOrders;
    } else if (_selectedTab == 'Ongoing') {
      return _allOrders.where((order) => order['status'] == 'Ongoing').toList();
    } else if (_selectedTab == 'Completed') {
      return _allOrders.where((order) => order['status'] == 'Completed').toList();
    } else if (_selectedTab == 'Drafts') {
      return _allOrders.where((order) => order['status'] == 'Draft').toList();
    }
    return _allOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: primaryBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('All Orders'),
                  const SizedBox(width: 12),
                  _buildTab('Ongoing'),
                  const SizedBox(width: 12),
                  _buildTab('Completed'),
                  const SizedBox(width: 12),
                  _buildTab('Drafts'),
                ],
              ),
            ),
          ),
          // Orders List
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You don\'t have any ${_selectedTab.toLowerCase()} yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildOrderCard(
                          index,
                          order['id'],
                          order['items'],
                          order['price'],
                          order['date'],
                          order['status'],
                          order['statusColor'],
                          order['imageUrl'],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    int index,
    String orderId,
    String items,
    String price,
    String date,
    String status,
    Color statusColor,
    String fallbackImageUrl,
  ) {
    // Attempt to hijack real food images dynamically from API data
    String finalImageUrl = fallbackImageUrl;
    try {
      final foodItems = context.read<AppState>().foodItems;
      if (foodItems.isNotEmpty) {
        finalImageUrl = foodItems[index % foodItems.length].imageUrl;
      }
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing order $orderId'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                finalImageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Order $orderId',
                          style: const TextStyle(
                            color: primaryBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryBlue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

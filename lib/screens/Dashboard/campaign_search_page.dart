import 'package:flutter/material.dart';
import '../../class/api_service.dart';
// import '../../class/jwt_helper.dart';
import '../../class/campaign.dart';

class CampaignSearchPage extends StatefulWidget {
  const CampaignSearchPage({super.key});

  @override
  State<CampaignSearchPage> createState() => _CampaignSearchPageState();
}

class _CampaignSearchPageState extends State<CampaignSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedTimePeriod = 'All Time';
  List<Campaign> _filteredCampaigns = [];
  List<Campaign> _allCampaigns = [];
  bool isLoading = true;

  final List<String> _categories = [
    'All',
    'Medical',
    'Education',
    'Emergency',
    'Community',
    'Animals',
    'Environment',
  ];

  final List<String> _timePeriods = [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
    _searchController.addListener(_filterCampaigns);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCampaigns() async {
  List<Map<String, String>> offer = [];
  List<Map<String, String>> moffer = [];
  
  try {
    setState(() => isLoading = true);
    
    dynamic token = await ApiService().getCampaign();
    
    // Add null check
    if (token == null) {
      print('API returned null');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No campaigns available'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Check if token is a List before casting
    if (token is! List) {
      print('Unexpected data type: ${token.runtimeType}');
      print('Data: $token');
      setState(() => isLoading = false);
      return;
    }

    List<Map<String, dynamic>> task = token.cast<Map<String, dynamic>>();

    for (var obj in task) {
      try {
        Campaign p = Campaign(
          obj['title'] as String,
          obj['description'] as String,
          obj['category'] as String,
          offer,
          moffer,
        );
        
        if (obj['image'] != null && 
            obj['start_date'] != null && 
            obj['end_date'] != null &&
            obj['current_amount'] != null) {
          p.setCampaignDetails(
            obj['start_date'],
            obj['end_date'],
            obj['image'],
            obj['current_amount'],
            obj['title'],
            obj['title'],
          );
          _allCampaigns.add(p);
        } else {
          print('Missing fields in campaign: $obj');
        }
      } catch (e) {
        print('Error parsing campaign: $e');
        print('Campaign data: $obj');
      }
    }

    setState(() {
      _filteredCampaigns = _allCampaigns;
      isLoading = false;
    });
  } catch (e) {
    print('Error loading campaign: $e');
    setState(() => isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  void _filterCampaigns() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      
      _filteredCampaigns = _allCampaigns.where((campaign) {
        // Filter by search query
        bool matchesSearch = query.isEmpty ||
            campaign.title.toLowerCase().contains(query) ||
            campaign.category.toLowerCase().contains(query);

        // Filter by category
        bool matchesCategory = _selectedCategory == 'All' ||
            campaign.category == _selectedCategory;

        // Filter by time period
        bool matchesTimePeriod = _matchesTimePeriod(campaign.created_at!);

        return matchesSearch && matchesCategory && matchesTimePeriod;
      }).toList();
    });
  }

  bool _matchesTimePeriod(DateTime date) {
    DateTime now = DateTime.now();
    switch (_selectedTimePeriod) {
      case 'Today':
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case 'This Week':
        DateTime weekAgo = now.subtract(const Duration(days: 7));
        return date.isAfter(weekAgo);
      case 'This Month':
        return date.year == now.year && date.month == now.month;
      case 'This Year':
        return date.year == now.year;
      default:
        return true;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Allow full height control
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8, // Increased height to 80% of screen height
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedCategory = 'All';
                          _selectedTimePeriod = 'All Time';
                        });
                        setState(() {
                          _selectedCategory = 'All';
                          _selectedTimePeriod = 'All Time';
                        });
                        _filterCampaigns();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    bool isSelected = category == _selectedCategory;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() => _selectedCategory = category);
                        setState(() => _selectedCategory = category);
                        _filterCampaigns();
                      },
                      selectedColor: const Color(0xFF007A74),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Time Period',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _timePeriods.map((period) {
                    bool isSelected = period == _selectedTimePeriod;
                    return ChoiceChip(
                      label: Text(period),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() => _selectedTimePeriod = period);
                        setState(() => _selectedTimePeriod = period);
                        _filterCampaigns();
                      },
                      selectedColor: const Color(0xFF007A74),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A74),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 150), // Increased spacing between bottom of screen and Apply Filter button
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search campaigns...',
                              prefixIcon: const Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterCampaigns();
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: _showFilterBottomSheet,
                      ),
                    ],
                  ),
                  if (_selectedCategory != 'All' ||
                      _selectedTimePeriod != 'All Time')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (_selectedCategory != 'All')
                              _buildFilterChip(
                                _selectedCategory,
                                () {
                                  setState(() => _selectedCategory = 'All');
                                  _filterCampaigns();
                                },
                              ),
                            if (_selectedTimePeriod != 'All Time')
                              _buildFilterChip(
                                _selectedTimePeriod,
                                () {
                                  setState(
                                      () => _selectedTimePeriod = 'All Time');
                                  _filterCampaigns();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Results Count
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredCampaigns.length} ${_filteredCampaigns.length == 1 ? 'campaign' : 'campaigns'} found',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Grid Results
            Expanded(
              child: _filteredCampaigns.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No campaigns found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredCampaigns.length,
                      itemBuilder: (context, index) {
                        return _buildCampaignCard(_filteredCampaigns[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF007A74),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(Campaign campaign) {
    double progress = campaign.currentAmount / campaign.amount;
    
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to campaign details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${campaign.title}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  campaign.imageUrl!.path,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.campaign,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),

            // Campaign Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007A74).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        campaign.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF007A74),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      campaign.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF007A74),
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Amount Raised
                    Text(
                      '₦${_formatAmount(campaign.amount)} raised',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
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

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

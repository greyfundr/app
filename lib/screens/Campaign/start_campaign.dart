import 'package:flutter/material.dart';
import 'fundraise_target.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, String>> savedAutoOffers = [];
  List<Map<String, String>> savedManualOffers = [];

  bool get hasOffers => savedAutoOffers.isNotEmpty || savedManualOffers.isNotEmpty;

  String? selectedCategory;

  // Categories list with label and icon assets
  final List<Map<String, dynamic>> categories = [
    {'label': 'Medical', 'icon': 'assets/icons/medical.png'},
    {'label': 'Education', 'icon': 'assets/icons/education.png'},
    {'label': 'Travel', 'icon': 'assets/icons/travel.png'},
    {'label': 'Nature', 'icon': 'assets/icons/nature.png'},
    {'label': 'Animal', 'icon': 'assets/icons/animal.png'},
    {'label': 'Social', 'icon': 'assets/icons/social.png'},
    {'label': 'Disaster', 'icon': 'assets/icons/disaster.png'},
     {'label': 'Religion', 'icon': 'assets/icons/religion.png'},
      {'label': 'Business', 'icon': 'assets/icons/business1.png'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showOffersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OffersBottomSheet(
        onSave: (auto, manual) {
          setState(() {
            savedAutoOffers = auto;
            savedManualOffers = manual;
          });
        },
      ),
    );
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              category['icon'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: Text(
                          category['label'],
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            selectedCategory = category['label'];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedCategoryWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    categories.firstWhere((c) => c['label'] == selectedCategory)['icon'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                selectedCategory ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedCategory = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedOffersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Auto Offers
        if (savedAutoOffers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              'Auto Offers',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...savedAutoOffers.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Condition: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value['condition'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Reward: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value['reward'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red[400],
                      onPressed: () => _deleteOffer(true, entry.key),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        // Manual Offers
        if (savedManualOffers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              'Manual Offers',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...savedManualOffers.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Condition: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value['condition'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reward: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value['reward'] ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red[400],
                      onPressed: () => _deleteOffer(false, entry.key),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  void _deleteOffer(bool isAuto, int index) {
    setState(() {
      if (isAuto) {
        savedAutoOffers.removeAt(index);
      } else {
        savedManualOffers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Campaign'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Account Card
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: Image.asset(
                                'assets/icons/personal.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Yourself',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By setting up a Personal Account, you gain and control all aspects of this Account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Campaign Title
              const Text(
                'Campaign Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What name do you want to give to your Campaign/Fundraiser',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                maxLines: 1,
              ),

              const SizedBox(height: 24),

              // Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s describe this campaign so donors could understand what you are trying to achieve!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
              ),

              const SizedBox(height: 24),

              // Select Category or Show Selected
              selectedCategory == null
                  ? _buildExpandableOption(
                      icon: Icons.add_circle,
                      title: 'Select Category',
                      subtitle: 'What Kind of Fundraiser are you creating?',
                      onTap: _showCategoryBottomSheet,
                    )
                  : _buildSelectedCategoryWidget(),

              const SizedBox(height: 16),

              // Set Offers with Rewards
              _buildExpandableOption(
                icon: Icons.add_circle,
                title: hasOffers ? 'Add more offers & rewards' : 'Set Offers with Rewards',
                subtitle: '',
                onTap: _showOffersBottomSheet,
              ),

              if (hasOffers) ...[
                const SizedBox(height: 16),
                _buildSavedOffersList(),
              ],

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FundraisingScreen(
                          title: _titleController.text,
                          description: _descriptionController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A9A5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00A9A5),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Keep your existing _OffersBottomSheet class here unchanged
// For brevity, not including it again here; integrate your current offers bottom sheet code as-is

class _OffersBottomSheet extends StatefulWidget {
  final Function(List<Map<String, String>>, List<Map<String, String>>) onSave;

  const _OffersBottomSheet({
    required this.onSave,
  });

  @override
  State<_OffersBottomSheet> createState() => _OffersBottomSheetState();
}

class _OffersBottomSheetState extends State<_OffersBottomSheet> {
  List<Map<String, TextEditingController>> autoOffers = [];
  List<Map<String, TextEditingController>> manualOffers = [];
  bool applyToAll = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var offer in autoOffers) {
      offer['condition']?.dispose();
      offer['reward']?.dispose();
    }
    for (var offer in manualOffers) {
      offer['condition']?.dispose();
      offer['reward']?.dispose();
    }
    super.dispose();
  }

  void _addAutoOffer() {
    setState(() {
      autoOffers.add({
        'condition': TextEditingController(),
        'reward': TextEditingController(),
      });
    });
  }

  void _addManualOffer() {
    setState(() {
      manualOffers.add({
        'condition': TextEditingController(),
        'reward': TextEditingController(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Offers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'define what your CHAMPIONS, BACKERS, and SHORTY will get if they complete a task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[300]),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Auto Offers Section
                  const Text(
                    'Auto Offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This offers can be activated within the app',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Auto Offers List
                  ...autoOffers.asMap().entries.map((entry) {
                    final conditionController = entry.value['condition']!;
                    final rewardController = entry.value['reward']!;
                    return _buildOfferCard(
                      conditionController: conditionController,
                      rewardController: rewardController,
                      onRemove: () {
                        setState(() {
                          conditionController.dispose();
                          rewardController.dispose();
                          autoOffers.removeAt(entry.key);
                        });
                      },
                    );
                  }),

                  // Add more button for Auto Offers
                  InkWell(
                    onTap: _addAutoOffer,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A9A5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Add more',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Manual Offers Section
                  const Text(
                    'Manual Offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Manual Offers List
                  ...manualOffers.asMap().entries.map((entry) {
                    final conditionController = entry.value['condition']!;
                    final rewardController = entry.value['reward']!;
                    return _buildOfferCard(
                      conditionController: conditionController,
                      rewardController: rewardController,
                      onRemove: () {
                        setState(() {
                          conditionController.dispose();
                          rewardController.dispose();
                          manualOffers.removeAt(entry.key);
                        });
                      },
                      isManual: true,
                    );
                  }),

                  // Add more button for Manual Offers
                  InkWell(
                    onTap: _addManualOffer,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A9A5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Add more',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Apply offers to all checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: applyToAll,
                        onChanged: (value) {
                          setState(() {
                            applyToAll = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF00A9A5),
                      ),
                      const Text(
                        'Apply offers to all',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Add Offers Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Convert controllers to string maps
                        List<Map<String, String>> autoOffersData = autoOffers
                            .map((offer) => {
                                  'condition': offer['condition']!.text,
                                  'reward': offer['reward']!.text,
                                })
                            .where((offer) =>
                                offer['condition']!.isNotEmpty ||
                                offer['reward']!.isNotEmpty)
                            .toList();

                        List<Map<String, String>> manualOffersData = manualOffers
                            .map((offer) => {
                                  'condition': offer['condition']!.text,
                                  'reward': offer['reward']!.text,
                                })
                            .where((offer) =>
                                offer['condition']!.isNotEmpty ||
                                offer['reward']!.isNotEmpty)
                            .toList();

                        widget.onSave(autoOffersData, manualOffersData);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A9A5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ADD OFFERS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard({
    required TextEditingController conditionController,
    required TextEditingController rewardController,
    required VoidCallback onRemove,
    bool isManual = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Conditions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!isManual)
                const Text(
                  'Reward',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: conditionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              if (!isManual) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Handle reward selection
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00A9A5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (isManual) ...[
            const SizedBox(height: 16),
            const Text(
              'Rewards',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: rewardController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

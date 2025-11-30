// lib/screens/Campaign/edit_campaign_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'error_boundary.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../class/campaign.dart'; // Adjust path if needed

class EditCampaignScreen extends StatefulWidget {
  final Campaign campaign;
  const EditCampaignScreen({super.key, required this.campaign});

  @override
  State<EditCampaignScreen> createState() => _EditCampaignScreenState();
}

class _EditCampaignScreenState extends State<EditCampaignScreen> {
  late Campaign _campaign;
  late String _editableDescription;
  List<Map<String, String>> _budgetItems = [];
  List<Map<String, String>> _offers = [];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _campaign = Campaign.from(widget.campaign);
    _editableDescription = _campaign.description;
    _offers = [..._campaign.savedAutoOffers, ..._campaign.savedManualOffers];
    // Load budget items if saved elsewhere in your campaign
  }

  void _saveAndFinish() {
    _campaign.description = _editableDescription;
    _campaign.savedAutoOffers = _offers.where((o) => o['type'] == 'auto').toList();
    _campaign.savedManualOffers = _offers.where((o) => o['type'] != 'auto').toList();
    Navigator.pop(context, _campaign);
  }

  // IMAGE MANAGER MODAL
  void _showImageManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Campaign Images", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _campaign.images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_campaign.images[index], fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _campaign.images.removeAt(index));
                            Navigator.pop(context);
                            _showImageManager(); // Refresh
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _pickMoreImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Add More Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 164, 175, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMoreImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _campaign.images.addAll(picked.map((x) => File(x.path)));
      });
      if (mounted) Navigator.pop(context);
    }
  }

  // TITLE EDIT
  void _editTitle() {
    final controller = TextEditingController(text: _campaign.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Campaign Title", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter title")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => _campaign.title = controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // PARTICIPANTS EDIT MODAL
  void _editParticipants() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Manage Team", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _campaign.participants.length,
                itemBuilder: (context, i) {
                  final p = _campaign.participants[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(p.imageUrl)),
                    title: Text(p.name),
                    subtitle: Text(p.username),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _campaign.participants.removeAt(i)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Placeholder for adding participants (expand later with search)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add participant feature coming soon")));
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Add Participant"),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromRGBO(0, 164, 175, 1))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ABOUT EDIT MODAL
  void _editAbout() {
    final controller = TextEditingController(text: _editableDescription);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Description", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: "Tell your story...",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() => _editableDescription = controller.text.trim());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 164, 175, 1),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Save Description"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUDGET EDIT MODAL (Reused from your old code)
  void _editBudget() {
    List<Map<String, String>> tempBudgetItems = List.from(_budgetItems);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Budget", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ...tempBudgetItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 247, 249, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(item['expense'] ?? '')),
                      Expanded(child: Text(item['cost'] ?? '', textAlign: TextAlign.right)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => setModalState(() => tempBudgetItems.removeAt(index)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  _showAddBudgetItemDialog(context, setModalState, tempBudgetItems);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Budget Item"),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromRGBO(0, 164, 175, 1))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() => _budgetItems = tempBudgetItems);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(0, 164, 175, 1)),
                child: const Text("Save Budget"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBudgetItemDialog(BuildContext context, StateSetter setModalState, List<Map<String, String>> budgetItems) {
    final expenseController = TextEditingController();
    final costController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Budget Item", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: expenseController,
              decoration: const InputDecoration(labelText: "Expense", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: costController,
              decoration: const InputDecoration(labelText: "Cost (₦)", prefixText: "₦ ", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (expenseController.text.isNotEmpty && costController.text.isNotEmpty) {
                setModalState(() {
                  budgetItems.add({
                    'expense': expenseController.text,
                    'cost': '₦${costController.text}',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // OFFERS EDIT MODAL (Reused from your old code)
  void _editOffers() {
    List<Map<String, String>> tempOffers = List.from(_offers);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Offers", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ...tempOffers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> offer = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 247, 249, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Condition: ${offer['condition'] ?? ''}"),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => setModalState(() => tempOffers.removeAt(index)),
                          ),
                        ],
                      ),
                      Text("Reward: ${offer['reward'] ?? ''}", style: const TextStyle(color: Color.fromRGBO(0, 164, 175, 1))),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  _showAddOfferDialog(context, setModalState, tempOffers);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Offer"),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromRGBO(0, 164, 175, 1))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() => _offers = tempOffers);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(0, 164, 175, 1)),
                child: const Text("Save Offers"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOfferDialog(BuildContext context, StateSetter setModalState, List<Map<String, String>> offers) {
    final conditionController = TextEditingController();
    final rewardController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Offer", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(labelText: "Condition", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rewardController,
              decoration: const InputDecoration(labelText: "Reward", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (conditionController.text.isNotEmpty && rewardController.text.isNotEmpty) {
                setModalState(() {
                  offers.add({
                    'condition': conditionController.text,
                    'reward': rewardController.text,
                    'type': 'manual', // Differentiate manual vs auto
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black87 : Colors.grey[600],
                ),
              ),
              if (["ABOUT", "BUDGETING", "OFFERS"].contains(label))
                IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Color.fromARGB(255, 130, 176, 171)),
                  onPressed: () {
                    if (label == "ABOUT") _editAbout();
                    if (label == "BUDGETING") _editBudget();
                    if (label == "OFFERS") _editOffers();
                  },
                ),
            ],
          ),
          Container(
            height: 3,
            width: 40,
            color: isSelected ? const Color.fromRGBO(0, 164, 175, 1) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // ABOUT
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_editableDescription, style: GoogleFonts.inter(fontSize: 14)),
        );
      case 1: // BUDGETING
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Budget Breakdown", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ..._budgetItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['expense'] ?? '', style: GoogleFonts.inter(fontSize: 14)),
                    Text(item['cost'] ?? '', style: GoogleFonts.inter(fontSize: 14, color: const Color.fromRGBO(0, 164, 175, 1))),
                  ],
                ),
              )),
              if (_budgetItems.isEmpty) const Text("No budget items added"),
            ],
          ),
        );
      case 2: // OFFERS
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Campaign Offers", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ..._offers.map((offer) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(offer['condition'] ?? '', style: GoogleFonts.inter(fontSize: 14)),
                    Text("Reward: ${offer['reward'] ?? ''}", style: GoogleFonts.inter(fontSize: 14, color: const Color.fromRGBO(0, 164, 175, 1))),
                  ],
                ),
              )),
              if (_offers.isEmpty) const Text("No offers added"),
            ],
          ),
        );
      case 3: // DONATIONS
        return const Padding(padding: EdgeInsets.all(16), child: Text("No donations yet"));
      case 4: // COMMENTS
        return const Padding(padding: EdgeInsets.all(16), child: Text("No comments yet"));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // IMAGE CAROUSEL
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300,
              child: _campaign.images.isEmpty
                  ? Container(color: Colors.grey[300], child: const Center(child: Text("No images")))
                  : PageView.builder(
                      itemCount: _campaign.images.length,
                      itemBuilder: (_, i) => Image.file(_campaign.images[i], fit: BoxFit.cover),
                    ),
            ),
          ),
          // Floating edit icon on image
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt, color: Color.fromRGBO(0, 164, 175, 1)),
              onPressed: _showImageManager,
            ),
          ),

          // Main content
          Positioned.fill(
            top: 300,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + edit
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _campaign.title,
                            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.edit, color: Colors.teal), onPressed: _editTitle),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Positioned(
                        left: 22.0,
                        top: 321.0,
                        child: ErrorBoundary(
                          child: SizedBox(
                            width: 350.0,
                            height: 16.0,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double targetAmount = double.tryParse(
                                  widget.campaign.amount.toString().replaceAll('₦', '').replaceAll(',', '').trim()
                                ) ?? 1.0;
                                double raisedAmount = 0.0;
                                double progress = targetAmount > 0 ? raisedAmount / targetAmount : 0.0;
                                progress = progress.clamp(0.0, 1.0);
                                double indicatorPosition = constraints.maxWidth * progress;

                                return Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 4.0,
                                      child: Container(
                                        width: 392.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(192, 206, 199, 1),
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    if (progress > 0)
                                      Positioned(
                                        left: 0,
                                        top: 4.0,
                                        child: Container(
                                          width: indicatorPosition,
                                          height: 8.0,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(0, 164, 175, 1.0),
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      left: indicatorPosition > 0 ? indicatorPosition - 8.0 : 0,
                                      top: 0,
                                      child: Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: progress > 0
                                              ? Color.fromRGBO(0, 164, 175, 1.0)
                                              : Color.fromRGBO(142, 150, 163, 1.0),
                                          border: Border.all(
                                            color: Color.fromRGBO(255, 255, 255, 1.0),
                                            width: 2.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.15),
                                              blurRadius: 4.0,
                                              offset: Offset(0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            progress > 0 ? '${(progress * 100).toInt()}%' : '',
                                            style: GoogleFonts.inter(
                                              fontSize: 6.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(255, 255, 255, 1.0),
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    // Progress (placeholder - copy from review page if needed)
                    RichText(
  text: TextSpan(
    style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
    children: [
      const TextSpan(text: "₦0 raised of "),
      TextSpan(
        text: "₦${_campaign.amount.toStringAsFixed(0)}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
),
                    const SizedBox(height: 20),

                    // Team section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Campaign Team", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _editParticipants,
                              child: const Text("Edit", style: TextStyle(color: Color.fromRGBO(0, 164, 175, 1))),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("See All", style: TextStyle(color: Color.fromRGBO(0, 164, 175, 1))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Team cards (reuse your horizontal list from review page)

                    const SizedBox(height: 30),
                    // Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab("ABOUT", 0),
                        _buildTab("BUDGETING", 1),
                        _buildTab("OFFERS", 2),
                        // _buildTab("DONATIONS", 3),
                        // _buildTab("COMMENTS", 4),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tab content
                    _buildTabContent(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // FINISH EDITING BUTTON
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: ElevatedButton(
              onPressed: _saveAndFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 164, 175, 1),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "FINISH EDITING",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
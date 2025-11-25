import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Add this import for TextInputFormatter
import 'reviewstartcampaign3.dart';
import '../../class/campaign.dart';
import '../../class/participants.dart';
import '../../class/api_service.dart';

// Add this custom formatter class for comma-separated numbers
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters except for the decimal point if needed (but assuming integers for fundraising)
    final String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int? value = int.tryParse(newText);
    if (value == null) {
      return oldValue;
    }

    final String formatted = NumberFormat('#,###').format(value);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class FundraisingScreen extends StatefulWidget {
  final Campaign campaign;

  const FundraisingScreen({super.key, required this.campaign});

  @override
  State<FundraisingScreen> createState() => _FundraisingScreenState();
}

class _FundraisingScreenState extends State<FundraisingScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<Participant> selectedParticipants = [];
  List<File> selectedImages = []; // Store selected images

  List<Participant> allUsers = [];

  List<Participant> champions = [];

  List<Participant> backers = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    dynamic token = await ApiService().getUsers();
    dynamic tokens = await ApiService().getChampions();
    dynamic tokens1 = await ApiService().getBackers();

    List<Map<String, dynamic>> tasks = token.cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> tasks1 = tokens.cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> tasks2 = tokens1.cast<Map<String, dynamic>>();

    tasks.forEach((obj) {
      if (obj['first_name'] != null) {
        Participant p = Participant(id: obj['id'], name: obj['first_name'], username: obj['username'], imageUrl: obj['profile_pic']);
        print(obj);
        setState(() => allUsers.add(p));
      }
    });

    tasks1.forEach((obj) {
      if (obj['first_name'] != null) {
        Participant p = Participant(id: obj['id'], name: obj['first_name'], username: obj['username'], imageUrl: obj['profile_pic']);
        print(obj);
        setState(() => champions.add(p));
      }
    });

    tasks2.forEach((obj) {
      if (obj['first_name'] != null) {
        Participant p = Participant(id: obj['id'], name: obj['first_name'], username: obj['username'], imageUrl: obj['profile_pic']);
        print(obj);
        setState(() => backers.add(p));
      }
    });

    print(allUsers);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _pickImage() async {
    if (selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed')),
      );
      return;
    }

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.campaign.title;
    final String description = widget.campaign.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fundraising Target',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'How much are you trying to fundraise?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number, // Ensures numeric keyboard
                inputFormatters: [
                  NumberTextInputFormatter(), // Custom formatter for comma separation and digit-only input
                ],
                decoration: InputDecoration(
                  labelText: "N",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      '20% service charge will be applied to total amount raised',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.deepOrange,
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: const Text('ADD BILL LISTING'),
              //   ),
              // ),
              const SizedBox(height: 24),
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Starting Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDateField(_startDateController, 'DD/MM/YYYY'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ending Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDateField(_endDateController, 'DD/MM/YYYY'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Upload Images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload at least one image or a square',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // First box - always shows add icon (main image)
                  _buildImageUploadButton(0, true),
                  const SizedBox(width: 12),
                  // Second box
                  _buildImageUploadButton(1, false),
                  const SizedBox(width: 12),
                  // Third box
                  _buildImageUploadButton(2, false),
                  const SizedBox(width: 12),
                  // Fourth box
                  _buildImageUploadButton(3, false),
                   const SizedBox(width: 12),
                  // Fourth box
                  _buildImageUploadButton(4, false),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Please use images of yourself or your cause and not images that might infringe copyright when used.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Team section with avatars + delete + add more button or add member button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Add one or more people to manage your goal, add updates and respond to comments',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              selectedParticipants.isEmpty
                  ? GestureDetector(
                onTap: () {
                  _showAddTeamMemberBottomSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.teal,

                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Team Member',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(
                height: 60,
                width: (selectedParticipants.length * 40) + 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: selectedParticipants.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Participant user = entry.value;
                    return Positioned(
                      left: idx * 40.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(user.imageUrl),
                          ),
                          // Delete button on avatar top-right
                          Positioned(
                            left: -8,
                            top: -8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedParticipants.removeAt(idx);
                                });
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                    ..add(
                      // Add more button next to avatars
                      Positioned(
                        left: selectedParticipants.length * 40.0,
                        child: GestureDetector(
                          onTap: () {
                            _showAddTeamMemberBottomSheet(context);
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.grey, size: 28),
                          ),
                        ),
                      ),
                    ),
                ),
              ),

              const SizedBox(height: 24),



              Row(
  children: [
    Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 18,
      ),
    ),
    const SizedBox(width: 8),
    const Text(
      'Visibility',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
const SizedBox(height: 4),
const Text(
  'who can see this post',
  style: TextStyle(
    fontSize: 12,
    color: Colors.grey,
  ),
),




              const SizedBox(height: 12),
              SizedBox(
  width: double.infinity,
  child: OutlinedButton(
    onPressed: () {
      _showCustomizeBottomSheet(context);  // Add this line
    },
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(color: const Color.fromARGB(255, 216, 139, 14)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: const Text(
      'CUSTOMISE',
      style: TextStyle(
        color: Color.fromARGB(255, 216, 139, 14),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    String to = amountController.text;
                    String cleanStr = to.replaceAll(',', '');

                    double result = double.parse(cleanStr);
                    print(result);
                    print(selectedParticipants);
                    print(selectedImages);
                    widget.campaign.setCampaignDetails(
                      _startDateController.text,
                      _endDateController.text,
                      selectedImages[0],
                      result,
                      selectedParticipants,
                      selectedImages
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Reviewstartcampaign3(
                          campaign: widget.campaign
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('REVIEW & POST'),
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      },
    );
  }

  Widget _buildImageUploadButton(int index, bool isMain) {
    // Check if we have an image at this index
    bool hasImage = index < selectedImages.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: hasImage ? null : _pickImage,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: isMain ? Colors.teal : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: hasImage
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                selectedImages[index],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )
                : Center(
              child: Icon(
                Icons.add_circle_outline,
                color: isMain ? Colors.teal : Colors.grey.shade400,
                size: 24,
              ),
            ),
          ),
        ),
        // Delete button positioned outside on top-right
        if (hasImage)
          Positioned(
            right: -8,
            top: -8,
            child: GestureDetector(
              onTap: () => _deleteImage(index),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddTeamMemberBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create Team',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRoleCard(
                    context,
                    icon: 'https://i.postimg.cc/QtRkSW5F/host.png',
                    role: 'Select Host',
                    peopleCount: selectedParticipants.length,
                    onTap: () {
                      Navigator.pop(context);
                      _showUserSelectionBottomSheet(context);
                    },
                  ),
                  _buildRoleCard(
                    context,
                    icon: 'https://i.postimg.cc/gJwHvKwq/chanpion.png',
                    role: 'Select Champions',
                    peopleCount: 4,
                    onTap: () {
                      Navigator.pop(context);
                      _showUserSelectionBottomSheet(context);
                    },
                  ),
                  _buildRoleCard(
                    context,
                    icon: 'https://i.postimg.cc/ydwXnS9J/backer.png',
                    role: 'Select Backers',
                    peopleCount: 4,
                    onTap: () {
                      Navigator.pop(context);
                      _showUserSelectionBottomSheet(context);
                    },
                  ),
                 
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('ADD',
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required String icon,
        required String role,
        required int peopleCount,
        VoidCallback? onTap,
      }) {
    String roleLower = role.split(' ').last.toLowerCase();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue.shade100,
                    backgroundImage: NetworkImage(icon),
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    role,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/${index + 10}.jpg',
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$peopleCount People added as $roleLower',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.manage_search, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Add Offers',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showCustomizeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( // Add this Row wrapper
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Center(
            child: Text(
              'Customise Campaign',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        IconButton( // Add this close button
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildCustomizeOption(
                          icon: '💰',
                          title: 'Suggest Donation amount',
                          subtitle: "Enter the amount you'd like others to consider giving.",
                          hasToggle: false,
                        ),
                        _buildCustomizeOption(
                          icon: '🌐',
                          title: 'Show Contributions',
                          subtitle: null,
                          hasToggle: true,
                          toggleValue: true,
                          onToggleChanged: (val) {
                            setModalState(() {
                              // Handle toggle
                            });
                          },
                        ),
                        _buildCustomizeOption(
                          icon: '💬',
                          title: 'Allow Comments',
                          subtitle: null,
                          hasToggle: true,
                          toggleValue: true,
                          onToggleChanged: (val) {
                            setModalState(() {
                              // Handle toggle
                            });
                          },
                        ),
                        _buildCustomizeOption(
                          icon: '👥',
                          title: 'Allow Co-Campaigning',
                          subtitle: 'Supporters can start a mini campaign under yours to rally more donations.',
                          hasToggle: true,
                          toggleValue: true,
                          onToggleChanged: (val) {
                            setModalState(() {
                              // Handle toggle
                            });
                          },
                        ),
                        _buildCustomizeOption(
                          icon: '🌐',
                          title: 'Make Discoverable',
                          subtitle: 'Your listing will appear in search results, allowing more users to find and interact with it.',
                          hasToggle: true,
                          toggleValue: true,
                          onToggleChanged: (val) {
                            setModalState(() {
                              // Handle toggle
                            });
                          },
                        ),
                        _buildCustomizeOption(
                          icon: '📣',
                          title: 'Allow Champions',
                          subtitle: 'Allow others to champion your campaign and help spread the word.',
                          hasToggle: true,
                          toggleValue: true,
                          onToggleChanged: (val) {
                            setModalState(() {
                              // Handle toggle
                            });
                          },
                        ),
                        _buildCustomizeOption(
                          icon: '⭐',
                          title: 'Set Conditions & Rewards',
                          subtitle: 'Encourage donations by offering special rewards or experiences.',
                          hasToggle: false,
                        ),
                        _buildCustomizeOption(
                          icon: '❤️',
                          title: 'Set "Thank You" Message',
                          subtitle: 'Send a personal message to thank supporters after they contribute.',
                          hasToggle: false,
                          onTap: () {
    _showThankYouMessageBottomSheet(context);
  },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildCustomizeOption({
  required String icon,
  required String title,
  String? subtitle,
  bool hasToggle = false,
  bool toggleValue = false,
  Function(bool)? onToggleChanged,
   VoidCallback? onTap, // Add this parameter
}) {
  return GestureDetector( // Added this wrapper
    onTap: hasToggle ? null : onTap, // Added this
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasToggle)
            Switch(
              value: toggleValue,
              onChanged: onToggleChanged,
              activeColor: Colors.teal,
            ),
        ],
      ),
    ),
  );
}


void _showThankYouMessageBottomSheet(BuildContext context) {
  final TextEditingController messageController = TextEditingController();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SizedBox( // Add SizedBox to control height
              height: MediaQuery.of(context).size.height * 0.7, // Adjust height (70% of screen)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add close button
                  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Expanded(
      child: Center(
        child: Text(
          'Set "Thank You" Message',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    ),

    // Close button on the right
    IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
    ),
  ],
),
                  const SizedBox(height: 8),
                  Text(
                    'Send a personal message to thank supporters after they contribute.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Icons row
                  Row(
                    children: [
                      _buildIconButton('🔔', () {}),
                      const SizedBox(width: 12),
                      _buildIconButton('🎉', () {}),
                      const SizedBox(width: 12),
                      _buildIconButton('❤️', () {}),
                      const SizedBox(width: 12),
                      _buildIconButton('🎨', () {}),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Insert URL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Message text field
                  Expanded( // Wrap TextField in Expanded to take remaining space
                    child: TextField(
                      controller: messageController,
                      maxLines: 6, // Changed from 6 to null
                      
                      decoration: InputDecoration(
                        hintText: 'Type your thank you message here...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle saving the message
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}










Widget _buildIconButton(String emoji, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    ),
  );
}


  void _showUserSelectionBottomSheet(BuildContext context) {
  List<Participant> filteredUsers = List.from(allUsers);
  List<Participant> tempSelectedParticipants = List.from(selectedParticipants);
  TextEditingController searchController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Keeps it scroll-controlled for custom height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          void _filterUsers(String query) {
            setModalState(() {
              filteredUsers = allUsers.where((user) {
                return user.name.toLowerCase().contains(query.toLowerCase()) ||
                    user.username.toLowerCase().contains(query.toLowerCase());
              }).toList();
            });
          }

          bool isSelected(Participant user) {
            return tempSelectedParticipants.contains(user);
          }

          void toggleSelection(Participant user) {
            setModalState(() {
              if (isSelected(user)) {
                tempSelectedParticipants.remove(user);
              } else {
                tempSelectedParticipants.add(user);
              }
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: SizedBox(  // Added SizedBox to constrain height to 75%
<<<<<<< Updated upstream
              height: MediaQuery.of(context).size.height * 0.87,
=======
              height: MediaQuery.of(context).size.height * 0.85,
>>>>>>> Stashed changes
              child: Column(
                mainAxisSize: MainAxisSize.min,  // This can stay, but the SizedBox will enforce the height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Participant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tempSelectedParticipants.length,
                      itemBuilder: (context, index) {
                        final participant = tempSelectedParticipants[index];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(participant.imageUrl),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Positioned(
                              right: -8,
                              top: -8,
                              child: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    tempSelectedParticipants.remove(participant);
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  DefaultTabController(
                    length: 5,
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          tabs: const [
                            Tab(text: 'Followers'),
                            Tab(text: 'Champions'),
                            Tab(text: 'Backers'),
                            Tab(text: 'Groups'),
                            Tab(text: 'Organization'),
                          ],
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.grey,
                        ),
                        SizedBox(
                          height: 450,
                          child: TabBarView(
                            children: List.generate(5, (_) {
                              return Column(
                                children: [
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: searchController,
                                    onChanged: (val) => _filterUsers(val),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: 'Search',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredUsers.length,
                                      itemBuilder: (context, idx) {
                                        final user = filteredUsers[idx];
                                        final selected = isSelected(user);
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(user.imageUrl),
                                          ),
                                          title: Text(user.name),
                                          subtitle: Text(user.username),
                                          trailing: ElevatedButton(
                                            onPressed: () {
                                              toggleSelection(user);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: selected ? Colors.grey : Colors.teal,
                                            ),
                                            child: Text(selected ? 'Selected' : 'Select'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedParticipants = List.from(tempSelectedParticipants);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('ADD PARTICIPANTS'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}

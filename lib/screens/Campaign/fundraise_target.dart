import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'reviewstartcampaign3.dart';
import '../../class/campaign.dart';
import '../../class/participants.dart';
import '../../class/api_service.dart';


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

  List<Participant> allUsers = [ ];

  @override
  void initState() {
    super.initState();
    loadUsers();

  }

  Future<void> loadUsers() async {
    dynamic token = await ApiService().getUsers() ;
    List<Map<String, dynamic>> tasks = token.cast<Map<String, dynamic>>();

    tasks.forEach((obj) {


      if(obj['first_name'] != null)
        {
        Participant p = new Participant(id: obj['id'], name: obj['first_name'], username: obj['username'], imageUrl: obj['profile_pic']);
        print(p);
        setState(() => allUsers.add(p));

    }

    });

    //setState(() => allUsers = tasks.cast<Participant>());
    print(allUsers);
    await Future.delayed(const Duration(seconds: 2));

    //setState(() => categories = tasks);
  }

  Future<void> _pickImage() async {
    if (selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 images allowed')),
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('ADD BILL/THING'),
                ),
              ),
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
                    'Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Add up to 3 people to manage your goal, add updates and respond to comments',
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
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Visibility',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CUSTOMIZE',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.campaign.setCampaignDetails(
                      _startDateController.text,
                      _endDateController.text,
                      selectedImages[0],
                      amountController.text,
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
              const SizedBox(height: 24),
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
                    icon: 'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-host-festival-flaticons-lineal-color-flat-icons.png',
                    role: 'Select Host',
                    peopleCount: selectedParticipants.length,
                    onTap: () {
                      Navigator.pop(context);
                      _showUserSelectionBottomSheet(context);
                    },
                  ),
                  _buildRoleCard(
                    context,
                    icon: 'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-champion-sports-flaticons-lineal-color-flat-icons.png',
                    role: 'Select Champions',
                    peopleCount: 254,
                    onTap: null,
                  ),
                  _buildRoleCard(
                    context,
                    icon: 'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-backers-crowdfunding-flaticons-lineal-color-flat-icons.png',
                    role: 'Select Backers',
                    peopleCount: 78,
                    onTap: null,
                  ),
                  _buildRoleCard(
                    context,
                    icon: 'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/64/external-shorty-party-flaticons-lineal-color-flat-icons.png',
                    role: 'Select Shorty',
                    peopleCount: 6,
                    onTap: null,
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
                      child: const Text('ADD'),
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

  void _showUserSelectionBottomSheet(BuildContext context) {
    List<Participant> filteredUsers = List.from(allUsers);
    List<Participant> tempSelectedParticipants = List.from(selectedParticipants);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Participant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tempSelectedParticipants.length,
                      itemBuilder: (context, index) {
                        final participant = tempSelectedParticipants[index];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(participant.imageUrl),
                              ),
                            ),
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
                          height: 250,
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
            );
          },
        );
      },
    );
  }
}
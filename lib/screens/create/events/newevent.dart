import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class EventStartPage extends StatefulWidget {
  const EventStartPage({Key? key}) : super(key: key);

  @override
  State<EventStartPage> createState() => _EventStartPageState();
}

class _EventStartPageState extends State<EventStartPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1 variables
  String? _selectedRole;
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  String _selectedCountryCode = '+1';

  // Step 2 variables
  final _eventNameController = TextEditingController();
  String? _selectedCategory;
  File? _bannerImage;
  final _guestCountController = TextEditingController();

  // Step 3 variables
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedPayment;

  final List<String> _eventCategories = [
    'Wedding',
    'Birthday',
    'Corporate',
    'Conference',
    'Party',
    'Other'
  ];

  final List<String> _countryCodes = [
    '+1',
    '+44',
    '+91',
    '+234',
    '+86',
    '+81'
  ];

  final List<String> _paymentOptions = [
    'Pay Now',
    'Pay Later',
    'Pay on Event Day'
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _bannerImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your role')),
        );
        return false;
      }
      if (_selectedRole == 'Event Planner') {
        if (_ownerNameController.text.isEmpty ||
            _ownerPhoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please fill in owner details')),
          );
          return false;
        }
      }
    } else if (_currentStep == 1) {
      if (_eventNameController.text.isEmpty ||
          _selectedCategory == null ||
          _guestCountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return false;
      }
    } else if (_currentStep == 2) {
      if (_selectedDate == null ||
          _selectedTime == null ||
          _selectedPayment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields')),
        );
        return false;
      }
    }
    return true;
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        _createEvent();
      }
    }
  }

  void _createEvent() {
    // Handle event creation logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Event created successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Role',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioListTile<String>(
          title: const Text('Owner'),
          value: 'Owner',
          groupValue: _selectedRole,
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
              _ownerNameController.clear();
              _ownerPhoneController.clear();
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Event Planner'),
          value: 'Event Planner',
          groupValue: _selectedRole,
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
        ),
        if (_selectedRole == 'Event Planner') ...[
          const SizedBox(height: 24),
          const Text(
            'Owner Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ownerNameController,
            decoration: const InputDecoration(
              labelText: 'Owner Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    isExpanded: true,
                    items: _countryCodes.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryCode = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _ownerPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Owner Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _eventNameController,
          decoration: const InputDecoration(
            labelText: 'Name of Event',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.event),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Event Category',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          items: _eventCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Event Banner',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: _bannerImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _bannerImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to upload banner image'),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _guestCountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Guests',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.people),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Schedule & Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Date of Event'),
          subtitle: Text(
            _selectedDate != null
                ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                : 'Select date',
          ),
          leading: const Icon(Icons.calendar_today),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
          onTap: _selectDate,
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Time of Event'),
          subtitle: Text(
            _selectedTime != null
                ? _selectedTime!.format(context)
                : 'Select time',
          ),
          leading: const Icon(Icons.access_time),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
          onTap: _selectTime,
        ),
        const SizedBox(height: 24),
        const Text(
          'Payment Option',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ..._paymentOptions.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() {
                _selectedPayment = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (index < 2) const SizedBox(width: 4),
                    ],
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Step ${_currentStep + 1} of 3',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: _currentStep == 0
                    ? _buildStep1()
                    : _currentStep == 1
                        ? _buildStep2()
                        : _buildStep3(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentStep < 2 ? 'Next' : 'Create Event'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _eventNameController.dispose();
    _guestCountController.dispose();
    super.dispose();
  }
}

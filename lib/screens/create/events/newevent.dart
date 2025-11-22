import 'package:flutter/material.dart';

class EventCreationPage extends StatefulWidget {
  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String eventName = '';
  String description = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String location = '';
  String category = '';
  List<String> tags = [];

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitEvent() {
    // Handle submission logic here, e.g., save to database or API
    print('Event Created: $eventName, $description, $selectedDate, $selectedTime, $location, $category, $tags');
    // Navigate back or show success
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildStep5(),
              ],
            ),
          ),
          _buildNavigationButtons(),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Basic Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Event Name'),
            onChanged: (value) => eventName = value,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
            onChanged: (value) => description = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Date & Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
            child: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.toLocal()}'.split(' ')[0]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) setState(() => selectedTime = picked);
            },
            child: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Location'),
            onChanged: (value) => location = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Category & Tags', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Category'),
            onChanged: (value) => category = value,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Tags (comma separated)'),
            onChanged: (value) => tags = value.split(',').map((e) => e.trim()).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 5: Review & Submit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Name: $eventName'),
          Text('Description: $description'),
          Text('Date: ${selectedDate?.toLocal()}'),
          Text('Time: ${selectedTime?.format(context)}'),
          Text('Location: $location'),
          Text('Category: $category'),
          Text('Tags: ${tags.join(', ')}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitEvent,
            child: Text('Create Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: _previousPage,
              child: Text('Previous'),
            ),
          if (_currentPage < 4)
            ElevatedButton(
              onPressed: _nextPage,
              child: Text('Next'),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
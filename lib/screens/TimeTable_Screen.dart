import 'package:flutter/material.dart';


class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDayIndex = 0;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final Map<String, List<Map<String, String>>> _scheduleData = {
    'Mon': [
      {
        'subject': 'Mathematics',
        'time': '9:00 - 10:30',
        'location': 'Room 101',
        'color': '0xFF0D47A1'
      },
      {
        'subject': 'Physics',
        'time': '11:00 - 12:30',
        'location': 'Lab A',
        'color': '0xFF00796B'
      },
      {
        'subject': 'Chemistry',
        'time': '2:30 - 4:00',
        'location': 'Lab B',
        'color': '0xFF66BB6A'
      },
    ],
    'Tue': [
      {
        'subject': 'English',
        'time': '10:00 - 11:00',
        'location': 'Room 202',
        'color': '0xFF8E24AA'
      },
    ],
    'Wed': [],
    'Thu': [],
    'Fri': [],
    'Sat': [],
    'Sun': [],
  };

  @override
  Widget build(BuildContext context) {
    String selectedDay = _days[_selectedDayIndex];
    List<Map<String, String>> todaySchedule = _scheduleData[selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubtitle(),
            const SizedBox(height: 12),
            _buildDaysRow(),
            const SizedBox(height: 20),
            Text(
              '${_days[_selectedDayIndex]} Schedule',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: todaySchedule.isEmpty
                  ? const Center(
                child: Text(
                  'No classes scheduled for this day',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: todaySchedule.length,
                itemBuilder: (context, index) {
                  final item = todaySchedule[index];
                  return _buildScheduleCard(
                    subject: item['subject']!,
                    time: item['time']!,
                    location: item['location']!,
                    color: Color(int.parse(item['color']!)),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildWeeklyOverview(),
          ],
        ),
      ),
    );
  }





  Widget _buildSubtitle() {
    return const Text(
      'Manage your weekly schedule',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
    );
  }







  Widget _buildDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_days.length, (index) {
        bool isSelected = index == _selectedDayIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDayIndex = index;
            });
          },
          child: Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  _days[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }





  Widget _buildScheduleCard({
    required String subject,
    required String time,
    required String location,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          )
        ],
      ),
    );
  }




  Widget _buildWeeklyOverview() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOverviewItem('18', 'Total Hours', Colors.blue.shade50),
          _buildOverviewItem('12', 'Classes', Colors.green.shade50),
        ],
      ),
    );
  }





  Widget _buildOverviewItem(String number, String label, Color bgColor) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

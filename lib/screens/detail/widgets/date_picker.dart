import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final weekList = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> dayList = [];
  var selected = DateTime.now().weekday - 1;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _generateDays();
  }

  void _generateDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      dayList.add(day.day.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // swipe from left to right (previous week)
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _pageController.previousPage(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
          // swipe from right to left (next week)
          else if (details.velocity.pixelsPerSecond.dx > 0) {
            _pageController.nextPage(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            // calculate the date for the current week
            final now = DateTime.now();
            final monday = now.subtract(Duration(days: now.weekday - 1));
            final currentWeekMonday = monday.add(Duration(days: 7 * index));
            // generate the dayList for the current week
            final currentWeekDays = <String>[];
            for (var i = 0; i < 7; i++) {
              final day = currentWeekMonday.add(Duration(days: i));
              currentWeekDays.add(day.day.toString());
            }
            return Row(
              children: [
                ...List.generate(
                  weekList.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() => selected = index),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selected == index
                            ? Colors.grey.withOpacity(0.1)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            weekList[index],
                            style: TextStyle(
                              color: selected == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            currentWeekDays[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selected == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: 10, // limit the number of pages to 10 weeks
        ),
      ),
    );
  }
}

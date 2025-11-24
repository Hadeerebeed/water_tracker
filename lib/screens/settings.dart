import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  final int currentCups;
  final int dailyGoal;

  const SettingsPage({
    super.key,
    required this.currentCups,
    required this.dailyGoal,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Box box;
  late TextEditingController goalController;
  late int currentCups;
  late int dailyGoal;

  @override
  void initState() {
    super.initState();
    box = Hive.box('waterBox');

    currentCups = widget.currentCups;
    dailyGoal = widget.dailyGoal;

    goalController = TextEditingController(text: dailyGoal.toString());
  }

  void updateGoal(int newGoal) {
    setState(() {
      dailyGoal = newGoal;

      if (currentCups > dailyGoal) {
        currentCups = dailyGoal;
        box.put('currentCups', currentCups);
      }

      box.put('dailyGoal', dailyGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 44, 92, 131),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "الإعدادات",
            style: TextStyle(
              color: Color.fromARGB(255, 44, 92, 131),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "تحديد الهدف اليومي للأكواب",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 44, 92, 131),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              cursorColor: Colors.blue,
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "عدد الأكواب",
                labelStyle: const TextStyle(color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onChanged: (value) {
                int newGoal = int.tryParse(value) ?? dailyGoal;
                updateGoal(newGoal);
              },
            )
          ],
        ),
      ),
    );
  }
}

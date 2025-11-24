import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'settings.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late Box box;
  int currentCups = 0;
  int dailyGoal = 8;

  @override
  void initState() {
    super.initState();
    box = Hive.box('waterBox');

    currentCups = box.get('currentCups', defaultValue: 0);
    dailyGoal = box.get('dailyGoal', defaultValue: 8);
  }

  void addCup() {
    setState(() {
      currentCups++;

      if (currentCups >= dailyGoal) {
        currentCups = dailyGoal;

        box.put('currentCups', currentCups);

        // إظهار رسالة تشجيع
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("!أحسنت"),
            content: const Text(
                "لقد حققت هدف شرب المياه لليوم! استمر في الحفاظ على صحتك  "),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "حسنًا",
                  style: TextStyle(
                    color: Color.fromARGB(255, 44, 92, 131),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        box.put('currentCups', currentCups);
      }
    });
  }

  void resetCups() {
    setState(() {
      currentCups = 0;
      box.put('currentCups', 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentCups / dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Water Tracker",
          style: TextStyle(
              color: Color.fromARGB(255, 44, 92, 131),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 44, 92, 131),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsPage(
                    currentCups: currentCups,
                    dailyGoal: dailyGoal,
                  ),
                ),
              );

              setState(() {
                currentCups = box.get('currentCups');
                dailyGoal = box.get('dailyGoal');
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // دائرة العداد
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // دائرة التقدم الخارجية
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: CircularProgressIndicator(
                        value: value, // القيمة المتحركة
                        strokeWidth: 14,
                        strokeCap: StrokeCap.round, // حواف دائرية
                        backgroundColor: Colors.blue[50],
                        valueColor: const AlwaysStoppedAnimation(
                          Color.fromARGB(255, 62, 125, 177),
                        ),
                      ),
                    ),

                    // الدائرة الداخلية 3D
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(-6, -6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: const Color.fromARGB(255, 133, 186, 228)
                                .withOpacity(0.7),
                            offset: const Offset(6, 6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "$currentCups / $dailyGoal أكواب",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 26, 96, 152),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // الزر الرئيسي
            ElevatedButton(
              style: ButtonStyle(),
              onPressed: addCup,
              child: const Text(
                "إضافة كوب ماء",
                style: TextStyle(
                  color: Color.fromARGB(255, 44, 92, 131),
                ),
              ),
            ),

            const SizedBox(height: 100),

            // زر Reset
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 44, 92, 131),
              ),
              onPressed: resetCups,
              child: const Text(
                "إعادة التعيين",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

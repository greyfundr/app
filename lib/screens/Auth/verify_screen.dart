import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers =
        List.generate(6, (_) => TextEditingController());

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter the 6-digit code sent to your phone",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  child: TextField(
                    controller: controllers[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  String code =
                      controllers.map((c) => c.text).join();
                  if (code.length == 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Code entered: $code")));
                  }
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}

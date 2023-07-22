import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 23, 59, 179)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('חפש את המשלוח שלך'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'הכנס מס משלוח',
                      ),
                      onSubmitted: (value) {
                        sendNumber(value, context);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        sendNumber(
                            '1234', context); // דוגמה לשליחת מספר קבוע לשרת
                      },
                      child: const Text('חפש'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendNumber(String number, BuildContext context) async {
    final String serverUrl = 'http://10.0.0.22:8080';

    final url = Uri.parse('$serverUrl/get_status?number=$number');
    final http.Response httpResponse = await http.get(url);

    if (httpResponse.statusCode == 200) {
      final data = jsonDecode(httpResponse.body);
      final status = data['status'];

      if (status != null) {
        final title = status['title'];
        final description = status['description'];

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('סטטוס משלוח'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('הכותרת: $title'),
                  const SizedBox(height: 10),
                  Text('התיאור: $description'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('סגור'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(context);
      }

      clearTextField();
    } else {
      print('שגיאה בשליחת המספר');
      showErrorDialog(context);
    }
  }

  void clearTextField() {
    // ניקוי הטקסט של הקלט
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('שגיאה'),
          content: const Text('אירעה שגיאה בשליחת המספר.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('סגור'),
            ),
          ],
        );
      },
    );
  }
}

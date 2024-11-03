import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart'; // Import the DatabaseHelper class

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dreams Journal"),
        backgroundColor: const Color(0xFF2E1A47),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseHelper.fetchDreams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final dreams = snapshot.data!;
          if (dreams.isEmpty) {
            return const Center(child: Text("No dreams saved yet."));
          }
          return ListView.builder(
            itemCount: dreams.length,
            itemBuilder: (context, index) {
              final dream = dreams[index];
              return ListTile(
                title: Text(dream['title']),
                subtitle: Text(formatDate(dream['date'])),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 3,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A2E),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dream['title'],
                                style: const TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                dream['content'],
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    "Close",
                                    style:
                                        TextStyle(color: Colors.purpleAccent),
                                  ),
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
            },
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat('MM/dd/yyyy').format(parsedDate);
  }
}

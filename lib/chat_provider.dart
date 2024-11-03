import 'dart:convert';

import 'package:dream_analysis/chat_message.dart';
import 'package:dream_analysis/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'env.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ChatMessage> chatMessages = [
    ChatMessage(text: "Hello, welcome to the AI Dream Analyzer!", isUser: false)
  ];
  String _selectedAnalysis = 'Freudian'; // Default selected analysis

  String get selectedAnalysis => _selectedAnalysis;

  set selectedAnalysis(String value) {
    _selectedAnalysis = value;
    notifyListeners(); // Notify listeners when the analysis type changes
  }

  TextEditingController messageController = TextEditingController();

  void sendMessage(String dreamDescription) async {
    chatMessages.add(ChatMessage(text: dreamDescription, isUser: true));
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Env.apiKey.trim()}',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "temperature": 0.7,
        'messages': getFormattedMessages(dreamDescription),
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      chatMessages.add(ChatMessage(
          text: jsonResponse['choices'][0]['message']['content'].trim(),
          isUser: false));
      chatMessages.add(ChatMessage(
          text: 'How to Sleep Better', isUser: false, isButton: true));
    } else {
      print(response.statusCode);
      chatMessages.add(ChatMessage(
          text: 'Error retrieving dream analysis. Please try again.',
          isUser: false));
    }

    notifyListeners();
  }

  List<Map<String, String>> getFormattedMessages(String dreamDescription) {
    List<Map<String, String>> formattedMessages = [];
    for (var msg in chatMessages) {
      formattedMessages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.text,
      });
    }

    String analysisPrompt =
        'I had this dream: "$dreamDescription", please provide me a $selectedAnalysis Dream Analysis of the dream and explain the key symbols.';

    formattedMessages.add({'role': 'user', 'content': analysisPrompt});
    return formattedMessages;
  }

  void showSaveDialog(BuildContext context, ChatMessage message) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Dream"),
          content: TextField(
            controller: titleController,
            decoration:
                const InputDecoration(hintText: "Enter a title for this dream"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _databaseHelper.saveDream(
                    titleController.text, message.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dream saved to journal!")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

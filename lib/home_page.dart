import 'package:dream_analysis/chat_provider.dart';
import 'package:dream_analysis/env.dart';
import 'package:dream_analysis/journal_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    print(Env.apiKey);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1A47),
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.book, color: Colors.purpleAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JournalScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Choose analysis type',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Freudian'),
                  selected: chatProvider.selectedAnalysis == 'Freudian',
                  onSelected: (selected) {
                    if (selected) {
                      chatProvider.selectedAnalysis = 'Freudian';
                    }
                  },
                  selectedColor: Colors.purpleAccent,
                ),
                ChoiceChip(
                  label: const Text('Jungian'),
                  selected: chatProvider.selectedAnalysis == 'Jungian',
                  onSelected: (selected) {
                    if (selected) {
                      chatProvider.selectedAnalysis = 'Jungian';
                    }
                  },
                  selectedColor: Colors.purpleAccent,
                ),
                ChoiceChip(
                  label: const Text('Gestalt'),
                  selected: chatProvider.selectedAnalysis == 'Gestalt',
                  onSelected: (selected) {
                    if (selected) {
                      chatProvider.selectedAnalysis = 'Gestalt';
                    }
                  },
                  selectedColor: Colors.purpleAccent,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.chatMessages.length,
              itemBuilder: (context, index) {
                final msg = chatProvider.chatMessages[index];
                if (msg.isButton) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showTipsDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                          ),
                          child: Text(
                            msg.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: msg.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? const Color(0xFF3A1A5E)
                                  : const Color(0xFF2E1A47),
                              border: Border.all(
                                color: Colors.purpleAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                if (!msg.isUser &&
                                    msg.text !=
                                        "Hello, welcome to the AI Dream Analyzer!")
                                  IconButton(
                                    icon: const Icon(Icons.bookmark,
                                        color: Colors.purpleAccent),
                                    onPressed: () {
                                      chatProvider.showSaveDialog(context, msg);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatProvider.messageController,
                    decoration: const InputDecoration(
                      hintText: 'Describe your dream...',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purpleAccent, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purpleAccent, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (chatProvider.messageController.text.isNotEmpty) {
                      chatProvider
                          .sendMessage(chatProvider.messageController.text);
                      chatProvider.messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.purpleAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showTipsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(
            color: Colors.purpleAccent,
            width: 3,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400, // Set a max width for the dialog
            maxHeight: 250, // Set a max height for the dialog
          ),
          child: Container(
            color: const Color(0xFF1A1A2E),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Tips for Better Sleep",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        "1. Maintain a regular sleep schedule.\n"
                        "2. Avoid caffeine and heavy meals close to bedtime.\n"
                        "3. Practice relaxation techniques before bed.\n"
                        "4. Limit screen time in the evening.\n"
                        "5. Ensure a comfortable sleep environment.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

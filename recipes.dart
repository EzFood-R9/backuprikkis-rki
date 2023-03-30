import 'dart:async';

import 'package:flutter/material.dart';
import 'readrecipes.dart';
import 'src/widgets.dart';
import 'app_state.dart';

class recipes extends StatefulWidget {
  const recipes({
    super.key,
    required this.addMessage,
    required this.messages,
  });

  final FutureOr<void> Function(String message) addMessage;
  final List<ReadRecipes> messages;

  @override
  State<recipes> createState() => _recipesBookState();
}

class _recipesBookState extends State<recipes> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_recipesBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a messagessss',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),

                
                for (var message in widget.messages)
                  Paragraph('${message.name}: ${message.instructions}'),
                const SizedBox(height: 8),



                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.instructions}'),
          
        const SizedBox(height: 8),
      ],
    );
  }
}

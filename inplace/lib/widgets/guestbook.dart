import "dart:async";

import "package:flutter/material.dart";
import "package:inplace/widgets/widgets.dart";

import "../utils/guestbookMessage.dart";

class GuestBook extends StatefulWidget {
  const GuestBook({
    super.key,
    required this.addMessage,
    required this.messages,
  });
  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: "_GuestBookState");
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
                // Leave a message in the guestbook
                // Fields of the message are regulated in applicationState.dart file
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Leave a message",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your message to continue";
                      }
                      return null;
                    },
                  ),
                ),
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
                      Text("SEND"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Scrollbar(
              thickness: 10, //width of scrollbar
              radius: Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right,
              child: ListView(
                children: [
                  for (var message in widget.messages)
                    Container(
                        width: 1000,
                        margin: const EdgeInsets.all(2),
                        child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                                margin: const EdgeInsets.all(5),
                                child: Paragraph(
                                  "${message.name}: ${message.message}",
                                )))),
                ],
              )),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

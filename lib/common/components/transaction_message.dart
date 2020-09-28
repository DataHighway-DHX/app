import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionMessage extends StatelessWidget {
  final String message;

  const TransactionMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          bottom: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message.split('#,')[0] + '#,',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: message.split('#,')[1],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.content_copy),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: message,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';

class Message {
  final bool isUser;
  final String message;

  Message({
    required this.isUser,
    required this.message,
  });
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
          color: isUser ? Colors.red : const Color.fromARGB(255, 232, 144, 143),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.grey[300],
            backgroundImage: isUser
                ? NetworkImage(PreferenceUtils.getUserImage()) as ImageProvider
                : AssetImage('assets/images/Group.png') as ImageProvider,
          ),
          Text(
            message,
            style: TextStyle(
                fontSize: 16, color: isUser ? Colors.white : Colors.white),
          ),
        ],
      ),
    );
  }
}

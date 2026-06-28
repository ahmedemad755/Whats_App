
import 'package:flutter/material.dart';
import 'package:whatsapp/features/chat/data/models/chat_model.dart';
import 'package:whatsapp/features/chat/presentation/widgets/ButtonCard.dart';
import 'package:whatsapp/features/chat/presentation/widgets/ContactCard.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(name: "Dev Stack", status: "A full stack developer", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []),
      ChatModel(name: "Balram", status: "Flutter Developer...........", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Saket", status: "Web developer...", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: [] ),
      ChatModel(name: "Bhanu Dev", status: "App developer....", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Collins", status: "Raect developer..", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Kishor", status: "Full Stack Web", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Testing1", status: "Example work", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Testing2", status: "Sharing is caring", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: [] ),
      ChatModel(name: "Divyanshu", status: ".....", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Helper", status: "Love you Mom Dad", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: []  ),
      ChatModel(name: "Tester", status: "I find the bugs", id: '', avatarUrl: '', lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0, isOnline: false, messages: [] ),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "256 contacts",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: contacts.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {

                  },
                  child: ButtonCard(
                    icon: Icons.group,
                    name: "New group",
                  ),
                );
              } else if (index == 1) {
                return ButtonCard(
                  icon: Icons.person_add,
                  name: "New contact",
                );
              }
              return ContactCard(contact: contacts[index - 2]);
                
            
            }));
  }
}
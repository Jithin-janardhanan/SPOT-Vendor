import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot/vendor/screens/chatscreen.dart';

class VendorChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentVendorId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Messages'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_rooms')
            .where('participants', arrayContains: currentVendorId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!.docs;

          if (chatRooms.isEmpty) {
            return const Center(child: Text('No messages yet'));
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index].data() as Map<String, dynamic>;
              final participantDetails =
                  chatRoom['participantDetails'] as Map<String, dynamic>;

              // Get the customer's details
              final customerId = (chatRoom['participants'] as List)
                  .firstWhere((id) => id != currentVendorId);
              final customerData = participantDetails[customerId];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    customerData['name'][0].toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(customerData['name']),
                subtitle: Text(
                  chatRoom['lastMessage'] ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chatRoom['lastMessageTime'] != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                          chatRoom['lastMessageTime'].millisecondsSinceEpoch,
                        ).toString().substring(11, 16)
                      : '',
                ),
                onTap: () {
                  final customerData = {
                    'customerId': customerId,
                    'name': participantDetails[customerId]['name'],
                    'email': participantDetails[customerId]['email'],
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VendorChatScreen(customerData: customerData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

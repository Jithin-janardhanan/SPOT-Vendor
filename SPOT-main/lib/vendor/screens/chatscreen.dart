import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorChatScreen extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const VendorChatScreen({Key? key, required this.customerData})
      : super(key: key);

  @override
  _VendorChatScreenState createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? currentVendorId;
  String? currentVendorEmail;
  String? currentVendorName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVendorData();
  }

  Future<void> _initializeVendorData() async {
    try {
      final vendor = FirebaseAuth.instance.currentUser;
      if (vendor != null) {
        currentVendorId = vendor.uid;

        // Fetch vendor details from vendor_reg collection
        final vendorDoc = await FirebaseFirestore.instance
            .collection('vendor_reg')
            .doc(currentVendorId)
            .get();

        if (vendorDoc.exists && mounted) {
          setState(() {
            currentVendorName =
                vendorDoc.data()?['name'] as String? ?? 'Vendor';
            currentVendorEmail = vendorDoc.data()?['email'] as String? ?? '';
            isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            currentVendorName = 'Vendor';
            currentVendorEmail = '';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error initializing vendor data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty ||
        currentVendorId == null ||
        currentVendorEmail == null) {
      return;
    }

    try {
      final customerId = widget.customerData['customerId'] as String?;
      final customerEmail = widget.customerData['email'] as String?;

      if (customerId == null ||
          customerId.isEmpty ||
          customerEmail == null ||
          customerEmail.isEmpty) {
        throw Exception('Invalid customer data');
      }

      // Create chat room ID using emails to ensure consistency
      final List<String> roomParticipants = [currentVendorEmail!, customerEmail]
        ..sort();
      final String chatRoomId = roomParticipants.join('_');

      // First, check if participantDetails are valid
      final participantDetails = {
        currentVendorId!: {
          'name': currentVendorName ?? 'Vendor',
          'email': currentVendorEmail,
          'role': 'vendor'
        },
        customerId: {
          'name': widget.customerData['name'] ?? 'Customer',
          'email': customerEmail,
          'role': 'user'
        }
      };

      // Create message document
      final messageData = {
        'senderId': currentVendorId,
        'senderName': currentVendorName,
        'receiverId': customerId,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Batch write to ensure both operations succeed or fail together
      final batch = FirebaseFirestore.instance.batch();

      // Add message
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .doc();
      batch.set(messageRef, messageData);

      // Update chat room
      final chatRoomRef =
          FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId);
      batch.set(
          chatRoomRef,
          {
            'lastMessage': _messageController.text.trim(),
            'lastMessageTime': FieldValue.serverTimestamp(),
            'participants': [currentVendorId, customerId],
            'participantDetails': participantDetails,
          },
          SetOptions(merge: true));

      // Commit the batch
      await batch.commit();

      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get the chat room ID
    final customerEmail = widget.customerData['email'] as String? ?? '';
    final List<String> roomParticipants = [
      currentVendorEmail ?? '',
      customerEmail
    ]..sort();
    final String chatRoomId = roomParticipants.join('_');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customerData['name'] as String? ?? 'Chat',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe = messageData['senderId'] == currentVendorId;
                    final message = messageData['message'] as String? ?? '';
                    final timestamp = messageData['timestamp'] as Timestamp?;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timestamp != null
                                      ? _formatTimestamp(timestamp)
                                      : '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final String hours = dateTime.hour.toString().padLeft(2, '0');
    final String minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

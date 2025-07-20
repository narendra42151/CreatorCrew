import 'package:creatorcrew/Brand/Dashboard/Screens/ChatDetailScreen.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/MessageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().fetchChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FDF4),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF22C55E)),
            );
          }

          if (messageProvider.chatRooms.isEmpty) {
            return _buildEmptyState();
          }

          return _buildChatList(messageProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFF22C55E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Color(0xFF22C55E),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF166534),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start accepting applications to begin conversations',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(MessageProvider messageProvider) {
    return RefreshIndicator(
      onRefresh: () => messageProvider.fetchChatRooms(),
      color: Color(0xFF22C55E),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: messageProvider.chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = messageProvider.chatRooms[index];
          return _buildChatItem(chatRoom);
        },
      ),
    );
  }

  Widget _buildChatItem(ChatRoom chatRoom) {
    return Container(
      //  margin: EdgeInsets.symmetric(vertical: 100, horizontal: 16),
      margin: EdgeInsets.only(top: 72),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Color(0xFFDCFCE7)),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(chatRoom: chatRoom),
            ),
          );
        },
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: Text(
              chatRoom.influencerName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(
          chatRoom.influencerName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF166534),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF22C55E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                chatRoom.campaignTitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF22C55E),
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              chatRoom.lastMessage.isNotEmpty
                  ? chatRoom.lastMessage
                  : 'Start the conversation',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chatRoom.lastMessageTime != null
                  ? _formatTime(chatRoom.lastMessageTime!)
                  : '',
              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

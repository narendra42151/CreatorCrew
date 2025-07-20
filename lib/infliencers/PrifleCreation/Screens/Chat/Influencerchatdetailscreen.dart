import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluenceMessageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfluencerChatDetailScreen extends StatefulWidget {
  final InfluencerChatRoom chatRoom;

  const InfluencerChatDetailScreen({Key? key, required this.chatRoom})
    : super(key: key);

  @override
  _InfluencerChatDetailScreenState createState() =>
      _InfluencerChatDetailScreenState();
}

class _InfluencerChatDetailScreenState
    extends State<InfluencerChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when opening chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InfluencerMessageProvider>().markMessagesAsRead(
        widget.chatRoom.id,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FDF4),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildQuickResponses(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.chatRoom.brandName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatRoom.brandName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.chatRoom.campaignTitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showAvailabilityDialog(),
          icon: Icon(Icons.schedule, color: Colors.white),
          tooltip: 'Send Availability',
        ),
        IconButton(
          onPressed: () => _showCampaignInfo(),
          icon: Icon(Icons.info_outline, color: Colors.white),
          tooltip: 'Campaign Info',
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
        ),
      ),
      child: StreamBuilder<List<InfluencerMessage>>(
        stream: context.read<InfluencerMessageProvider>().getMessagesStream(
          widget.chatRoom.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF22C55E)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading messages'));
          }

          final messages = snapshot.data ?? [];

          if (messages.isEmpty) {
            return _buildEmptyMessages();
          }

          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe =
                  message.senderId ==
                  context.read<InfluencerMessageProvider>().currentUserId;
              return _buildMessageBubble(message, isMe);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Color(0xFF22C55E).withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Start the conversation!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF166534),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Send a message to ${widget.chatRoom.brandName}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(InfluencerMessage message, bool isMe) {
    final isAcceptanceMessage = message.messageType == 'acceptance';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  message.senderName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isMe
                        ? Color(0xFF22C55E)
                        : isAcceptanceMessage
                        ? Color(0xFF3B82F6).withOpacity(0.1)
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border:
                    isAcceptanceMessage
                        ? Border.all(color: Color(0xFF3B82F6).withOpacity(0.3))
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAcceptanceMessage)
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'APPLICATION ACCEPTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    message.message,
                    style: TextStyle(
                      color:
                          isMe
                              ? Colors.white
                              : isAcceptanceMessage
                              ? Color(0xFF1D4ED8)
                              : Color(0xFF374151),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatMessageTime(message.timestamp),
                    style: TextStyle(
                      color:
                          isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickResponses() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickResponseChip('Thank you!', '🙏'),
          _buildQuickResponseChip('I\'m interested', '✨'),
          _buildQuickResponseChip('Available for meeting', '📅'),
          _buildQuickResponseChip('Can we discuss details?', '💬'),
          _buildQuickResponseChip('What are the next steps?', '⏭️'),
        ],
      ),
    );
  }

  Widget _buildQuickResponseChip(String text, String emoji) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          _messageController.text = '$emoji $text';
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFDCFCE7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji),
              SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: Color(0xFF166534),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(width: 12),
            Consumer<InfluencerMessageProvider>(
              builder: (context, provider, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: provider.isSending ? null : _sendMessage,
                    icon:
                        provider.isSending
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Icon(Icons.send, color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    final success = await context.read<InfluencerMessageProvider>().sendMessage(
      chatRoomId: widget.chatRoom.id,
      receiverId: widget.chatRoom.brandId,
      receiverName: widget.chatRoom.brandName,
      message: message,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder:
          (context) => _AvailabilityDialog(
            onSend: (availability, format) async {
              final success = await context
                  .read<InfluencerMessageProvider>()
                  .sendAvailabilityResponse(
                    chatRoomId: widget.chatRoom.id,
                    receiverId: widget.chatRoom.brandId,
                    receiverName: widget.chatRoom.brandName,
                    availability: availability,
                    preferredFormat: format,
                  );

              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Availability sent successfully!'),
                    backgroundColor: Color(0xFF22C55E),
                  ),
                );
              }
            },
          ),
    );
  }

  void _showCampaignInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Campaign Information'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campaign: ${widget.chatRoom.campaignTitle}'),
                SizedBox(height: 8),
                Text('Brand: ${widget.chatRoom.brandName}'),
                SizedBox(height: 8),
                Text(
                  'Chat Started: ${_formatMessageTime(widget.chatRoom.createdAt)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

// Availability Dialog Widget
class _AvailabilityDialog extends StatefulWidget {
  final Function(String availability, String format) onSend;

  const _AvailabilityDialog({required this.onSend});

  @override
  _AvailabilityDialogState createState() => _AvailabilityDialogState();
}

class _AvailabilityDialogState extends State<_AvailabilityDialog> {
  final TextEditingController _availabilityController = TextEditingController();
  String _selectedFormat = 'Video Call';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share Your Availability'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _availabilityController,
            decoration: InputDecoration(
              labelText: 'Available times',
              hintText: 'e.g., Monday-Friday 2-5 PM, Weekend mornings',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedFormat,
            decoration: InputDecoration(
              labelText: 'Preferred meeting format',
              border: OutlineInputBorder(),
            ),
            items:
                ['Video Call', 'Phone Call', 'In-Person', 'Any']
                    .map(
                      (format) =>
                          DropdownMenuItem(value: format, child: Text(format)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFormat = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_availabilityController.text.trim().isNotEmpty) {
              widget.onSend(
                _availabilityController.text.trim(),
                _selectedFormat,
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF22C55E)),
          child: Text('Send Availability'),
        ),
      ],
    );
  }
}

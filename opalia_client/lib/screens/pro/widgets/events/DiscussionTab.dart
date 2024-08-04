import 'package:flutter/material.dart';
import 'package:opalia_client/models/discussion.dart';
import 'package:opalia_client/screens/pro/widgets/events/discussion/DiscusionItem.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import '../../../../models/events.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../../../services/remote/websocketService.dart';
import '../../../client/widgets/Allappwidgets/constant.dart';

class DiscussionTab extends StatefulWidget {
  final Events event;
  const DiscussionTab({super.key, required this.event});

  @override
  State<DiscussionTab> createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {
  List<Discussion>? allDiscussion;
  bool isLoading = true;
  bool isParticipant = false;
  late WebSocketService _webSocketService;

  Future<void> _fetchDiscussion() async {
    try {
      final discussion =
          await ApiServicePro.getAllDiscussionbyEvent(widget.event.EventId!);
      setState(() {
        allDiscussion = discussion;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch discussion: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkParticipation() async {
    try {
      final userId = await PreferenceUtils.getuserid();
      print('User ID: $userId'); // Debug print
      final participantStatus =
          await ApiServicePro.isParticipant(userId, widget.event.EventId!);
      print('Participant Status: $participantStatus'); // Debug print
      setState(() {
        isParticipant = participantStatus;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to check participation: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  late TextEditingController TextController;
  final _formKey = GlobalKey<FormState>();

  Future<void> _addDiscussion(String newCommentText) async {
    try {
      await ApiServicePro.postDiscussion(
        newCommentText,
        PreferenceUtils.getuserid(),
        widget.event.EventId,
      );
      _webSocketService.send('new_discussion', {
        'subject': newCommentText,
        'author': PreferenceUtils.getuserid(),
        'eventId': widget.event.EventId,
      });
      _fetchDiscussion();
      TextController.clear();
    } catch (e) {
      print('Failed to add Discussion: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _webSocketService.socket.on('new_discussion', (data) {
      if (data['eventId'] == widget.event.EventId!) {
        _fetchDiscussion();
      }
    });

    _checkParticipation();
    _fetchDiscussion();
    TextController = TextEditingController();
  }

  @override
  void dispose() {
    TextController.dispose();
    _webSocketService.reconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : !isParticipant
              ? Center(
                  child: Text(
                    "S'il vous plaiez participer à l'événement pour pouvoir discuter",
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                        child: allDiscussion == null || allDiscussion!.isEmpty
                            ? Center(child: Text('No Discussions'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: allDiscussion?.length,
                                itemBuilder: (context, index) {
                                  final discu = allDiscussion![index];
                                  return DiscussionItem(discu: discu);
                                },
                              )),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter a comment";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: TextController,
                                autofocus: false,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: kBorderRadius),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: kBorderRadius),
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  hintText: "Write a comment",
                                  fillColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _addDiscussion(TextController.text);
                              }
                            },
                            icon: Icon(Icons.arrow_circle_up_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

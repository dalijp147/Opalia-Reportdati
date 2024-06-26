import 'package:flutter/material.dart';
import 'package:opalia_client/models/discussion.dart';
import 'package:opalia_client/screens/pro/widgets/events/discussion/DiscusionItem.dart';

import '../../../../models/events.dart';
import '../../../../services/remote/apiServicePro.dart';
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

  Future<void> _fetchDiscussion() async {
    try {
      final discussion =
          await ApiServicePro.getAllDiscussionbyEvent(widget.event.EventId!);
      setState(
        () {
          allDiscussion = discussion;
          isLoading = false;
        },
      );
    } catch (e) {
      print('Failed to fetch discussion: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  late TextEditingController TextController;
  final _formKey = GlobalKey<FormState>();
  Future<void> _addDiscussion(String newCommentText) async {
    // Example: Adding new comment
    try {
      // Call your API to add the new comment
      await ApiServicePro.postDiscussion(
        newCommentText,
        "66754d2525c9be414693c2e9",
        widget.event.EventId,
      );

      // After successfully adding, fetch the updated list
      _fetchDiscussion(); // This will refresh the page automatically
      TextController.clear();
    } catch (e) {
      print('Failed to add Discussion: $e');
      // Handle error if needed
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDiscussion();
    TextController = TextEditingController();
  }

  @override
  void dispose() {
    TextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : allDiscussion == null || allDiscussion!.isEmpty
                    ? Center(child: Text('pas de Discussion'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: allDiscussion?.length,
                        itemBuilder: (context, index) {
                          final discu = allDiscussion![index];

                          return DiscussionItem(discu: discu);
                        },
                      ),
          ),
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
                          return "veullez saisire une avis";
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
                        hintText: "ecrire un avis",
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

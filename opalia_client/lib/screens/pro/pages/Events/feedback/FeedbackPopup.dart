import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../../models/events.dart';

class FeedbackPopup extends StatefulWidget {
  final String event;

  FeedbackPopup({required this.event});

  @override
  _FeedbackPopupState createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> {
  final _formKey = GlobalKey<FormState>();
  String? _comment;
  double _rating = 0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter votre Feedback'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Commentaire',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a comment';
                }
                return null;
              },
              onSaved: (value) {
                _comment = value;
              },
            ),
            SizedBox(height: 16),
            Text('Rating'),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    setState(() {
                      _isSubmitting = true;
                    });
                    bool success = await ApiServicePro.postFeedback(
                      _comment!,
                      _rating.toInt().toString(),
                      PreferenceUtils.getuserid(),
                      widget.event!,
                    );
                    setState(() {
                      _isSubmitting = false;
                    });
                    if (success) {
                      Navigator.of(context).pop();
                    } else {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add feedback')),
                      );
                    }
                  }
                },
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}

void showFeedbackPopup(
  BuildContext context,
  String event,
) {
  showDialog(
    context: context,
    builder: (context) => FeedbackPopup(event: event),
  ).then((newFeedback) {
    if (newFeedback != null) {
      // Handle the new feedback
      print('Feedback submitted: $newFeedback');
    }
  });
}

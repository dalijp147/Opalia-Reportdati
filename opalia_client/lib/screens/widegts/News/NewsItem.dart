import 'package:flutter/material.dart';
import 'package:opalia_client/models/news.dart';
import 'package:intl/intl.dart';

import '../../../bloc/news/bloc/news_bloc.dart';

class NewsItem extends StatefulWidget {
  final News model;

  const NewsItem({super.key, required this.model});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  var formatter = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Image.network(
              widget.model.newsImage!,
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: 150,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              height: 200,
              width: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 45,
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      widget.model.newsTitle!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    'poster le : ${formatter.format(widget.model.newsPublication!)}',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

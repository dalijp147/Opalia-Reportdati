import 'package:flutter/material.dart';
import 'package:opalia_client/models/news.dart';

class DetailNews extends StatefulWidget {
  final News news;

  const DetailNews({super.key, required this.news});

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.favorite_border),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.share_outlined)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    image: NetworkImage(
                      // categorie.categorieImage!,
                      // height: 50,
                      // width: 50,
                      widget.news.newsImage!
                          .replaceFirst("file:///", "http://"),
                    ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.news.newsTitle!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('author'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.news.newsDetail!,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          )
        ],
      ),
    );
  }
}

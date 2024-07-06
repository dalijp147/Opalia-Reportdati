import 'package:flutter/material.dart';

class DatailRelatednews extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  const DatailRelatednews(
      {super.key,
      required this.image,
      required this.name,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            // onPressed: () async {
            //   await HiveService.writeDataFavorite(
            //     {
            //       "namenews": widget.news.newsTitle,
            //       "isnews": widget.news.newsId,
            //       "newsImage": widget.news.newsImage,
            //       "newsDate": widget.news.newsPublication,
            //       "random": randomNumber
            //     },
            //   );
            // },
            icon: Icon(
              Icons.favorite,
              //  _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              // setState(
              //   () {
              //     //boxFavorite.get
              //     _isFavorite = !_isFavorite;
              //   },
              // );

              // if (_isFavorite) {
              //   await HiveService.writeDataFavorite(
              //     {
              //       "namenews": widget.news.newsTitle,
              //       "isnews": widget.news.newsId,
              //       "newsImage": widget.news.newsImage,
              //       "newsDate": widget.news.newsPublication,
              //       "random": randomNumber,
              //       "favorite": true
              //     },
              //   );
              // } else {
              //   await HiveService.deleteDataFavoriteone(widget.news.newsId);
              // }
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  image!.replaceFirst("file:///", "http://"),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description!,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ]),
      ),
    );
  }
}

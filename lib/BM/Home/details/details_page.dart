import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.post});
  final PostModel post;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Spacer(flex: 1),
          Text(
            "                         Dateils",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          Spacer(flex: 1),
          Text(DateFormat("yyyy-MM-dd   ").format(widget.post.date)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.post.url == "")
              SizedBox()
            else
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${widget.post.url}"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LikeButton(
                    isLiked: widget.post.likes.contains(cisco),
                    likeCount: widget.post.likes.length,
                    onTap: (isLiked) async {
                      final postref = FirebaseFirestore.instance
                          .collection("updates")
                          .doc(widget.post.id);
                      if (isLiked) {
                        await postref.update({
                          "likes": FieldValue.arrayRemove([cisco]),
                        });
                      } else {
                        await postref.update({
                          "likes": FieldValue.arrayUnion([cisco]),
                        });
                      }
                      return !isLiked;
                    },
                    likeBuilder: (isLiked) {
                      return Icon(
                        Icons.favorite,
                        size: 30,
                        color: isLiked ? AppTheme.primaryColor : Colors.grey,
                      );
                    },
                  ),

                  Spacer(flex: 1),
                  Text(
                    widget.post.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.post.description),
            ),
          ],
        ),
      ),
    );
  }
}

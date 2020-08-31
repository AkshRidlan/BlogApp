import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc;
  bool _isLoading = false;
  File _image;
  final picker = ImagePicker();
  CrudMethods crudMethods = new CrudMethods();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  uploadBlog() async {
    setState(() {
      _isLoading = true;
    });

    if (_image != null) {
      ///uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("BlogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("This is url $downloadUrl");
      Map<String, String> blogMap = {
        "imageurl": downloadUrl,
        "authorName": authorName,
        "title": title,
        "desc": desc
      };
      crudMethods.adddata(blogMap).then((result) => Navigator.pop(context));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            "Your",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "Blog",
            style: TextStyle(fontSize: 22, color: Colors.blue),
          ),
        ]),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: _image != null
                        ? Container(
                            height: 170,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(_image, fit: BoxFit.cover),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          )),
                SizedBox(
                  height: 8,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Description"),
                          onChanged: (val) {
                            desc = val;
                          },
                        )
                      ],
                    )),
              ],
            )),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/services/crud.dart';
import 'package:flutter_blog/views/create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

  Stream blogStream;
  Widget BlogList() {
    return Container(
        child: blogStream != null
            ? Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: blogStream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BlogTile(
                              authorName: snapshot
                                  .data.documents[index].data['authorName'],
                              title:
                                  snapshot.data.documents[index].data['title'],
                              description:
                                  snapshot.data.documents[index].data['desc'],
                              imgurl:
                                  snapshot.data.documents[index].data['imgurl'],
                            );
                          });
                    },
                  )
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ));
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogStream = result;
      });
    });
    super.initState();
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
      ),
      body: BlogList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imgurl, title, description, authorName;
  BlogTile(
      {@required this.imgurl,
      @required this.title,
      @required this.description,
      @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 170,
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imgurl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )),
          Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(authorName)
              ],
            ),
          )
        ],
      ),
    );
  }
}

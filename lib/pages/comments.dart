import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/variables.dart';
import 'package:timeago/timeago.dart' as Tago;

class CommentsPage extends StatefulWidget {
  final String id;
  CommentsPage(this.id);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  String uid;
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //to get uid from the firebase
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  publishcomment() async {
    //to get uid so we know who post it
    DocumentSnapshot userdoc = await usercollection.doc(uid).get();
    //to get all the information
    var alldocs =
        await videoscollection.doc(widget.id).collection('comments').get();
    //to get length of all doc
    int length = alldocs.docs.length;
    videoscollection
        .doc(widget.id)
        .collection('comments')
        .doc('Comment $length')
        .set({
      'username': userdoc.data()['username'],
      'uid': uid,
      'profilepic': userdoc.data()['profilepic'],
      'comment': commentcontroller.text,
      'likes': [],
      'time': DateTime.now(),
      'id': 'Comment $length'
    });
    //to clear text form field
    commentcontroller.clear();
    //update comment count
    DocumentSnapshot doc = await videoscollection.doc(widget.id).get();
    videoscollection
        .doc(widget.id)
        .update({'commentcount': doc.data()['commentcount'] + 1});
  }

  likecomment(String id)async{
    DocumentSnapshot doc = await videoscollection.doc(widget.id).collection('comments').doc(id).get();
    if(doc.data()['likes'].contains(uid)){
      videoscollection.doc(widget.id).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }
    else{
      videoscollection.doc(widget.id).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Expanded(
              //to get realtime comments
              child: StreamBuilder(
                stream: videoscollection
                    .doc(widget.id)
                    .collection('comments')
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  //if snapshot  doesnt contain any data
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  //if contain data
                  //listview builder if we contain more than one lists
                  return ListView.builder(

                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot comment = snapshot.data.docs[index];
                        return Card(
                          elevation: 5.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                              NetworkImage(comment.data()['profilepic']),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex:0,
                                  child: Text(
                                    "${comment.data()['username']}",
                                    style: mystyle(
                                        15, Colors.black, FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,

                                ),
                                Expanded(
                                  child: Text(
                                    "${comment.data()['comment']}",
                                    style: mystyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                )
                                //TODO:when comments gets over a line it gives error
                              ],
                              ),
                            subtitle: Row(
                              children: [
                                Text(
                                    "${Tago.format(comment.data()['time'].toDate())}"),
                                SizedBox(
                                  width: 10.0,
                                  height: 2.0,

                                ),
                                //TODO:error in showing likes after 4-5 comments
                                Padding(
                                  padding: const EdgeInsets.only(top:3.0),
                                  child: Text('${comment.data()['likes'].length}likes'),
                                )
                              ],
                            ),
                            trailing: InkWell(
                                onTap: ()=>likecomment(comment.data()['id']) ,
                                //check if user already liked or not
                                child: comment.data()['likes'].contains(uid)
                                    ? Icon(
                                  Icons.favorite,
                                  size: 25,
                                  color: Colors.red,
                                )
                                    : Icon(
                                  Icons.favorite_border,
                                  size: 25,
                                )),
                          ),
                        );
                      });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: commentcontroller,
                decoration: InputDecoration(
                    labelText: "Comment",
                    labelStyle: mystyle(20, Colors.black, FontWeight.w700),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
              trailing: OutlineButton(
                onPressed: () => publishcomment(),
                borderSide: BorderSide.none,
                child: Icon(
                  Icons.send,
                  color: Colors.pink,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

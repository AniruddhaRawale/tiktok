import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/pages/comments.dart';
import 'package:tiktok_final/variables.dart';
import 'package:tiktok_final/widgets/circle_animation.dart';
import 'package:video_player/video_player.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  Stream mystream;
  String uid;

  initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    mystream = videoscollection.snapshots();
  }

  buildprofile(String url) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
              left: (60 / 2) - (50 / 2),
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            left: (60 / 2) - (20 / 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildmusicalbum(String url) {
    return Container(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.grey[800], Colors.grey[700]]),
                borderRadius: BorderRadius.circular(25.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  //to like a video
  //to like our own video we have to get the uid first
  //to like a video we must have to remove the uid if its already liked
  //else we have to add the uid if its not liked earlier
  likevideo(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    DocumentSnapshot doc = await videoscollection.doc(id).get();
    if (doc.data()['likes'].contains(uid)) {
      videoscollection.doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      videoscollection.doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  //to share video
  sharevideo(String video, String id) async {
    //to ask for uid video
    var request = await HttpClient().getUrl(Uri.parse(video));
    //to close the request
    var response = await request.close();
    //to convert video into bytes
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    //to share the app/video
    await Share.file("FlikTok", 'Video.mp4', bytes, 'Video/mp4');
    //to increase the share count
    //to get video uid
    DocumentSnapshot doc = await videoscollection.doc(id).get();
    //to  update share count
    videoscollection
        .doc(id)
        .update({'sharecount': doc.data()['sharecount'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      //streambuilder is used to get real time data
      body: StreamBuilder(
          stream: mystream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            }

            return PageView.builder(
                //to get all the data (videos) for showing
                itemCount: snapshot.data.docs.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  //to get all the video from firebase
                  DocumentSnapshot videos = snapshot.data.docs[index];

                  return Stack(
                    children: [
                      //to access videos from firebase
                      VideoPlayerItem(videos.data()['videourl']),

                      Column(
                        //top section
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Following",
                                  style: mystyle(
                                      17, Colors.white, FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15.00,
                                ),
                                Text(
                                  "For You",
                                  style: mystyle(
                                      17, Colors.white, FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          //middle section
                          Expanded(
                              child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Container(
                                height: 70,
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      //to get username from firebase
                                      videos.data()['username'],
                                      style: mystyle(
                                          15, Colors.white, FontWeight.bold),
                                    ),
                                    Text(
                                      //to get vcaption from firebase
                                      videos.data()['caption'],
                                      style: mystyle(
                                          15, Colors.white, FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          //to get songnme from firebase
                                          videos.data()['songname'],
                                          style: mystyle(15, Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              //right section
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        12),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildprofile(videos.data()['profilepic']),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              likevideo(videos.data()['id']),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 45,
                                            color: videos
                                                    .data()['likes']
                                                    .contains(uid)
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          videos
                                              .data()['likes']
                                              .length
                                              .toString(),
                                          style: mystyle(20, Colors.white),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () => Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=> CommentsPage(videos.data()['id']))),
                                          child: Icon(
                                            Icons.comment,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          videos.data()['commentcount'].toString(),
                                          style: mystyle(20, Colors.white),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () => sharevideo(
                                            videos.data()['videourl'],
                                            videos.data()['id'],
                                          ),
                                          child: Icon(
                                            Icons.reply,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          videos
                                              .data()['sharecount']
                                              .toString(),
                                          style: mystyle(20, Colors.white),
                                        ),
                                      ],
                                    ),
                                    CircleAnimation(buildmusicalbum(
                                        videos.data()['profilepic']))
                                  ],
                                ),
                              )
                            ],
                          )),
                        ],
                      )
                    ],
                  );
                });
          }),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videourl;
  VideoPlayerItem(this.videourl);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController videoPlayerController;

  //to initialize video player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videourl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose(){
    super.dispose();
    videoPlayerController.dispose();
  }

  //to design video player size
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: VideoPlayer(videoPlayerController),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_final/variables.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

class ConfirmPage extends StatefulWidget {
  final File videofile;
  final String videopath_astring;
  final ImageSource imageSource;

  ConfirmPage(this.videofile, this.videopath_astring, this.imageSource);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  VideoPlayerController controller;
  bool isuploading = false;
  TextEditingController musicontroller = TextEditingController();
  TextEditingController captioncontroller = TextEditingController();
  FlutterVideoCompress fluttervideocompress = FlutterVideoCompress();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  //to dispose and avoid memory leakage
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  //to cmpress video
  compressvideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videofile;
    } else {
      final compressedvideo = await fluttervideocompress.compressVideo(
          widget.videopath_astring,
          quality: VideoQuality.MediumQuality);
      return File(compressedvideo.path);
    }
  }

  getpreviewimage()async{
    final previewimage = await fluttervideocompress.getThumbnailWithFile(
      widget.videopath_astring,
    );
    return previewimage;
  }

  //to upload to storage
  uploadvideotostorage(String id) async {
    StorageUploadTask storageUploadTask =
        videosfolder.child(id).putFile(await compressvideo());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get download url
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  uploadimagetostorage(String id) async {
    //to upload to storage
    StorageUploadTask storageUploadTask =
        imagesfolder.child(id).putFile(await getpreviewimage());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get download url
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  uploadvideo() async {

    setState(() {
      isuploading = true;
    });

    try{
      var firebaseuserid = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot userdoc = await usercollection.doc(firebaseuserid).get();
      var alldocs = await videoscollection.get();
      int length = alldocs.docs.length;
      String video = await uploadvideotostorage("Video $length");
      String previewimage = await uploadimagetostorage("Video $length");

      videoscollection.doc("Video $length").set({
        'username': userdoc.data()['username'],
        'uid': firebaseuserid,
        'profilepic': userdoc.data()['profilepic'],
        'id': "Video $length",
        'likes': [],
        'commentcount': 0,
        'sharecount': 0,
        'songname': musicontroller.text,
        'caption': captioncontroller.text,
        'videourl': video,
        'previewimage': previewimage
      });
      Navigator.pop(context);
    }catch(e){
      print(e);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isuploading == true? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
         Text("Uploading....",style: mystyle(25),),
            SizedBox(height: 20,),
            CircularProgressIndicator()
        ],
      ) ):SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: musicontroller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Song Name",
                          labelStyle: mystyle(20),
                          prefixIcon: Icon(Icons.music_note),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(right: 40),
                    child: TextField(
                      controller: captioncontroller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Captions",
                          labelStyle: mystyle(20),
                          prefixIcon: Icon(Icons.closed_caption),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () => uploadvideo(),
                    color: Colors.pinkAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Upload Video",
                        style: mystyle(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.pinkAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Another Video",
                        style: mystyle(20),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mystyle(double size ,[Color color, FontWeight fw = FontWeight.w700 ]){

  return GoogleFonts.montserrat(
    fontSize: size,
    color:color,
    fontWeight: fw
  );
}

//to create user collection
var usercollection = FirebaseFirestore.instance.collection("users");
var videoscollection = FirebaseFirestore.instance.collection("videos");
//to send videos to storage
StorageReference videosfolder = FirebaseStorage.instance.ref().child("Videos");
//to send video thumbnail to storage
StorageReference imagesfolder = FirebaseStorage.instance.ref().child("Images");


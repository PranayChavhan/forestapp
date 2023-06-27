import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forestapp/common/models/ConflictModel.dart';
import 'package:forestapp/screens/Admin/EditConflictScreen.dart';
import 'package:intl/intl.dart';

import '../User/ForestMapScreen.dart';

class ForestDetail extends StatefulWidget {
  ConflictModel forestData;
  final int currentIndex;
  final Function(int) changeIndex;
  final Function( ConflictModel ) deleteData;
  final Function( ConflictModel ) changeData;


  ForestDetail({
    Key? key,
    required this.forestData,
    required this.currentIndex,
    required this.changeIndex,
    required this.changeData,
    required this.deleteData
  }) : super(key: key);


  @override
  _ForestDetailState createState() => _ForestDetailState();
}

class _ForestDetailState extends State<ForestDetail> {
  void _changeData( ConflictModel newData ) {
    setState(() {
      widget.forestData = newData;
    });

    // also passing the value back to home screen
    widget.changeData( newData );
  }

  void _onItemTapped(int index) {
    widget.changeIndex( index );
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          height: 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
          ),
        ),
        title: const Text(
          'Forest Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Guard',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Forest Data',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.forestData.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: mediaQuery.size.height * 0.42,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.forestData.village_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.forestData.userImage),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.forestData.userName),
                            Text(widget.forestData.userEmail),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text( "Created At: " + DateFormat('MMM d, yyyy h:mm a').format(widget.forestData.datetime!.toDate()),),
                    SizedBox(height: 16),
                    Text( 'Latitude: ${widget.forestData.location.latitude}, Longitude: ${widget.forestData.location.longitude}'),
                    SizedBox(height: 16),
                    Text('Range: ${widget.forestData.range}'),
                    SizedBox(height: 16),
                    Text('Round: ${widget.forestData.round}'),
                    SizedBox(height: 16),
                    Text('Bt: ${widget.forestData.bt}'),
                    SizedBox(height: 16),
                    Text('C.No/S.No Name: ${widget.forestData.cNoName}'),
                    SizedBox(height: 16),
                    Text('Conflict: ${widget.forestData.conflict}'),
                    SizedBox(height: 16),
                    Text('Name: ${widget.forestData.person_name}'),
                    SizedBox(height: 16),
                    Text('Age: ${widget.forestData.person_age}'),
                    SizedBox(height: 16),
                    Text('Gender: ${widget.forestData.person_gender}'),
                    SizedBox(height: 16),
                    Text('Sp Causing Death: ${widget.forestData.sp_causing_death}'),
                    SizedBox(height: 16),
                    Text('Notes: ${widget.forestData.notes}'),
                    SizedBox(height: 16),
                    Text('Guard Contact: ${widget.forestData.userContact}'),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.green.shade400, // Background color
                    // Text Color (Foreground color)
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ForestMapScreen(
                          latitude: widget.forestData.location.latitude,
                          longitude: widget.forestData.location.longitude,
                          userName: widget.forestData.userName,
                          conflictName: widget.forestData.village_name,
                        ),
                      ),
                    );
                  },
                  label: const Text("Show on Map"),
                  icon: const Icon(Icons.arrow_right_alt_outlined),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red.shade400, // Background color
                    // Text Color (Foreground color)
                  ),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        final snapshot = await FirebaseFirestore.instance.collection('forestdata').doc(widget.forestData.id).get();

                        if (snapshot.exists) {
                          await snapshot.reference.delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User deleted successfully.'),
                            ),
                          );

                          Navigator.of(context).pop();

                          // updating on the parent screen
                          widget.deleteData( widget.forestData );

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User not found.'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting user: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Delete"),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.green.shade400, // Background color
                    // Text Color (Foreground color)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditConflict(
                              changeData: _changeData,
                              conflictData: widget.forestData,
                              currentIndex: widget.currentIndex,
                              changeIndex: widget.changeIndex,
                            ))
                    );

                  },
                  child: const Text("Edit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

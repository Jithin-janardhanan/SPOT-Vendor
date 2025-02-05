// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CharityRead extends StatefulWidget {
//   const CharityRead({super.key});

//   @override
//   State<CharityRead> createState() => _CharityReadState();
// }

// class _CharityReadState extends State<CharityRead> {
//   final currentUser = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     // Only fetch documents where userId matches current user's ID
//     final Query charityReq = FirebaseFirestore.instance
//         .collection('Charity_req')
//         .where('userId', isEqualTo: currentUser?.uid);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'My Charity Requests',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       body:

//        currentUser == null
//           ? const Center(child: Text('Please login to view your requests'))
//           : StreamBuilder(
//               stream: charityReq.snapshots(),
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Error: ${snapshot.error.toString()}'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                       child: Text('You have no charity requests'));
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(12.0),
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final DocumentSnapshot charitySnap =
//                         snapshot.data.docs[index];
//                     final String docId = charitySnap.id;

//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.volunteer_activism,
//                                     color: Colors.green),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   charitySnap['P_name'],
//                                   style: GoogleFonts.roboto(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               charitySnap['P_description'],
//                               style: GoogleFonts.roboto(fontSize: 16),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Contact Number : ${charitySnap['phone']}',
//                               style: GoogleFonts.roboto(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Quantity: ${charitySnap['quantity']}',
//                               style: GoogleFonts.roboto(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 ElevatedButton.icon(
//                                   onPressed: () => _confirmDelete(docId),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.redAccent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   icon: const Icon(Icons.delete,
//                                       color: Colors.white),
//                                   label: const Text(
//                                     'Delete Request',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),

//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );

//                   },
//                 );
//               },
//             ),
//     );
//   }

//   void _confirmDelete(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: const Text('Are you sure you want to delete this request?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _deleteRequest(docId);
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 232, 37, 7)),
//               child:
//                   const Text('Delete', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deleteRequest(String docId) async {
//     try {
//       // Additional security check before deletion
//       final doc = await FirebaseFirestore.instance
//           .collection('Charity_req')
//           .doc(docId)
//           .get();

//       if (doc.exists && doc.get('userId') == currentUser?.uid) {
//         await FirebaseFirestore.instance
//             .collection('Charity_req')
//             .doc(docId)
//             .delete();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Request deleted successfully!')),
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content:
//                     Text('You do not have permission to delete this request')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Failed to delete request. Please try again.')),
//         );
//       }
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spot/vendor/screens/vendorCharitypage.dart';

class CharityRead extends StatefulWidget {
  const CharityRead({super.key});

  @override
  State<CharityRead> createState() => _CharityReadState();
}

class _CharityReadState extends State<CharityRead> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Query charityReq = FirebaseFirestore.instance
        .collection('Charity_req')
        .where('userId', isEqualTo: currentUser?.uid);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'My Charity Requests',
          style: GoogleFonts.spaceMono(),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: currentUser == null
          ? const Center(child: Text('Please login to view your requests'))
          : StreamBuilder(
              stream: charityReq.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('You have no charity requests'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot charitySnap =
                        snapshot.data.docs[index];
                    final String docId = charitySnap.id;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.volunteer_activism,
                                  color: Color.fromARGB(255, 5, 62, 81),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  charitySnap['P_name'],
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              charitySnap['P_description'],
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Contact Number : ${charitySnap['phone']}',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Quantity: ${charitySnap['quantity']}',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _confirmDelete(docId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  label: const Text(
                                    'delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new page to add charity request
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorCharityPage(),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 5, 62, 81),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteRequest(docId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 37, 7)),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteRequest(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Charity_req')
          .doc(docId)
          .get();

      if (doc.exists && doc.get('userId') == currentUser?.uid) {
        await FirebaseFirestore.instance
            .collection('Charity_req')
            .doc(docId)
            .delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request deleted successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('You do not have permission to delete this request')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to delete request. Please try again.')),
        );
      }
    }
  }
}

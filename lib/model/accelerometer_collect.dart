// enum DocKeyAccelData {
//   email,
//   x,
//   y,
//   z,
//   timestamp,
// }

// class AccelerometerCollect {
//   String? docID;
//   String? email;
//   late DateTime? timestamp;
//   late double? x;
//   late double? y;
//   late double? z;
//   String? uid;

//   AccelerometerCollect(
//       {this.docID,
//       this.uid,
//       required this.email,
//       required this.timestamp,
//       required this.x,
//       required this.y,
//       required this.z});

//   Map<String, dynamic> toFirestoreDoc() {
//     return {
//       DocKeyAccelData.email.name: email,
//       DocKeyAccelData.timestamp.name: timestamp,
//       DocKeyAccelData.x.name: x,
//       DocKeyAccelData.y.name: y,
//       DocKeyAccelData.z.name: z,
//     };
//   }

//   factory AccelerometerCollect.fromFirestoreDoc(
//       {required Map<String, dynamic> doc,
//       required String docID,
//       required String uid}) {
//     return AccelerometerCollect(
//       docID: docID,
//       uid: uid,
//       email: doc[DocKeyAccelData.email.name] ??= '',
//       x: doc[DocKeyAccelData.x.name] ??= '',
//       y: doc[DocKeyAccelData.y.name] ??= '',
//       z: doc[DocKeyAccelData.z.name] ??= '',
//       timestamp: doc[DocKeyAccelData.timestamp.name] != null
//           ? DateTime.fromMillisecondsSinceEpoch(
//               doc[DocKeyAccelData.timestamp.name].millisecondsSinceEpoch,
//             )
//           : null,
//     );
//   }

//   static void uploadToFirestore(){
    
//   }
// }
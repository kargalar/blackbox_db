// import 'package:blackbox_db/2%20General/Widget/profile_picture.dart';
// import 'package:blackbox_db/2%20General/app_colors.dart';
// import 'package:flutter/material.dart';

// class ContentActivity extends StatelessWidget {
//   const ContentActivity({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // TODO: galiba burası için log model gibi birşey olacak
//     // activity type logdan alınacak şimdilik böyle
//     // bool isReview = true;
//     bool isConsumed = true;
//     bool isRated = true;
//     bool isAddWatchlist = true;
//     // bool isAddList;

//     return Positioned(
//       bottom: 0,
//       child: Container(
//         // height: 50,
//         width: 150,
//         color: AppColors.black.withOpacity(0.7),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             children: [
//               // if isReview review
//               const Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 2,
//                   vertical: 4,
//                 ),
//                 child: Text(
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet.",
//                   maxLines: 4,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   // profile picture
//                   const ProfileImage.content(
//                     imageUrl: "https://images.pexels.com/photos/29191749/pexels-photo-29191749/free-photo-of-traditional-farmer-in-rural-vietnamese-setting.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   // date
//                   const Text(
//                     "13 Oct",
//                     style: TextStyle(
//                       color: AppColors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   // if isRate
//                   if (isRated)
//                     const Row(
//                       children: [
//                         Text(
//                           "4",
//                           style: TextStyle(
//                             color: AppColors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 2),
//                         Icon(
//                           Icons.star,
//                           color: AppColors.white,
//                           size: 17,
//                         ),
//                       ],
//                     ),

//                   // if isWatch watch (if notRated)
//                   if (!isRated && isConsumed)
//                     const Icon(
//                       Icons.remove_red_eye,
//                       color: AppColors.white,
//                       size: 20,
//                     ),

//                   // if isAddWatchlist add to watchlist
//                   if (!isAddWatchlist)
//                     const Icon(
//                       Icons.watch_later,
//                       color: AppColors.white,
//                       size: 20,
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

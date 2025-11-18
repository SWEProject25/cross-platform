// import 'package:flutter/material.dart';

// class OtherProfileTabBar extends StatefulWidget {
//   final Function(int) onTabSelected;
//   final int selectedIndex;

//   const OtherProfileTabBar({
//     super.key,
//     required this.onTabSelected,
//     required this.selectedIndex,
//   });

//   @override
//   State<OtherProfileTabBar> createState() => _OtherProfileTabBarState();
// }

// class _OtherProfileTabBarState extends State<OtherProfileTabBar> {
//   final List<String> tabs = ['Posts', 'Replies', 'Media'];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         child: Row(
//           children: List.generate(tabs.length, (index) {
//             final isSelected = widget.selectedIndex == index;

//             return GestureDetector(
//               onTap: () => widget.onTabSelected(index),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       tabs[index],
//                       style: TextStyle(
//                         fontWeight:
//                             isSelected ? FontWeight.bold : FontWeight.normal,
//                         fontSize: 15,
//                         color: isSelected ? Colors.black : Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 6),

//                     /// MATCH X'S STYLE: underline matches text width
//                     if (isSelected)
//                       IntrinsicWidth(
//                         child: Container(
//                           height: 3,
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class OtherProfileTabBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const OtherProfileTabBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<OtherProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<OtherProfileTabBar> {
  final List<String> tabs = [
    'Posts',
    'Replies',
    'Media',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = widget.selectedIndex == index;
            return GestureDetector(
              onTap: () => widget.onTabSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                        color: isSelected ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isSelected)
                      Container(
                        height: 3,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

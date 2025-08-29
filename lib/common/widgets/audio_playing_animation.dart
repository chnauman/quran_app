// import 'package:flutter/material.dart';
// import 'package:flutter/animation.dart';

// class MusicVisualizerController {
//   late VoidCallback start;
//   late VoidCallback stop;
// }

// class MusicVisualizer extends StatelessWidget {
//   final int barCount;
//   final MusicVisualizerController controller;

//   const MusicVisualizer({
//     Key? key,
//     required this.controller,
//     this.barCount = 3,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(
//         barCount,
//         (index) => VisualComponent(
//           controller: controller,
//           duration:
//               500 + index * 200, // Slightly different durations for variety
//         ),
//       ),
//     );
//   }
// }

// class VisualComponent extends StatefulWidget {
//   final MusicVisualizerController controller;
//   final int duration;

//   const VisualComponent({
//     Key? key,
//     required this.controller,
//     required this.duration,
//   }) : super(key: key);

//   @override
//   _VisualComponentState createState() => _VisualComponentState();
// }

// class _VisualComponentState extends State<VisualComponent>
//     with SingleTickerProviderStateMixin {
//   late Animation<double> animation;
//   late AnimationController animationController;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.start = startAnimation;
//     widget.controller.stop = stopAnimation;
//     animationController = AnimationController(
//       duration: Duration(milliseconds: widget.duration),
//       vsync: this,
//     );
//     final curvedAnimation =
//         CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
//     animation = Tween<double>(begin: 10, end: 50).animate(curvedAnimation)
//       ..addListener(() {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   void startAnimation() {
//     animationController.repeat(reverse: true);
//   }

//   void stopAnimation() {
//     animationController.stop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 5,
//       height: animation.value,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5),
//       ),
//     );
//   }
// }

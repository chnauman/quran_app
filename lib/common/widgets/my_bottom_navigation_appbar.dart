// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_app/common/constants/color_pallate.dart';
// import 'package:quran_app/common/quran/domain/entity/current_playing.dart';
// import 'package:quran_app/features/favorites/presentation/pages/favorites_page.dart';
// import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

// class MyBottomNavigationAppBar extends StatefulWidget {
//   const MyBottomNavigationAppBar({
//     super.key,
//     required this.currentIndex,
//   });

//   final int currentIndex;

//   @override
//   State<MyBottomNavigationAppBar> createState() =>
//       _MyBottomNavigationAppBarState();
// }

// class _MyBottomNavigationAppBarState extends State<MyBottomNavigationAppBar> {
//   late int index;

//   @override
//   void initState() {
//     index = widget.currentIndex;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
//       builder: (context, state) {
//         return Scaffold(
//           body: ,
//           bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: ColorPallate.backGroundColor,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Favorites',
//             ),
//           ],
//           currentIndex: index,
//           onTap: (value) {
//             setState(() {
//               index = value;
//             });
//           },
//         )
//      ,
//         );
//       },
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:quran_app/features/qari_1/presentation/pages/qari_1_page.dart';
import 'package:quran_app/features/qari_2/presentation/pages/qari_2_page.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  var _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final tabs = [
    //   BottomNavigationBarItem(
    //       icon: Icon(CupertinoIcons.music_note_list),
    //       label: AppLocalizations.of(context)!.qari_1),
    //   BottomNavigationBarItem(
    //       icon:  Icon(CupertinoIcons.music_note_list),
    //       label: AppLocalizations.of(context)!.qari_2),
    //   BottomNavigationBarItem(
    //           icon: Icon(Icons.favorite),
    //           label: 'Favorites',
    //         ),

    // ];

    onTap(value) {
      if (_currentIndex != value) {
        _pageController.jumpToPage(value);
      }
      setState(() {
        _currentIndex = value;
      });
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onTap,
        children: const [
          Qari1Page(),
          Qari2Page(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorPallate.backGroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.music_note_list),
              label: AppLocalizations.of(context)!.qari_1),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.music_note_list),
              label: AppLocalizations.of(context)!.qari_2),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.bottom_navigation_favorites,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/features/favorites/presentation/widgets/favorites_stateless_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    // CurrentPlaying? currentPlaying = context.watch<CurrentPlayingCubit>().state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kIsWeb
                ? 'images/quran_main_screen_bg.jpg'
                : 'assets/images/quran_main_screen_bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: const Stack(
          children: [
            Column(
              children: [
                Expanded(child: FavoritesStateLessWidget()),
              ],
            ),
            // if (currentPlaying != null)
            //   const Positioned(bottom: 80, child: CurrentSurahPlayerPopUp()),
            // const MyBottomNavigationAppBar(
            //   currentIndex: 1,
            // ),
          ],
        ),
      ),
    );
  }
}

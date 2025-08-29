import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:quran_app/features/qari_1/presentation/pages/qari_1_page.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  var _currentIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  bool showAppBar = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final tabs = [
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.heart,
        ),
        label: 'Favorites'),
  ];

  onTap(value) {
    if (_currentIndex != value) {
      _pageController.jumpToPage(value);
    }
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentPlayingCubit, CurrentPlaying?>(
      listener: (context, state) {
        if (state != null) {
          if (state.showPopUpPlayer) {
            setState(() {
              showAppBar = true;
            });
            _animationController.forward();
          } else {
            setState(() {
              showAppBar = false;
            });
            _animationController.reverse();
          }
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: onTap,
          children: const [
            Qari1Page(),
            FavoritesPage(),
          ],
        ),
        bottomNavigationBar: showAppBar
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return showAppBar
                      ? SlideTransition(
                          position: _positionAnimation, child: child)
                      : const SizedBox.shrink();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: kBottomNavigationBarHeight + 5,
                  child: BottomNavigationBar(
                      backgroundColor: ColorPallate.backGroundColor,
                      items: tabs,
                      currentIndex: _currentIndex,
                      onTap: onTap),
                ),
              )
            : null,
      ),
    );
  }
}

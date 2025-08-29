import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/util/show_snackbar.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton(
      {super.key,
      required this.surah,
      required this.onDownload,
      required this.onError});

  final Surah surah;
  final Function(Surah surah) onDownload;
  final Function(String error) onError;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      context.read<SurahDownloadCubit>().downloadSurah(
            widget.surah,
            widget.onDownload,
            widget.onError,
          );
    }, child: BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
      builder: (context, state) {
        return Image(
            width: Theme.of(context).textTheme.labelLarge!.fontSize! + 15,
            height: Theme.of(context).textTheme.labelLarge!.fontSize! + 15,
            image: AssetImage(
                (state == null || state.surah.id != widget.surah.id)
                    ? "assets/images/download_icon_white.png"
                    : "assets/images/download_icon_blue.png"));
      },
    ));
  }
}

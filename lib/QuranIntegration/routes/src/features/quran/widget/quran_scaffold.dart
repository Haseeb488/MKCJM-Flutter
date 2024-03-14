import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/util/bloc/juz/juz_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../bottom_tab/bloc/tab/tab_bloc.dart' as btb;
import '../bloc/tab/tab_bloc.dart' as qtb;
import '../cubit/quran_cubit.dart';
import 'juz_card.dart';
import 'quran_tab.dart';
import 'surah_card.dart';

class QuranScaffold extends StatelessWidget {
  const QuranScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Al-Qur\'an",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            QuranTab(),
            Expanded(
              child: BlocBuilder<qtb.TabBloc, qtb.TabState>(
                builder: (context, tabState) {
                  return PageView.builder(
                    controller: tabState.controller,
                    itemCount: 2,
                    onPageChanged: (index) {
                      BlocProvider.of<qtb.TabBloc>(context)
                          .add(qtb.ToggleTab(index == 0));
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return BlocBuilder<SurahBloc, SurahState>(
                          builder: (context, state) {
                            return ListView.builder(
                              itemCount: state.surahs.surahs.length,
                              itemBuilder: (context, index) {
                                return SurahCard(
                                  state.surahs,
                                  index,
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return BlocBuilder<JuzBloc, JuzState>(
                          builder: (context, state) {
                            return ListView.builder(
                              itemCount: state.juzs.juzs.length,
                              itemBuilder: (context, index) {
                                return JuzCard(
                                  state.juzs,
                                  index,
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

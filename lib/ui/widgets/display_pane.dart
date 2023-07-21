import 'package:calculator/ui/screens/home_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DisplayPane extends StatelessWidget {
  const DisplayPane({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (_, state, __) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon:
                  Icon(state.isShowingResultPane ? Icons.history : Icons.money),
              onPressed: () {
                state.changePane();
              },
            ),
            Expanded(
                child: state.isShowingResultPane
                    ? const ResultPane()
                    : const HistoryPane()),
          ],
        ),
      );
    });
  }
}

class ResultPane extends StatelessWidget {
  const ResultPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (_, state, __) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            state.display,
            style: MediaQuery.of(context).size.width > 768
                ? Theme.of(context).textTheme.displayLarge
                : Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.end,
          ),
        ),
      );
    });
  }
}

class HistoryPane extends StatefulWidget {
  const HistoryPane({super.key});

  @override
  State<HistoryPane> createState() => _HistoryPaneState();
}

class _HistoryPaneState extends State<HistoryPane> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeState>(context, listen: false).getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (_, state, __) {
      return ListView.separated(
          itemBuilder: (_, index) => ListTile(
                key: Key(state.history[index]['id'] as String),
                title: Text(state.history[index]['expression'] as String),
                subtitle: Text(DateFormat.yMMMd().format(
                    DateTime.parse(state.history[index]['date'] as String))),
                trailing: Text(
                  HomeState.format
                      .format(state.history[index]['result'] as num),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: state.history.length);
    });
  }
}

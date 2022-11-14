import 'package:flutter/material.dart';
import 'package:matika/data/size_config.dart';
import 'package:matika/data/store.dart';
import 'package:matika/view/widget/time_remaining_text.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  ReservationPageState createState() => ReservationPageState();
}

class ReservationPageState extends State<ReservationPage> {
  late Store reservedStore;

  List<Store> browseStores = [];

  @override
  void initState() {
    super.initState();

    reservedStore = Store(name: 'ファミリーレストラン', icon: Icons.fastfood, type: RemainingType.remaining, state: '10分');
    browseStores.addAll([
      Store(name: 'カフェ', icon: Icons.emoji_food_beverage, type: RemainingType.possible, state: '入店可能'),
      Store(name: 'ラーメン', icon: Icons.food_bank, type: RemainingType.impossible, state: '営業時間外'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double blockHorizontal = SizeConfig.blockSizeHorizontal!;
    return Padding(
      padding: EdgeInsets.only(top: blockHorizontal*6, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('予約店舗', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          // 予約したお店のカードを表示
          Card(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  // お店の画像を表示
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(reservedStore.icon, size: blockHorizontal*20, color: Colors.amber,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 店舗名を表示
                      const Text('店舗名', style: TextStyle(fontSize: 12),),
                      Container(
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        child: Text(reservedStore.name, style: TextStyle(fontSize: blockHorizontal*5),),
                      ),
                      // 残りの待ち時間を表示
                      const Text('待ち状況', style: TextStyle(fontSize: 12),),
                      Container(
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        // 色分けのためにRichTextを使用
                        child: TimeRemainingText(
                          remainingType: reservedStore.type,
                          stateText: reservedStore.state,
                          normalTextSize: blockHorizontal*5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36,),
          const Text('閲覧したお店の状況', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: browseStores.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Icon(browseStores[index].icon),
                    title: Text(browseStores[index].name),
                    subtitle: TimeRemainingText(
                      remainingType: browseStores[index].type,
                      stateText: browseStores[index].state,
                      normalColor: Colors.grey,
                      accentTextSize: 20,
                    ),
                    iconColor: Colors.amber,
                    tileColor: Colors.white,
                    onLongPress: () => _showReservationDialog(context, browseStores[index]),
                  ),
                );
              }
            )
          ),
        ],
      ),
    );
  }

  // 過去に閲覧したお店から予約をするためのダイアログ
  void _showReservationDialog(BuildContext context, Store store) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('予約しますか？'),
          content: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 店舗名を表示
                const Text('店舗名', style: TextStyle(fontSize: 8),),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(store.name, style: const TextStyle(fontSize: 16),),
                ),
                // 残りの待ち時間を表示
                const Text('待ち状況', style: TextStyle(fontSize: 8),),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  // 色分けのためにRichTextを使用
                  child: TimeRemainingText(
                    remainingType: store.type,
                    stateText: store.state,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
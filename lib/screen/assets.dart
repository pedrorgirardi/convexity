import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../model.dart';
import '../nav.dart' as nav;
import '../widget.dart';

class AssetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets')),
      body: AssetsScreenBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => nav.pushFollow(context),
      ),
    );
  }
}

class AssetsScreenBody extends StatefulWidget {
  @override
  _AssetsScreenBodyState createState() => _AssetsScreenBodyState();
}

class _AssetsScreenBodyState extends State<AssetsScreenBody> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      children: appState.model.following.map((token) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: FungibleTokenRenderer(
            aasset: token,
            balance: appState.fungibleClient().balance(
                  token: token.asset.address,
                  holder: appState.model.activeAddress,
                ),
            onTap: (AAsset aasset) => nav.pushAsset(context, aasset),
          ),
        );
      }).toList(),
    );
  }
}

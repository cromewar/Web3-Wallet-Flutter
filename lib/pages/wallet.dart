import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/providers/wallet_provider.dart';
import 'package:web3_wallet/pages/create_or_import.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Menu'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('privateKey');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateOrImportPage()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wallet Address',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  '0x1234567890abcdef',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  '2.5 ETH',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'sendButton', // Unique tag for send button
                    onPressed: () {
                      // Handle send button press
                    },
                    child: Icon(Icons.send),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Send'),
                ],
              ),
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'receiveButton', // Unique tag for receive button
                    onPressed: () {
                      // Handle receive button press
                    },
                    child: const Icon(Icons.qr_code),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Receive'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          const Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Assets'),
                      Tab(text: 'NFTs'),
                      Tab(text: 'Activities'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Assets Tab
                        Center(child: Text('Assets Tab')),
                        // NFTs Tab
                        Center(child: Text('NFTs Tab')),
                        // Activities Tab
                        Center(child: Text('Activities Tab')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

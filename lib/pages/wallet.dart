import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/providers/wallet_provider.dart';
import 'package:web3_wallet/pages/create_or_import.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3_wallet/utils/get_balances.dart';
import 'dart:convert';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String walletAddress = '';
  String balance = '';

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      final walletProvider = WalletProvider();
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);

      setState(() {
        walletAddress = address.hex;
      });
      String response = await getBalances(address.hex, 'sepolia');
      dynamic data = json.decode(response);
      String newBalance = data['balance'] ?? '0';

      // Transform balance from wei to ether
      EtherAmount latest_balance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latest_balance_in_ether =
          latest_balance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latest_balance_in_ether;
      });
      print(balance);
    }
  }

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
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.remove('privateKey');
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateOrImportPage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wallet Address',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  walletAddress,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  balance ?? '0',
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

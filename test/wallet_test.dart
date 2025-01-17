import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:optional/optional.dart';
import 'package:starcoin_wallet/starcoin/starcoin.dart';
import 'package:starcoin_wallet/serde/serde.dart';
import 'package:starcoin_wallet/wallet/host_manager.dart';

import 'package:starcoin_wallet/wallet/account_manager.dart';
import 'package:starcoin_wallet/wallet/keypair.dart';
import 'package:starcoin_wallet/wallet/node.dart';
import 'package:starcoin_wallet/wallet/wallet_client.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:starcoin_wallet/transaction_builder.dart';
import 'dart:typed_data';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:starcoin_wallet/wallet/hash.dart';
import 'dart:async';
import 'package:starcoin_wallet/wallet/pubsub.dart';

const String mnemonic =
    'danger gravity economy coconut flavor cart relax cactus analyst cradle pelican guitar balance there mail check where scrub topple shock connect valid follow flip';
const address1 =
    '6b68105b99cc381e9b4c8a9067fff4e204e1ce0384e2c0ce095321ed8a50e57b';
const address2 =
    'e7f884d74d8372becba990f374bb92a3edd19be9d8d1e50cac38c79d6f57d1c0';
const URL = "https://proxima-seed.starcoin.org";

HostMananger localHostManager(){
  var hosts = HashSet<String>();
  hosts.add("localhost");
  var hostManager = SimpleHostManager(hosts);
  return hostManager;
}

void main() {
  test("account gen",(){  
      Wallet wallet = new Wallet(mnemonic: "vital fun cereal burden announce claim awkward foster wash mass gap rebuild", salt: 'LIBRA',hostMananger: localHostManager());
      final account=wallet.newAccount();
      print(account.keyPair.getPrivateKeyHex());
      print(account.keyPair.getPublicKeyHex());
      print(account.keyPair.getAddress());
      print(account.keyPair.getReceiptIdentifier().encode());

      var authKeyHex = "93dcc435cfca2dcf3bf44e9948f1f6a98e66a1f1b114a4b8a37ea16e12beeb6d";
      var addressHex = "1603d10ce8649663e4e5a757a8681833";

      var address = AccountAddress.fromHex(addressHex);
      var authKey = HEX.decode(authKeyHex);

      var receipt= ReceiptIdentifier.decode("stc1pzcpazr8gvjtx8e895at6s6qcxwfae3p4el9zmnem738fjj83765cue4p7xc3ff9c5dl2zmsjhm4k63mmwta");
      print("address is ${receipt.accountAddress}");
      print("auth key is ${HEX.encode(receipt.authKey)}");

      var identifier = ReceiptIdentifier.fromAddressAuthkey(address, authKey);
      print(identifier.encode());

      final account1=wallet.newAccount();
      print(account1.keyPair.getPrivateKeyHex());
      print(account1.keyPair.getPublicKeyHex());
      print(account1.keyPair.getAddress());
      print(account1.keyPair.getReceiptIdentifier().encode());

    }
  );

  test('wallet test', () {
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA');
    Account account = wallet.newAccount();
    print(Helpers.byteToHex(account.keyPair.getPrivateKey()));
    var publicKeyHex = Helpers.byteToHex(account.keyPair.getPublicKey());
    print("public key is $publicKeyHex");
    print("account address is ${account.getAddress()}");
    expect("0xaa2c4fb6710a8b8fc78bc14db9610a0b", account.getAddress());

    var message = Uint8List.fromList([1, 2, 3, 4]);
    var result = account.keyPair.sign(message);
    print("result is " + Helpers.byteToHex(result));
    expect(Helpers.byteToHex(result),
        "2a9e46c936f9ea08ef2f87ebb7f0be3d23a77293d75829e925309d13ae9d449efec27ae25a6c70156b2c7facecdbf3d25ad62f8d7a6039f5c67afbcb89316509");
    expect(account.keyPair.verify(result, message), true);
  });

  test('call tx pool', () async {
    var socket = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:9870'));
    var client = Client(socket.cast<String>());

    unawaited(client.listen());

    var nodeInfo = await client.sendRequest('node.info');

    //var txpool_state = await client.sendRequest('txpool.state');
    //print('txpool state is $txpool_state');

    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());
    Account account = wallet.newAccount();
    AccountAddress sender = AccountAddress(account.keyPair.getAddressBytes());

    var structTag = StructTag(
        AccountAddress(Helpers.hexToBytes("00000000000000000000000000000001")),
        Identifier("Account"),
        Identifier("Account"),
        []);
    List<int> path = [];
    path.add(RESOURCE_TAG);

    var hash = lcsHash(structTag.bcsSerialize(), "STARCOIN::StructTag");
    path.addAll(hash);

    final walletClient = new WalletClient(localHostManager());
    var result = await walletClient.getStateJson(
        sender, DataPathResourceItem(structTag));

    var listInt = <int>[];
    for (var i in result) {
      listInt.add(i);
    }
    var resource = AccountResource.bcsDeserialize(Uint8List.fromList(listInt));
    print("resouce is " + resource.sequence_number.toString());

    structTag = StructTag(
        AccountAddress(Helpers.hexToBytes("00000000000000000000000000000001")),
        Identifier("Account"),
        Identifier("Balance"),
        List.from([
          TypeTagStructItem(StructTag(
              AccountAddress(
                  Helpers.hexToBytes("00000000000000000000000000000001")),
              Identifier("STC"),
              Identifier("STC"),
              []))
        ]));
    path = [];
    path.add(RESOURCE_TAG);

    hash = lcsHash(structTag.bcsSerialize(), "STARCOIN::StructTag");
    path.addAll(hash);

    //var hex_access_path = Helpers.byteToHex(Uint8List.fromList(path));
    //print("hash is " + hex_access_path);
    //var accessPath = AccessPath(sender, DataPathResourceItem(struct_tag));
    result = await walletClient.getStateJson(
        sender, DataPathResourceItem(structTag));
    listInt = <int>[];
    for (var i in result) {
      listInt.add(i);
    }
    var balanceResource =
        BalanceResource.bcsDeserialize(Uint8List.fromList(listInt));
    print("balance is " + balanceResource.token.low.toString());

    //var empty_script = TransactionBuilder.en();
    structTag = StructTag(
        AccountAddress(Helpers.hexToBytes("00000000000000000000000000000001")),
        Identifier("STC"),
        Identifier("STC"),
        []);
    var transferScript = TransactionBuilder.encode_peer_to_peer_script_function(
        TypeTagStructItem(structTag),
        AccountAddress(
            (Helpers.hexToBytes("703038dffdf4db03ad11fc75cfdec595"))),
        Bytes(Helpers.hexToBytes("826cf2fd51e9fa87378d385c347599f609457b466bcb97d81e22608247440c8f")),
        Int128(0, 200));
    var payloadBytes = transferScript.bcsSerialize();
    print("payload is "+Helpers.byteToHex(payloadBytes));  


    RawTransaction rawTxn = RawTransaction(
        sender,
        resource.sequence_number,
        transferScript,
        20000,
        1,
        "0x1::STC::STC",
        nodeInfo['now_seconds'] + 40000,
        ChainId(254));

    var rawTxnBytes = rawTxn.bcsSerialize();
    print("txn is "+Helpers.byteToHex(rawTxnBytes));  
    print("txn hash is " + Helpers.byteToHex(rawHash(rawTxnBytes)));

    var signBytes = account.keyPair
        .sign(cryptHash(rawTxnBytes, "STARCOIN::RawUserTransaction"));

    Ed25519PublicKey pubKey =
        Ed25519PublicKey(Bytes(account.keyPair.getPublicKey()));
    Ed25519Signature sign = Ed25519Signature(Bytes(signBytes));

    TransactionAuthenticatorEd25519Item author =
        TransactionAuthenticatorEd25519Item(pubKey, sign);

    SignedUserTransaction signedTxn = SignedUserTransaction(rawTxn, author);

    var res = await client.sendRequest('txpool.submit_hex_transaction',
        [Helpers.byteToHex(signedTxn.bcsSerialize())]);
    print('result is $res');
  });

  test('Account', () async {
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());

    final walletClient = new WalletClient(localHostManager());
    Account account = wallet.newAccount();
    Account reciever = wallet.newAccount();

    final balance = await account.balanceOfStc();
    print("balance is " + balance.low.toString());

    final result = await account.transferSTC(
        Int128(0, 20000),
        AccountAddress(reciever.keyPair.getAddressBytes()),
        Bytes(reciever.keyPair.getPublicAuthKey()));
    print("reciever address is "+reciever.keyPair.getAddressBytes().toString());
    print("reciever public key is "+reciever.keyPair.getPublicAuthKey().toString());
    print("reciever private key is "+reciever.keyPair.getPrivateKeyHex());
    print("result is $result");

    await Future.delayed(Duration(seconds: 5));

    if (result.result == true) {
      final txn = await walletClient.getTransaction(result.txnHash);
      print("txn is $txn");
    }

    if (result.result == true) {
      final txn = await walletClient.getTransactionInfo(result.txnHash);
      print("txn_info is $txn");
    }

    final accountStateSet = await account.getAccountStateSet();
    if (accountStateSet != null) {
      final resources = accountStateSet['resources'];
      for (var k in resources.keys) {
        if (k.toString().contains("Balance")) {
          final value = resources[k]['value'][0] as List;
          for (var item in value) {
            if (item is Map) {
              final balanceValue = item['Struct']['value'][0];
              for (var balance in balanceValue) {
                if (balance is Map) {
                  print(BigInt.parse(balance['U128']));
                }
              }
            }
          }
          print("Key : $k, value : $value");
        }
      }
    }

    final tokenList = await account.getAccountToken(URL);
    if(tokenList.length>0){
    final result = await account.transferToken(
        Int128(0, 20000),
        AccountAddress(reciever.keyPair.getAddressBytes()),
        Bytes(reciever.keyPair.getPublicAuthKey()),
        tokenList[0].token
        );        
    }
  });

  test('test state set', () async {
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());

    final walletClient = new WalletClient(localHostManager());
    Account account = wallet.newAccount();
    print(account.getAddress());
    print(account.keyPair.getPublicKeyHex());

    final result = await walletClient.getStateStateSet(AccountAddress.fromHex(account.keyPair.getAddress()));
    print(result.toString());
  });

  test('Account Transfer Token', () async {
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());

    final walletClient = new WalletClient(localHostManager());
    Account account = wallet.newAccount();
    Account reciever = wallet.newAccount();

    final balance = await account.balanceOfStc();
    print("balance is " + balance.low.toString());

    final tokenList = await account.getAccountToken(URL);
    if(tokenList.length>0){      
      var sructTag=tokenList[0].token.type_params[0] as TypeTagStructItem;
      final result = await account.transferToken(
        Int128(0, 20000),
        AccountAddress(reciever.keyPair.getAddressBytes()),
        Bytes(reciever.keyPair.getPublicAuthKey()),
        sructTag.value
        );        
    
      await Future.delayed(Duration(seconds: 5));

      if (result.result == true) {
        final txn = await walletClient.getTransaction(result.txnHash);
        print("txn is $txn");
      }

      if (result.result == true) {
        final txn = await walletClient.getTransactionInfo(result.txnHash);
        print("txn_info is $txn");
      }
    
    }
  });

  test('sub', () async {
    var client = PubSubClient(localHostManager());
    final walletClient = new WalletClient(localHostManager());
    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());

    final account = wallet.newAccount();

    var subscription = client.addFilter(NewTxnSendRecvEventFilter(account));
    await for (var event in subscription) {
      print(await walletClient.getTransactionInfo(event['transaction_hash']));
      print(await walletClient.getTransaction(event['transaction_hash']));
      break;
    }

  });

  test('node', () async {
    final node = Node(localHostManager());
    final result = await node.defaultAccount();
    print(result);

    final List exportedAccount =
        await node.exportAccount(result['address'], "");
    print(KeyPair(
            Uint8List.fromList(exportedAccount.map((e) => e as int).toList()))
        .getPrivateKeyHex());

    final address =
        AccountAddress.fromJson(result['address'].replaceAll("0x", ""));
    final balance = await node.balanceOfStc(address);
    print(balance.toBigInt());

    final nodeInfo = await node.nodeInfo();
    print(nodeInfo['peer_info']['chain_info']['total_difficulty']);

    final syncStatus = await node.syncStatus();
    print(syncStatus);

    //final syncProgress = await node.syncProgress();
    //final taskNames = syncProgress['current']['task_name'].split("::");
    //print(taskNames[taskNames.length - 1]);

    //final double percent = syncProgress['current']['percent'];
    //print(percent);
  });

  test('events', () async {

    Wallet wallet = new Wallet(mnemonic: mnemonic, salt: 'LIBRA',hostMananger: localHostManager());

    final walletClient = new WalletClient(localHostManager());
    final account = wallet.newAccount();

    final batchClient = new BatchClient(localHostManager());
    final txnList2 = await batchClient.getTxnListBatch(walletClient, account,
        Optional.of(0), Optional.empty(), Optional.empty());
    print(txnList2[0].txn);
    print(txnList2[0].txnInfo);

    final txnList = await walletClient.getTxnList(
        account, Optional.of(0), Optional.empty(), Optional.empty());
    print(txnList[0].txn);
    print(txnList[0].txnInfo);

  });

  test('Hash', () {
    final bytes = Uint8List.fromList([
      125,
      67,
      213,
      38,
      157,
      219,
      137,
      205,
      183,
      247,
      184,
      18,
      104,
      155,
      241,
      53,
      7,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      161,
      1,
      161,
      28,
      235,
      11,
      1,
      0,
      0,
      0,
      6,
      1,
      0,
      2,
      3,
      2,
      17,
      4,
      19,
      4,
      5,
      23,
      24,
      7,
      47,
      42,
      8,
      89,
      16,
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      1,
      0,
      2,
      2,
      3,
      0,
      0,
      3,
      4,
      1,
      1,
      1,
      0,
      6,
      2,
      6,
      2,
      5,
      10,
      2,
      0,
      1,
      5,
      1,
      1,
      3,
      6,
      12,
      5,
      4,
      4,
      6,
      12,
      5,
      10,
      2,
      4,
      1,
      9,
      0,
      7,
      65,
      99,
      99,
      111,
      117,
      110,
      116,
      14,
      99,
      114,
      101,
      97,
      116,
      101,
      95,
      97,
      99,
      99,
      111,
      117,
      110,
      116,
      9,
      101,
      120,
      105,
      115,
      116,
      115,
      95,
      97,
      116,
      8,
      112,
      97,
      121,
      95,
      102,
      114,
      111,
      109,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      5,
      1,
      13,
      10,
      1,
      17,
      1,
      32,
      3,
      5,
      5,
      8,
      10,
      1,
      10,
      2,
      56,
      0,
      11,
      0,
      10,
      1,
      10,
      3,
      56,
      1,
      2,
      1,
      7,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      3,
      83,
      84,
      67,
      3,
      83,
      84,
      67,
      0,
      3,
      3,
      170,
      98,
      21,
      247,
      38,
      8,
      228,
      209,
      97,
      153,
      20,
      39,
      180,
      155,
      110,
      103,
      4,
      16,
      112,
      48,
      56,
      223,
      253,
      244,
      219,
      3,
      173,
      17,
      252,
      117,
      207,
      222,
      197,
      149,
      2,
      200,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      32,
      78,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      13,
      48,
      120,
      49,
      58,
      58,
      83,
      84,
      67,
      58,
      58,
      83,
      84,
      67,
      5,
      226,
      96,
      95,
      0,
      0,
      0,
      0,
      254,
      0,
      32,
      130,
      108,
      242,
      253,
      81,
      233,
      250,
      135,
      55,
      141,
      56,
      92,
      52,
      117,
      153,
      246,
      9,
      69,
      123,
      70,
      107,
      203,
      151,
      216,
      30,
      34,
      96,
      130,
      71,
      68,
      12,
      143,
      64,
      6,
      102,
      250,
      227,
      98,
      221,
      129,
      136,
      197,
      243,
      79,
      206,
      201,
      57,
      0,
      57,
      163,
      216,
      146,
      36,
      227,
      205,
      214,
      21,
      85,
      200,
      71,
      42,
      155,
      16,
      207,
      204,
      134,
      183,
      87,
      89,
      253,
      28,
      178,
      254,
      244,
      28,
      94,
      129,
      152,
      49,
      111,
      118,
      238,
      236,
      36,
      49,
      239,
      179,
      197,
      211,
      150,
      199,
      7,
      37,
      161,
      6,
      202,
      7
    ]);
    expect("6b4ddb8ee36850cf6dbaf1826031d47cefb4bb217b9735f0dfa3d42cca7f4938",
        Helpers.byteToHex(lcsHash(bytes, "LIBRA::SignedUserTransaction")));
  });
}

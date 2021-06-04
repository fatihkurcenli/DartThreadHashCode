library threading.example.example_interleaved_execution;

import 'dart:async';

import 'package:threading/threading.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future main() async {
  var buffer = _BoundedBuffer();
  var threads = <Thread>[];
  for (var i = 0; i < 2; i++) {
    var thread = Thread(() async {
      await buffer._hashCode();
      print('${Thread.current.name}: => $i');
    });

    thread.name = 'Producer $i';
    threads.add(thread);
    await thread.start();
  }

  for (var i = 0; i < 2; i++) {
    var thread = Thread(() async {
      var x = await buffer._hashCode();
      print('${Thread.current.name}: <= $x');
    });

    thread.name = 'Consumer $i';
    threads.add(thread);
    await thread.start();
  }

/*   for (var thread in threads) {
    await thread.join();
  } */
}

class _BoundedBuffer<T> {
  var transactions =
      "Bize her yer Trabzon! Bolumun en yakisikli hocasi Ibrahim Hoca'dir";
  var blockNumber = 1;
  var difficulty = 1;
  var firstHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  final Lock _lock = Lock();

  // ConditionVariable _notEmpty;

  // ConditionVariable _notFull;

  _BoundedBuffer() {
    // _notFull = ConditionVariable(_lock);
    // _notEmpty = ConditionVariable(_lock);
  }

/*   Future put(T x) async {
    await _lock.acquire();
    try {
      await _notFull.wait();

      await _notEmpty.signal();
    } finally {
      await _lock.release();
    }
  } */

  Future _hashCode() async {
    try {
      var prefix_str = '0' * difficulty;
      for (var nonce = 0; nonce < 100000000000; nonce++) {
        var text = blockNumber.toString() +
            transactions +
            firstHash +
            nonce.toString();
        var new_hash = _crypToSha(text);
        if (new_hash.startsWith(prefix_str)) {
          await _lock.acquire();
          print(nonce);
          print(new_hash);
          break;
        }
      }
    } finally {
      await _lock.release();
    }
  }

  String _crypToSha(String text) {
    var bytes = utf8.encode(text);
    var digest2 = sha256.convert(bytes);
    return digest2.toString();
  }
}

/* Future hashCode(block_number, transactions, previous_hash, prefix_zeros) async {
  var prefix_str = '0' * prefix_zeros;
  for (var nonce = 0; nonce < 100000000000; nonce++) {
    var text = block_number.toString() +
        transactions +
        previous_hash +
        nonce.toString();
    var new_hash = _crypToSha(text);
    if (new_hash.startsWith(prefix_str)) {
      print(nonce);
      print(new_hash);
      break;
    }
  }
} */

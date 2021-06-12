library threading.example.example_interleaved_execution;

import 'dart:async';

import 'package:threading/threading.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future main() async {
  await runThreads();
}

Future runThreads() async {
  var buffer = _BoundedBuffer();
  print('Threads (interleaved execution)');
  print('----------------');
  var threads = <Thread>[];
  var numOfThreads = 2;
  for (var i = 0; i < numOfThreads; i++) {
    var thread = Thread(() async {
      buffer._hashCode();
    });
    var thread2 = Thread(() async {
      buffer._hashCode2();
    });

    threads.add(thread);
    threads.add(thread2);
  }

  for (var i = 0; i < numOfThreads; i++) {
    await threads[i].start();
  }
}

class _BoundedBuffer<T> {
  var transactions =
      "Bize her yer Trabzon! Bölümün en yakisikli hocasi Ibrahim Hoca'dir";
  var blockNumber = 1;
  var difficulty = 1;
  var firstHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  final Lock _lock = Lock();

  _hashCode() async {
    try {
      var prefix_str = '0' * difficulty;
      for (var nonce = 50000000; nonce < 100000000000; nonce++) {
        var text = blockNumber.toString() +
            transactions +
            firstHash +
            nonce.toString();
        var new_hash = _crypToSha(text);

        if (new_hash.startsWith(prefix_str) &&
            new_hash[difficulty + 1] != '0') {
          await _lock.acquire();
          firstHash = new_hash;
          blockNumber += 1;
          difficulty += 1;
          print('1.Thread - Block Number -> ${blockNumber - 1}');
          print('Bulunan Nonce Değeri -> $nonce');
          print('Bulunan HashDeğeri Değeri -> $new_hash');
          print('--------------------------------------');

          await _lock.release();
          break;
        }
      }
    } finally {
      var thread2 = Thread(() async {
        _hashCode2();
      });
      var thread = Thread(() async {
        _hashCode();
      });

      await thread2.start();
      await thread.start();
    }
  }

  _hashCode2() async {
    try {
      var prefix_str = '0' * difficulty;
      for (var nonce = 0; nonce < 50000000; nonce++) {
        var text = blockNumber.toString() +
            transactions +
            firstHash +
            nonce.toString();
        var new_hash = _crypToSha2(text);

        if (new_hash.startsWith(prefix_str) &&
            new_hash[difficulty + 1] != '0') {
          await _lock.acquire();
          firstHash = new_hash;
          blockNumber += 1;
          difficulty += 1;
          print('2.Thread - Block Number -> ${blockNumber - 1}');
          print('Bulunan Nonce Değeri -> $nonce');
          print('Bulunan HashDeğeri Değeri -> $new_hash');
          print('--------------------------------------');

          await _lock.release();
          break;
        }
      }
    } finally {
      var thread2 = Thread(() async {
        _hashCode();
      });
      var thread = Thread(() async {
        _hashCode2();
      });

      await thread2.start();
      await thread.start();
    }
  }

  String _crypToSha2(String text) {
    var bytes = utf8.encode(text);
    var digest2 = sha256.convert(bytes);
    return digest2.toString();
  }

  String _crypToSha(String text) {
    var bytes = utf8.encode(text);
    var digest2 = sha256.convert(bytes);
    return digest2.toString();
  }
}

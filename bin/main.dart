library threading.example.example_interleaved_execution;

import 'dart:async';

import 'package:threading/threading.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future main() async {
  //await runFutures();
  await runThreads();
}

Future runThreads() async {
  var buffer = _BoundedBuffer();
  print('Threads (interleaved execution)');
  print('----------------');
  var threads = <Thread>[];
  var numOfThreads = 2;
  for (var i = 0; i < numOfThreads; i++) {
    // var name = String.fromCharCode(65 + i);
    var thread = Thread(() async {
      buffer._hashCode();
    });
    var thread2 = Thread(() async {
      buffer._hashCode2();
    });

    threads.add(thread);
    threads.add(thread2);
    //  await thread.start();
    // await thread2.start();
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

  ConditionVariable _notEmpty;

  ConditionVariable _notFull;

  _BoundedBuffer() {
    _notFull = ConditionVariable(_lock);
    _notEmpty = ConditionVariable(_lock);
  }

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

          break;
        }
      }
    } finally {
      await _lock.release();
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

          break;
        }
      }
    } finally {
      await _lock.release();
      var thread2 = Thread(() async {
        _hashCode();
      });
      var thread = Thread(() async {
        _hashCode2();
      });
      await thread.start();
      await thread2.start();
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

/*   for (var i = 0; i < numOfThreads; i++) {
    await threads[i].join();
  } */
}

/* library threading.example.example_interleaved_execution;

import 'dart:async';

import 'package:threading/threading.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future main() async {
  var buffer = _BoundedBuffer();
  // var threads = <Thread>[];
  for (var i = 0; i < 12; i++) {
    var thread = Thread(() async {
      buffer._hashCode();
      print('Çalışan Thread ${Thread.current.name}');
    });
    var thread2 = Thread(() async {
      buffer._hashCode2();
      print('Çalışan Thread ${Thread.current.name}');
    });

    // threads.add(thread);
    await thread.start();
    await thread2.start();
  }

/*   for (var i = 0; i < 12; i++) {
    var thread = Thread(() async {
      await buffer._hashCode2();
      print('Çalışan Thread ${Thread.current.name}');
    });

    threads.add(thread);
    await thread.start();
  } */

  /*   for (var thread in threads) {
    await thread.join();
  }  */
}

class _BoundedBuffer<T> {
  var transactions =
      "Bize her yer Trabzon! Bölümün en yakisikli hocasi Ibrahim Hoca'dir";
  var blockNumber = 1;
  var difficulty = 1;
  var firstHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  final Lock _lock = Lock();

  ConditionVariable _notEmpty;

  ConditionVariable _notFull;

  _BoundedBuffer() {
    _notFull = ConditionVariable(_lock);
    _notEmpty = ConditionVariable(_lock);
  }

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
          break;
        }
      }
    } finally {
      await _lock.release();
    }
    // await _hashCode();
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
          break;
        }
      }
    } finally {
      await _lock.release();
      // await _hashCode2();
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
 */

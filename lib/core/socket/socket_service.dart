import 'dart:async';

import 'package:aetram/core/socket/socket_constants.dart';
import 'package:aetram/core/socket/socket_events.dart';
import 'package:aetram/core/socket/socket_status.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService extends GetxService {
  late final io.Socket _socket;

  final Rx<SocketStatus> connectionStatus = SocketStatus.disconnected.obs;

  final StreamController<Map<String, dynamic>> _tickerStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get tickerStream =>
      _tickerStreamController.stream;

  final Set<String> _activeSubscriptions = {};

  final Map<String, Map<String, dynamic>> _pendingTicks = {};
  Timer? _throttleTimer;

  bool get isConnected => _socket.connected;

  @override
  void onInit() {
    super.onInit();

    _startThrottler();

    connect();
  }

  void _startThrottler() {
    _throttleTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pendingTicks.isNotEmpty) {
        final Map<String, Map<String, dynamic>> ticksToEmit =
            Map.from(_pendingTicks);
        _pendingTicks.clear();
        for (final tick in ticksToEmit.values) {
          _tickerStreamController.add(tick);
        }
      }
    });
  }

  void connect() {
    if (connectionStatus.value == SocketStatus.connected) {
      return;
    }

    connectionStatus.value = SocketStatus.connecting;

    _socket = io.io(
      SocketConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _registerCoreListeners();

    _socket.connect();
  }

  void _registerCoreListeners() {
    _socket.onConnect((_) {
      debugPrint('SOCKET CONNECTED');

      connectionStatus.value = SocketStatus.connected;

      _resubscribeToActiveSymbols();
    });

    _socket.onDisconnect((_) {
      debugPrint('SOCKET DISCONNECTED');

      connectionStatus.value = SocketStatus.disconnected;
    });

    _socket.onConnectError((error) {
      debugPrint('SOCKET CONNECT ERROR => $error');

      connectionStatus.value = SocketStatus.error;
    });

    _socket.onError((error) {
      debugPrint('SOCKET ERROR => $error');
    });

    _socket.on(SocketEvents.ticker, (data) {
      try {
        if (data == null) {
          return;
        }

        if (data is Map) {
          final Map<String, dynamic> tick = Map<String, dynamic>.from(data);
          final String symbol = tick['symbol'] ?? tick['SYMBOL'] ?? '';

          if (symbol.isNotEmpty) {
            _pendingTicks[symbol] = tick;
          }

          return;
        }

        if (data is Iterable) {
          final dynamic first = data.first;

          if (first is Map) {
            final Map<String, dynamic> tick = Map<String, dynamic>.from(first);
            final String symbol = tick['symbol'] ?? tick['SYMBOL'] ?? '';

            if (symbol.isNotEmpty) {
              _pendingTicks[symbol] = tick;
            }

            return;
          }
        }

        debugPrint('UNKNOWN TICK FORMAT => ${data.runtimeType}');
      } catch (e) {
        debugPrint('TICK PARSE ERROR => $e');
      }
    });
  }

  void subscribe(List<String> symbols) {
    if (symbols.isEmpty) {
      return;
    }

    _activeSubscriptions
      ..clear()
      ..addAll(symbols);

    if (!isConnected) {
      debugPrint('SOCKET NOT CONNECTED');

      return;
    }

    _socket.emit(SocketEvents.subscribe, [symbols]);

    debugPrint('SUBSCRIBED => $symbols');
  }

  void unsubscribe(List<String> symbols) {
    if (symbols.isEmpty) {
      return;
    }

    _activeSubscriptions.removeAll(symbols);

    if (!isConnected) {
      return;
    }

    _socket.emit(SocketEvents.unsubscribe, [symbols]);

    debugPrint('UNSUBSCRIBED => $symbols');
  }

  void _resubscribeToActiveSymbols() {
    if (_activeSubscriptions.isEmpty) {
      return;
    }

    subscribe(_activeSubscriptions.toList());
  }

  void disconnect() {
    _socket.disconnect();
  }

  @override
  void onClose() {
    _throttleTimer?.cancel();

    _tickerStreamController.close();

    _socket.dispose();

    super.onClose();
  }
}

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

  bool get isConnected => _socket.connected;

  @override
  void onInit() {
    super.onInit();

    connect();
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
    _socket.on(SocketEvents.connect, (_) {
      debugPrint('SOCKET CONNECTED');

      connectionStatus.value = SocketStatus.connected;

      _resubscribeToActiveSymbols();
    });

    _socket.on(SocketEvents.disconnect, (_) {
      debugPrint('SOCKET DISCONNECTED');

      connectionStatus.value = SocketStatus.disconnected;
    });

    _socket.on(SocketEvents.connectError, (error) {
      debugPrint('SOCKET ERROR => $error');

      connectionStatus.value = SocketStatus.error;
    });

    _socket.on(SocketEvents.ticker, (data) {
      try {
        final Map<String, dynamic> tick = Map<String, dynamic>.from(data);

        _tickerStreamController.add(tick);
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

    _socket.emit(SocketEvents.subscribe, symbols);

    debugPrint('SUBSCRIBED => $symbols');
  }

  void unsubscribe(List<String> symbols) {
    if (symbols.isEmpty) {
      return;
    }

    _activeSubscriptions.removeAll(symbols);

    _socket.emit(SocketEvents.unsubscribe, symbols);

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
    _tickerStreamController.close();

    _socket.dispose();

    super.onClose();
  }
}

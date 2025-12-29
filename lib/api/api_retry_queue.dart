// import 'dart:async';

// typedef ApiRetryCallback = Future<void> Function();

// class ApiRetryQueue {
//   static final List<ApiRetryCallback> _queue = [];
//   static bool _isRetrying = false;

//   /// Add failed request
//   static void add(ApiRetryCallback callback) {
//     _queue.add(callback);
//   }

//   /// Retry all when internet is back
//   static Future<void> retryAll() async {
//     if (_isRetrying || _queue.isEmpty) return;

//     _isRetrying = true;

//     while (_queue.isNotEmpty) {
//       final task = _queue.removeAt(0);
//       try {
//         await task();
//       } catch (_) {
//         // ignore failure, next retry cycle will handle
//       }
//     }

//     _isRetrying = false;
//   }

//   // static bool get hasPending => _queue.isNotEmpty;
// }

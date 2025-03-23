import 'dart:developer';

import 'package:eventflux/eventflux.dart';
import 'package:eventflux/models/web_config/request_cache.dart';
import 'package:eventflux/models/web_config/request_credentials.dart';
import 'package:eventflux/models/web_config/request_mode.dart';
import 'package:eventflux/models/web_config/web_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EventFluxUsage());
}

class EventFluxUsage extends StatefulWidget {
  const EventFluxUsage({super.key});

  @override
  State<EventFluxUsage> createState() => _EventFluxUsageState();
}

class _EventFluxUsageState extends State<EventFluxUsage> {
  final List<String> _events = [];
  @override
  void initState() {
    super.initState();
    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      "https://sse.dev/test",
      header: {
        'Content-Type': 'application/json',
      },
      webConfig: WebConfig(
        mode: WebConfigRequestMode.noCors,
        credentials: WebConfigRequestCredentials.sameOrigin,
        cache: WebConfigRequestCache.noCache,
        referrer: 'https://event-flux-web-demo.vercel.app/',
        streamRequests: false,
      ),
      onError: (EventFluxException? exception) {
        log(exception?.message ?? 'Unknown error');
      },
      onSuccessCallback: (EventFluxResponse? response) {
        if (response?.stream != null) {
          response?.stream?.listen((data) {
            log(data.data);
            setState(() {
              _events.add(data.data);
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              return Text(_events[index]);
            },
          ),
        ),
      ),
    );
  }
}

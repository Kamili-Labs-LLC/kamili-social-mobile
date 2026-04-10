import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/client.dart';

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  return GraphQLClientService.instance.client.value;
});

final graphqlClientNotifierProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  return GraphQLClientService.instance.client;
});

import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLService._();
  static final GraphQLService instance = GraphQLService._();

  late final GraphQLClient client;

  void init() {
    //const url = 'http://10.0.2.2:3001/graphql'; // Android emulator
    const url = 'http://localhost:3001/graphql'; // iOS / web / desktop

    final link = HttpLink(url);

    client = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  static const String _createUserMutation = r'''
    mutation CreateUser(
      $displayName: String!
      $firebaseUid: String
      $role: String
    ) {
      createUser(data: {
        displayName: $displayName
        firebaseUid: $firebaseUid
        role: $role
      }) {
        id
        displayName
        firebaseUid
        role
      }
    }
  ''';

  static const String _getUserByFirebaseUidQuery = r'''
    query GetUserByFirebaseUid($firebaseUid: String!) {
      userByFirebaseUid(firebaseUid: $firebaseUid) {
        id
        displayName
        firebaseUid
        role
      }
    }
  ''';

  Future<String?> createUser({
    required String displayName,
    String? firebaseUid,
    String role = 'user',
  }) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(_createUserMutation),
          variables: {
            'displayName': displayName,
            if (firebaseUid != null) 'firebaseUid': firebaseUid,
            'role': role,
          },
        ),
      );
      if (result.hasException) return null;
      return result.data?['createUser']?['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<String?> getUserIdByFirebaseUid(String firebaseUid) async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(_getUserByFirebaseUidQuery),
          variables: {'firebaseUid': firebaseUid},
        ),
      );
      if (result.hasException) return null;
      return result.data?['userByFirebaseUid']?['id'] as String?;
    } catch (_) {
      return null;
    }
  }
}

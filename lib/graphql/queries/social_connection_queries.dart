const String getSocialConnectionsQuery = r'''
  query GetSocialConnections($filter: SocialConnectionFilterInput, $pagination: PaginationInput) {
    getSocialConnections(filter: $filter, pagination: $pagination) {
      __typename
      ... on GetSocialConnections {
        success
        message
        socialConnections {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
          createdAt
          updatedAt
        }
        totalCount
        pageInfo {
          hasNextPage
          hasPreviousPage
          currentPage
          totalPages
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String getSocialConnectionQuery = r'''
  query GetSocialConnection($id: ID!) {
    getSocialConnection(id: $id) {
      __typename
      ... on GetSocialConnection {
        success
        message
        socialConnection {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
          createdAt
          updatedAt
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String getSocialConnectionsByPlatformQuery = r'''
  query GetSocialConnectionsByPlatform($platform: String!) {
    getSocialConnectionsByPlatform(platform: $platform) {
      __typename
      ... on GetSocialConnections {
        success
        message
        socialConnections {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
          createdAt
          updatedAt
        }
        totalCount
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

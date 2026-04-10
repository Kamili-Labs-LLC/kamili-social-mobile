const String getBrandUsersQuery = r'''
  query GetBrandUsers($brandId: ID!) {
    getBrandUsers(brandId: $brandId) {
      __typename
      ... on GetBrandUsers {
        success
        message
        users {
          id
          userEmail
          userName
          role
          status
          lastActiveAt
          createdAt
          updatedAt
          brand {
            id
            name
          }
          invitedBy {
            id
            name
          }
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

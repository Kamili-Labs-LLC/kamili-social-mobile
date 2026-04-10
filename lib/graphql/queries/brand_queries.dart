const String getBrandsQuery = r'''
  query GetBrands {
    getBrands {
      __typename
      ... on GetBrands {
        success
        message
        brands {
          id
          name
          description
          logo
          isActive
          isShared
          userRole
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

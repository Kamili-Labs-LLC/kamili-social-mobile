const String getWebsitesQuery = r'''
  query GetWebsites($pagination: PaginationInput) {
    getWebsites(pagination: $pagination) {
      __typename
      ... on GetWebsites {
        message
        websites {
          id
          name
          siteKey
          siteKeyStatus
          autoPostEnabled
          lastUsedAt
          domain
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

const String getWebsiteQuery = r'''
  query GetWebsite($id: ID!) {
    getWebsite(data: { id: $id }) {
      __typename
      ... on GetWebsite {
        message
        website {
          id
          name
          siteKey
          siteKeyStatus
          autoPostEnabled
          lastUsedAt
          domain
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

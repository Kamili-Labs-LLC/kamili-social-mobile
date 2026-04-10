const String getPostNotesQuery = r'''
  query GetPostNotes($postId: ID!, $page: Int, $limit: Int) {
    getPost(id: $postId) {
      __typename
      ... on GetPost {
        success
        post {
          id
          notes(pagination: { page: $page, limit: $limit }) {
            nodes {
              id
              content
              createdAt
              updatedAt
              account {
                id
                name
              }
            }
            totalCount
            pageInfo {
              hasNextPage
              hasPreviousPage
              currentPage
              totalPages
            }
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

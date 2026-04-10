const String getCollectionsQuery = r'''
  query GetCollections($brandId: ID!) {
    getCollections(brandId: $brandId) {
      success
      message
      collections {
        id
        name
        description
        color
        postCount
        createdAt
        updatedAt
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String getCollectionQuery = r'''
  query GetCollection($id: ID!) {
    getCollection(id: $id) {
      success
      message
      collection {
        id
        name
        description
        color
        postCount
        posts {
          id
          status
          content {
            default {
              text
              media {
                url
                type
                thumbnailUrl
              }
            }
          }
          targetConnections {
            platform
          }
          scheduledAt
          createdAt
        }
        createdAt
        updatedAt
      }
      error {
        errorCode
        message
      }
    }
  }
''';

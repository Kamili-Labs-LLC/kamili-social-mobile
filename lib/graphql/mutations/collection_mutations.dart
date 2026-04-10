const String createCollectionMutation = r'''
  mutation CreateCollection($data: CreateCollectionInput!) {
    createCollection(data: $data) {
      success
      message
      collection {
        id
        name
        description
        color
        postCount
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String updateCollectionMutation = r'''
  mutation UpdateCollection($data: UpdateCollectionInput!) {
    updateCollection(data: $data) {
      success
      message
      collection {
        id
        name
        description
        color
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String deleteCollectionMutation = r'''
  mutation DeleteCollection($id: ID!) {
    deleteCollection(id: $id) {
      success
      message
      error {
        errorCode
        message
      }
    }
  }
''';

const String addPostToCollectionMutation = r'''
  mutation AddPostToCollection($postId: ID!, $collectionId: ID!) {
    addPostToCollection(postId: $postId, collectionId: $collectionId) {
      success
      message
      error {
        errorCode
        message
      }
    }
  }
''';

const String removePostFromCollectionMutation = r'''
  mutation RemovePostFromCollection($postId: ID!) {
    removePostFromCollection(postId: $postId) {
      success
      message
      error {
        errorCode
        message
      }
    }
  }
''';

const String createPostNoteMutation = r'''
  mutation CreatePostNote($data: CreatePostNoteInput!) {
    createPostNote(data: $data) {
      success
      message
      note {
        id
        content
        createdAt
        updatedAt
        account {
          id
          name
        }
      }
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

const String updatePostNoteMutation = r'''
  mutation UpdatePostNote($data: UpdatePostNoteInput!) {
    updatePostNote(data: $data) {
      success
      message
      note {
        id
        content
        createdAt
        updatedAt
        account {
          id
          name
        }
      }
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

const String deletePostNoteMutation = r'''
  mutation DeletePostNote($id: ID!) {
    deletePostNote(id: $id) {
      success
      message
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

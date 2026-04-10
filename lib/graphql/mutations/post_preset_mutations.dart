const String createPostPresetMutation = r'''
  mutation CreatePostPreset($data: CreatePostPresetInput!) {
    createPostPreset(data: $data) {
      success
      message
      preset {
        id
        name
        platform
        settings
        isDefault
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String updatePostPresetMutation = r'''
  mutation UpdatePostPreset($data: UpdatePostPresetInput!) {
    updatePostPreset(data: $data) {
      success
      message
      preset {
        id
        name
        settings
        isDefault
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String deletePostPresetMutation = r'''
  mutation DeletePostPreset($id: ID!) {
    deletePostPreset(id: $id) {
      success
      message
      error {
        errorCode
        message
      }
    }
  }
''';

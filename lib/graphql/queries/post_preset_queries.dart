const String getPostPresetsQuery = r'''
  query GetPostPresets($filter: PostPresetFilterInput) {
    getPostPresets(filter: $filter) {
      success
      message
      presets {
        id
        name
        platform
        settings
        isDefault
      }
      count
      error {
        errorCode
        message
      }
    }
  }
''';

const String getPostPresetQuery = r'''
  query GetPostPreset($id: ID!) {
    getPostPreset(id: $id) {
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

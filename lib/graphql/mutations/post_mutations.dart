const String createPostMutation = r'''
  mutation CreatePost($data: CreatePostInput!) {
    createPost(data: $data) {
      success
      message
      post {
        id
        status
        scheduledAt
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

const String updatePostMutation = r'''
  mutation UpdatePost($data: UpdatePostInput!) {
    updatePost(data: $data) {
      success
      message
      post {
        id
        status
        scheduledAt
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

const String deletePostMutation = r'''
  mutation DeletePost($id: ID!) {
    deletePost(id: $id) {
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

const String duplicatePostMutation = r'''
  mutation DuplicatePost($postId: ID!) {
    duplicatePost(postId: $postId) {
      success
      message
      post {
        id
        status
        content {
          default {
            text
          }
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

const String schedulePostMutation = r'''
  mutation SchedulePost($postId: ID!, $scheduledAt: Date!) {
    schedulePost(postId: $postId, scheduledAt: $scheduledAt) {
      success
      message
      post {
        id
        status
        scheduledAt
        failReason
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

const String reschedulePostMutation = r'''
  mutation ReschedulePost($postId: ID!, $newScheduledAt: Date!) {
    reschedulePost(postId: $postId, newScheduledAt: $newScheduledAt) {
      success
      message
      post {
        id
        status
        scheduledAt
        failReason
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

const String unschedulePostMutation = r'''
  mutation UnschedulePost($postId: ID!) {
    unschedulePost(postId: $postId) {
      success
      message
      post {
        id
        status
        scheduledAt
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

const String publishPostNowMutation = r'''
  mutation PublishPostNow($postId: ID!) {
    publishPostNow(postId: $postId) {
      success
      message
      post {
        id
        status
        publishedAt
        failReason
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

const String bulkUpdatePostStatusMutation = r'''
  mutation BulkUpdatePostStatus($postIds: [ID!]!, $status: PostStatus!) {
    bulkUpdatePostStatus(postIds: $postIds, status: $status) {
      success
      message
      posts {
        id
        status
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

const String bulkDeletePostsMutation = r'''
  mutation BulkDeletePosts($postIds: [ID!]!) {
    bulkDeletePosts(postIds: $postIds) {
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

const String bulkPostOperationMutation = r'''
  mutation BulkPostOperation($data: BulkPostOperationInput!) {
    bulkPostOperation(data: $data) {
      success
      message
      processedCount
      failedCount
      posts {
        id
        status
        scheduledAt
        publishedAt
      }
      errors
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

const String exportPostsMutation = r'''
  mutation ExportPosts($data: PostExportInput!) {
    exportPosts(data: $data) {
      success
      message
      downloadUrl
      fileSize
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

const String importPostsMutation = r'''
  mutation ImportPosts($data: PostImportInput!) {
    importPosts(data: $data) {
      success
      message
      importedCount
      failedCount
      posts {
        id
        status
        scheduledAt
        content {
          default {
            text
          }
        }
      }
      errors
      error {
        errorCode
        message
        success
        code
      }
    }
  }
''';

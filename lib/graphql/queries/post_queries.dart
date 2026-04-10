const String getPostsQuery = r'''
  query GetPosts($filter: PostFilterInput, $pagination: PaginationInput) {
    getPosts(filter: $filter, pagination: $pagination) {
      __typename
      ... on GetPosts {
        success
        message
        posts {
          id
          status
          content {
            default {
              text
              links
              media {
                url
                type
                altText
                thumbnailUrl
              }
            }
            platformPosts {
              socialConnectionId
              platformPostId
              publishedAt
              status
              error
            }
          }
          targetConnections {
            id
            platform
            platformUsername
            isActive
          }
          scheduledAt
          publishedAt
          failReason
          retryCount
          tags
          isTemplate
          notesCount
          recurrence {
            rrule
            isRecurringParent
            isRecurringInstance
            isException
          }
          createdBy
          createdAt
          updatedAt
        }
        totalCount
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getScheduledPostsQuery = r'''
  query GetScheduledPosts($filter: ScheduledPostFilterInput, $pagination: PaginationInput) {
    getScheduledPosts(filter: $filter, pagination: $pagination) {
      __typename
      ... on GetPosts {
        success
        message
        posts {
          id
          status
          content {
            default {
              text
              links
              media {
                url
                type
                altText
                thumbnailUrl
              }
            }
            platformPosts {
              socialConnectionId
              platformPostId
              publishedAt
              status
              error
            }
          }
          targetConnections {
            id
            platform
            platformUsername
            isActive
          }
          scheduledAt
          publishedAt
          failReason
          retryCount
          tags
          isTemplate
          notesCount
          recurrence {
            rrule
            isRecurringParent
            isRecurringInstance
            isException
          }
          createdBy
          createdAt
          updatedAt
        }
        totalCount
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getDraftPostsQuery = r'''
  query GetDraftPosts($filter: PostFilterInput, $pagination: PaginationInput) {
    getDraftPosts(filter: $filter, pagination: $pagination) {
      __typename
      ... on GetPosts {
        success
        message
        posts {
          id
          status
          content {
            default {
              text
              links
              media {
                url
                type
                altText
                thumbnailUrl
              }
            }
            platformPosts {
              socialConnectionId
              platformPostId
              publishedAt
              status
              error
            }
          }
          targetConnections {
            id
            platform
            platformUsername
            isActive
          }
          scheduledAt
          publishedAt
          failReason
          retryCount
          tags
          isTemplate
          notesCount
          recurrence {
            rrule
            isRecurringParent
            isRecurringInstance
            isException
          }
          createdBy
          createdAt
          updatedAt
        }
        totalCount
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getPostsCalendarQuery = r'''
  query GetPostsCalendar($filter: CalendarFilterInput!) {
    getPostsCalendar(filter: $filter) {
      __typename
      ... on PostsCalendar {
        success
        message
        calendarData {
          date
          posts {
            id
            status
            content {
              default {
                text
              }
            }
            scheduledAt
            publishedAt
            targetConnections {
              id
              platform
              platformUsername
            }
            tags
          }
          postCount
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getDashboardAnalyticsQuery = r'''
  query GetDashboardAnalytics($filter: DashboardAnalyticsFilterInput!) {
    getDashboardAnalytics(filter: $filter) {
      __typename
      ... on DashboardAnalytics {
        success
        message
        totalPosts
        scheduledPosts
        publishedPosts
        failedPosts
        topPerformingPosts {
          id
          content {
            default {
              text
            }
          }
          publishedAt
          targetConnections {
            id
            platform
            platformUsername
          }
        }
        platformBreakdown {
          platform
          postCount
          totalEngagement
          averageEngagement
        }
        engagementTrends {
          date
          engagement
          posts
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getAnalyticsSummaryQuery = r'''
  query GetAnalyticsSummary($filter: AnalyticsSummaryFilterInput!) {
    getAnalyticsSummary(filter: $filter) {
      __typename
      ... on AnalyticsSummaryResult {
        success
        message
        summary {
          totalReach
          totalEngagement
          totalImpressions
          engagementRate
          topPlatform
          bestPerformingPost {
            id
            content {
              default {
                text
              }
            }
            publishedAt
            targetConnections {
              platform
              platformUsername
            }
          }
        }
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

const String getPostAnalyticsQuery = r'''
  query GetPostAnalytics($postId: ID!, $filter: AnalyticsFilterInput!) {
    getPostAnalytics(postId: $postId, filter: $filter) {
      __typename
      ... on PostAnalyticsData {
        success
        message
        analytics {
          id
          platform
          date
          metrics
          fetchedAt
        }
        totalEngagement
        platforms
      }
      ... on Error {
        success
        message
        code
      }
    }
  }
''';

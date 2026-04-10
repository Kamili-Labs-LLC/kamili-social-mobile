const String createSocialConnectionMutation = r'''
  mutation CreateSocialConnection($input: CreateSocialConnectionInput!) {
    createSocialConnection(input: $input) {
      __typename
      ... on GetSocialConnection {
        success
        message
        authUrl
        platform
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String updateSocialConnectionMutation = r'''
  mutation UpdateSocialConnection($id: ID!, $input: UpdateSocialConnectionInput!) {
    updateSocialConnection(id: $id, input: $input) {
      __typename
      ... on GetSocialConnection {
        success
        message
        socialConnection {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
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

const String deleteSocialConnectionMutation = r'''
  mutation DeleteSocialConnection($id: ID!) {
    deleteSocialConnection(id: $id) {
      message
    }
  }
''';

const String validateSocialConnectionMutation = r'''
  mutation ValidateSocialConnection($id: ID!) {
    validateSocialConnection(id: $id) {
      __typename
      ... on GetSocialConnection {
        success
        message
        socialConnection {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
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

const String completeInstagramConnectionMutation = r'''
  mutation CompleteInstagramConnection($input: CompleteInstagramConnectionInput!) {
    completeInstagramConnection(input: $input) {
      success
      message
      accounts {
        id
        username
        name
        profilePictureUrl
        followersCount
        mediaCount
        pageId
        pageName
        pageAccessToken
      }
    }
  }
''';

const String selectInstagramAccountMutation = r'''
  mutation SelectInstagramAccount($input: SelectInstagramAccountInput!) {
    selectInstagramAccount(input: $input) {
      __typename
      ... on GetSocialConnection {
        success
        message
        socialConnection {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
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

const String completeSocialConnectionMutation = r'''
  mutation CompleteSocialConnection($input: CompleteSocialConnectionInput!) {
    completeSocialConnection(input: $input) {
      __typename
      ... on GetSocialConnection {
        success
        message
        socialConnection {
          id
          platform
          platformAccountId
          name
          scopes
          expiresAt
          status
          lastValidatedAt
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

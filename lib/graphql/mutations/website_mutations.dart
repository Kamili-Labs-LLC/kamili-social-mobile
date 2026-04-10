const String createWebsiteMutation = r'''
  mutation CreateWebsite($data: CreateWebsiteInput!) {
    createWebsite(data: $data) {
      __typename
      ... on CreateWebsite {
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

const String updateWebsiteMutation = r'''
  mutation UpdateWebsite($data: UpdateWebsiteInput!) {
    updateWebsite(data: $data) {
      __typename
      ... on UpdateWebsite {
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

const String deleteWebsiteMutation = r'''
  mutation DeleteWebsite($id: ID!) {
    deleteWebsite(id: $id) {
      __typename
      ... on DeleteWebsite {
        message
        success
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String resetSiteKeyMutation = r'''
  mutation ResetSiteKey($websiteId: ID!) {
    resetSiteKey(websiteId: $websiteId) {
      __typename
      ... on ResetSiteKey {
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

const String validateSiteKeyMutation = r'''
  mutation ValidateSiteKey($data: ValidateSiteKeyInput!) {
    validateSiteKey(data: $data) {
      __typename
      ... on ValidateSiteKey {
        message
        isValid
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

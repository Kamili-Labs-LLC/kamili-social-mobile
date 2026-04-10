const String acceptBrandInviteMutation = r'''
  mutation AcceptBrandInvite($token: String!) {
    acceptBrandInvite(token: $token) {
      success
      message
      brandUser {
        id
        userName
        role
        status
        brand {
          id
          name
        }
      }
      brand {
        id
        name
      }
      error {
        errorCode
        message
      }
    }
  }
''';

const String getInviteDetailsQuery = r'''
  query GetInviteDetails($token: String!) {
    getInviteDetails(token: $token) {
      success
      message
      brandName
      accountName
      role
      inviterName
      userEmail
      isExpired
      error {
        errorCode
        message
      }
    }
  }
''';

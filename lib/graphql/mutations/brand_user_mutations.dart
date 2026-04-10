const String inviteBrandUserMutation = r'''
  mutation InviteBrandUser($data: InviteBrandUserInput!) {
    inviteBrandUser(data: $data) {
      __typename
      ... on InviteBrandUser {
        success
        message
        brandUser {
          id
          userEmail
          userName
          role
          status
          createdAt
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String updateBrandUserRoleMutation = r'''
  mutation UpdateBrandUserRole($data: UpdateBrandUserRoleInput!) {
    updateBrandUserRole(data: $data) {
      __typename
      ... on UpdateBrandUserRole {
        success
        message
        brandUser {
          id
          role
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String removeBrandUserMutation = r'''
  mutation RemoveBrandUser($id: ID!) {
    removeBrandUser(id: $id) {
      __typename
      ... on RemoveBrandUser {
        success
        message
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String resendBrandUserInviteMutation = r'''
  mutation ResendBrandUserInvite($id: ID!) {
    resendBrandUserInvite(id: $id) {
      __typename
      ... on ResendBrandUserInvite {
        success
        message
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String createBrandMutation = r'''
  mutation CreateBrand($data: CreateBrandInput!) {
    createBrand(data: $data) {
      __typename
      ... on CreateBrand {
        success
        message
        brand {
          id
          name
          description
          logo
          isActive
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

const String updateBrandMutation = r'''
  mutation UpdateBrand($data: UpdateBrandInput!) {
    updateBrand(data: $data) {
      __typename
      ... on UpdateBrand {
        success
        message
        brand {
          id
          name
          description
          logo
          isActive
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

const String deleteBrandMutation = r'''
  mutation DeleteBrand($id: ID!) {
    deleteBrand(id: $id) {
      __typename
      ... on DeleteBrand {
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

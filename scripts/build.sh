#!/bin/bash
set -euo pipefail

# Kamili Social Mobile — Build Utility Script
# Usage:
#   ./scripts/build.sh --bump-patch --android-aab
#   ./scripts/build.sh --bump-build --ios
#   ./scripts/build.sh --bump-minor --all
#   ./scripts/build.sh --bump-major --dry-run

PUBSPEC="pubspec.yaml"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Flags
BUMP_TYPE=""
BUILD_ANDROID_APK=false
BUILD_ANDROID_AAB=false
BUILD_IOS=false
CLEAN=false
DRY_RUN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [version-bump] [platform] [options]"
    echo ""
    echo "Version bumping:"
    echo "  --bump-build    Increment build number only (1.0.0+1 → 1.0.0+2)"
    echo "  --bump-patch    Increment patch version (1.0.0 → 1.0.1+1)"
    echo "  --bump-minor    Increment minor version (1.0.0 → 1.1.0+1)"
    echo "  --bump-major    Increment major version (1.0.0 → 2.0.0+1)"
    echo ""
    echo "Platform builds:"
    echo "  --android-apk   Build Android APK"
    echo "  --android-aab   Build Android App Bundle (Play Store)"
    echo "  --ios           Build iOS IPA (App Store / TestFlight)"
    echo "  --all           Build both AAB and IPA"
    echo ""
    echo "Options:"
    echo "  --clean         Run flutter clean before building"
    echo "  --dry-run       Show version change only, don't build"
    echo "  --help          Show this help message"
}

parse_args() {
    if [[ $# -eq 0 ]]; then
        print_usage
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            --bump-build)  BUMP_TYPE="build" ;;
            --bump-patch)  BUMP_TYPE="patch" ;;
            --bump-minor)  BUMP_TYPE="minor" ;;
            --bump-major)  BUMP_TYPE="major" ;;
            --android-apk) BUILD_ANDROID_APK=true ;;
            --android-aab) BUILD_ANDROID_AAB=true ;;
            --ios)         BUILD_IOS=true ;;
            --all)         BUILD_ANDROID_AAB=true; BUILD_IOS=true ;;
            --clean)       CLEAN=true ;;
            --dry-run)     DRY_RUN=true ;;
            --help)        print_usage; exit 0 ;;
            *)
                echo -e "${RED}Error: Unknown option $1${NC}"
                print_usage
                exit 1
                ;;
        esac
        shift
    done
}

get_current_version() {
    grep "^version:" "$PROJECT_DIR/$PUBSPEC" | sed 's/version: //' | tr -d '[:space:]'
}

parse_version() {
    local version="$1"
    local version_name="${version%%+*}"
    local build_number="${version##*+}"

    MAJOR=$(echo "$version_name" | cut -d. -f1)
    MINOR=$(echo "$version_name" | cut -d. -f2)
    PATCH=$(echo "$version_name" | cut -d. -f3)
    BUILD="$build_number"
}

bump_version() {
    local current_version
    current_version=$(get_current_version)
    parse_version "$current_version"

    case $BUMP_TYPE in
        build)
            BUILD=$((BUILD + 1))
            ;;
        patch)
            PATCH=$((PATCH + 1))
            BUILD=1
            ;;
        minor)
            MINOR=$((MINOR + 1))
            PATCH=0
            BUILD=1
            ;;
        major)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            BUILD=1
            ;;
    esac

    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}+${BUILD}"

    echo -e "${BLUE}Version: ${YELLOW}${current_version}${NC} → ${GREEN}${NEW_VERSION}${NC}"

    if [[ "$DRY_RUN" == false ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/^version: .*/version: ${NEW_VERSION}/" "$PROJECT_DIR/$PUBSPEC"
        else
            sed -i "s/^version: .*/version: ${NEW_VERSION}/" "$PROJECT_DIR/$PUBSPEC"
        fi
        echo -e "${GREEN}✓ Version updated in $PUBSPEC${NC}"
    else
        echo -e "${YELLOW}(dry run — no changes made)${NC}"
    fi
}

check_prerequisites() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
        exit 1
    fi

    if [[ ! -f "$PROJECT_DIR/$PUBSPEC" ]]; then
        echo -e "${RED}Error: $PUBSPEC not found in $PROJECT_DIR${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Flutter $(flutter --version | head -1 | awk '{print $2}')${NC}"
}

build_android_apk() {
    echo ""
    echo -e "${BLUE}━━━ Building Android APK ━━━${NC}"

    local version_name="${MAJOR}.${MINOR}.${PATCH}"

    flutter build apk --release \
        --build-name="$version_name" \
        --build-number="$BUILD"

    local artifact="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    if [[ -f "$artifact" ]]; then
        local size
        size=$(du -h "$artifact" | cut -f1)
        echo -e "${GREEN}✓ APK built successfully: $artifact ($size)${NC}"
    else
        echo -e "${RED}✗ APK build failed${NC}"
        exit 1
    fi
}

build_android_aab() {
    echo ""
    echo -e "${BLUE}━━━ Building Android App Bundle ━━━${NC}"

    local version_name="${MAJOR}.${MINOR}.${PATCH}"

    flutter build appbundle --release \
        --build-name="$version_name" \
        --build-number="$BUILD"

    local artifact="$PROJECT_DIR/build/app/outputs/bundle/release/app-release.aab"
    if [[ -f "$artifact" ]]; then
        local size
        size=$(du -h "$artifact" | cut -f1)
        echo -e "${GREEN}✓ AAB built successfully: $artifact ($size)${NC}"
    else
        echo -e "${RED}✗ AAB build failed${NC}"
        exit 1
    fi
}

build_ios() {
    echo ""
    echo -e "${BLUE}━━━ Building iOS IPA ━━━${NC}"

    local version_name="${MAJOR}.${MINOR}.${PATCH}"
    local export_plist="$PROJECT_DIR/ios/ExportOptions.plist"

    local build_args=(
        build ipa --release
        --build-name="$version_name"
        --build-number="$BUILD"
    )

    if [[ -f "$export_plist" ]]; then
        build_args+=(--export-options-plist="$export_plist")
    fi

    flutter "${build_args[@]}"

    local artifact="$PROJECT_DIR/build/ios/ipa/kamili_social.ipa"
    if [[ -f "$artifact" ]]; then
        local size
        size=$(du -h "$artifact" | cut -f1)
        echo -e "${GREEN}✓ IPA built successfully: $artifact ($size)${NC}"
    else
        echo -e "${YELLOW}⚠ IPA may have been built with a different name. Check build/ios/ipa/${NC}"
    fi
}

main() {
    cd "$PROJECT_DIR"

    echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Kamili Social — Build Utility      ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
    echo ""

    parse_args "$@"
    check_prerequisites

    # Bump version if requested
    if [[ -n "$BUMP_TYPE" ]]; then
        bump_version
    else
        local current_version
        current_version=$(get_current_version)
        parse_version "$current_version"
        echo -e "${BLUE}Current version: ${GREEN}${current_version}${NC}"
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}Dry run complete. Exiting.${NC}"
        exit 0
    fi

    # Check if any build is requested
    if [[ "$BUILD_ANDROID_APK" == false && "$BUILD_ANDROID_AAB" == false && "$BUILD_IOS" == false ]]; then
        echo -e "${YELLOW}No platform build requested. Version bumped only.${NC}"
        exit 0
    fi

    # Clean if requested
    if [[ "$CLEAN" == true ]]; then
        echo -e "${BLUE}Cleaning project...${NC}"
        flutter clean
        echo -e "${GREEN}✓ Clean complete${NC}"
    fi

    # Get dependencies
    echo -e "${BLUE}Getting dependencies...${NC}"
    flutter pub get
    echo -e "${GREEN}✓ Dependencies resolved${NC}"

    # Build platforms
    if [[ "$BUILD_ANDROID_APK" == true ]]; then
        build_android_apk
    fi

    if [[ "$BUILD_ANDROID_AAB" == true ]]; then
        build_android_aab
    fi

    if [[ "$BUILD_IOS" == true ]]; then
        build_ios
    fi

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Build complete! ✓                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
}

main "$@"

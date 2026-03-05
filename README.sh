#!/usr/bin/env bash
# Git-Brandmauer — README
# This script is informational only. It makes no system changes.

set -euo pipefail

VERSION="1.0.0"
PROJECT_NAME="Git-Brandmauer"
PROJECT_ID="REBK"

print_header() {
cat <<'EOF'
==================================================
                Git-Brandmauer
==================================================
EOF
}

print_short() {
cat <<EOF
$PROJECT_NAME — modular framework for secure Git repository management and network control. 

Shell-based, transparent.
EOF
}

print_about() {
    sed 's/^/  /' docs/EN/about.txt
}

print_usage() {
cat <<'EOF'

USAGE:
   brandmauer            Launch shell help
   brandmauer git        Launch interactive menu for git
   brandmauer net        Launch interactive menu for control net
  ./README.sh            Show full project description
  ./README.sh --short    Show brief description
  ./README.sh --license  Show license information
  ./README.sh --paths    Show project structure

EOF
}

print_license() {
cat <<'EOF'
LICENSE NOTICE:

Git-Brandmauer is free software.

It does NOT include, link, or distribute any proprietary
software or proprietary source code.

Git-Brandmauer:
  • does not modify third-party code
  • does not bypass licensing mechanisms
  • invokes external programs as independent processes
  • operates exclusively on user-owned data

License: MIT
EOF
}

print_paths() {
cat <<'EOF'
PROJECT STRUCTURE (simplified):

  brandmauer     - main entry point
  brandmauer git — interactive entry point for git
  install.sh     — installation helper
  uninstall.sh   - uninstall full framework
  README.sh      — terminal-based project description
  lib/           — internal libraries
  docs/          — extended documentation

EOF
}

print_footer() {
cat <<EOF
Version: $VERSION
EOF
}

main() {
print_header

case "${1:-}" in
  --short)
    print_short
    ;;
  --license)
    print_license
    ;;
  --paths)
    print_paths
    ;;
  *)
    print_about
    print_usage
    print_license
    ;;
esac

print_footer
}

main "$@"
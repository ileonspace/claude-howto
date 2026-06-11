 #!/usr/bin/env bash
  # inject_search.sh - Add Pagefind search to a static site
  # Usage: bash inject_search.sh <site-dir>
  set -euo pipefail

  SITE_DIR="${1:-site-zh}"
  PAGEFIND_VERSION="1.4.0"

  echo "==> Downloading Pagefind v${PAGEFIND_VERSION}..."
  curl -fsSL "https://github.com/CloudCannon/pagefind/releases/download/v${PAGEFIND_VERSION}/pagefind-v${PAGEFIND
  _VERSION}-x86_64-unknown-linux-musl.tar.gz" | tar xz

  echo "==> Indexing site..."
  ./pagefind --site "$SITE_DIR" --output-subdir _pagefind

  echo "==> Injecting Pagefind UI into HTML files..."
  find "$SITE_DIR" -name '*.html' -print0 | while IFS= read -r -d '' f; do
    sed -i 's|</head>|<link href="/_pagefind/pagefind-ui.css" rel="stylesheet" />\n</head>|' "$f"
    sed -i 's|</header>|</header>\n<div class="mx-auto max-w-7xl px-4 py-1 sm:px-6 lg:px-8"><div 
  id="search"></div></div>|' "$f"
    sed -i 's|</body>|<script src="/_pagefind/pagefind-ui.js"></script>\n<script>new 
  PagefindUI({element:"#search",showImages:false,excerptLength:25});</script>\n</body>|' "$f"
  done

  echo "==> Done! Search injected into $SITE_DIR"

 #!/usr/bin/env bash
  # inject_search.sh - Add Pagefind search to a static site
  set -euo pipefail

  SITE_DIR="${1:-site-zh}"
  PAGEFIND_VER="1.4.0"
  URL="https://github.com/CloudCannon/pagefind/releases/download/v${PAGEFIND_VER}/pagefind-v${PAGEFIND_VER}-x86_6
  4-unknown-linux-musl.tar.gz"

  echo "==> Downloading Pagefind v${PAGEFIND_VER}..."
  curl -fsSL "$URL" | tar xz

  echo "==> Indexing site..."
  ./pagefind --site "$SITE_DIR" --output-subdir _pagefind

  echo "==> Injecting Pagefind UI..."
  find "$SITE_DIR" -name '*.html' -print0 | while IFS= read -r -d '' f; do
    sed -i 's|</head>|<link href="/_pagefind/pagefind-ui.css" rel="stylesheet" />\n</head>|' "$f"
    sed -i 's|</header>|</header>\n<div class="mx-auto max-w-7xl px-4 py-1 sm:px-6 lg:px-8"><div 
  id="search"></div></div>|' "$f"
    sed -i 's|</body>|<script src="/_pagefind/pagefind-ui.js"></script>\n<script>new 
  PagefindUI({element:"#search",showImages:false});</script>\n</body>|' "$f"
  done

  echo "==> Done!"

 #!/usr/bin/env bash
  set -euo pipefail

  SITE_DIR="${1:-site-zh}"

  echo "==> Downloading Pagefind..."
  curl -fsSL https://github.com/CloudCannon/pagefind/releases/download/v1.5.2/pagefind-v1.5.2-x86_64-unknown-linux-musl.tar.gz | tar
  xz

  echo "==> Indexing site..."
  ./pagefind --site "$SITE_DIR" --output-subdir _pagefind

  echo "==> Injecting Pagefind UI..."
  find "$SITE_DIR" -name '*.html' -print0 | while IFS= read -r -d '' f; do
    sed -i 's|</head>|<link href="/_pagefind/pagefind-ui.css" rel="stylesheet" />\n</head>|' "$f"
    sed -i 's|</header>|</header>\n<div class="mx-auto max-w-7xl px-4 py-1 sm:px-6 lg:px-8"><div id="search"></div></div>|' "$f"
    sed -i 's|</body>|<script src="/_pagefind/pagefind-ui.js"></script>\n<script>new 
  PagefindUI({element:"#search",showImages:false});</script>\n</body>|' "$f"
  done

  echo "==> Done!"

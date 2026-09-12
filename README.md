# DARKSIDE — SPC Class 12

An original documentary website: *"DARKSIDE — SPC Class 12 | An Original Documentary"* — compiling every memory, night, and version of who we were.

Built with Arena's Code Arena.

## Project structure

```
my-arena-site/
├── index.html   # Single-page app (bundled build: HTML + CSS + JS inlined)
├── images/      # Documentary stills (hero, rooftop, night-bus, premiere, …)
└── README.md
```

## Running locally

This is a fully static site — no build step required. Serve the folder with any static file server:

```bash
# Python
python3 -m http.server 8000

# or Node
npx serve .
```

Then open http://localhost:8000.

## Deploying

Because the site is static, it can be deployed to any static host:

- **GitHub Pages** — enable Pages in repo Settings → Pages and select the `main` branch (root).
- **Netlify / Vercel / Cloudflare Pages** — point at this repo; no build command needed.

## Notes

- The HTML is a production bundle (Vite build) with CSS and JavaScript inlined, exported from the live Arena deployment.
- Fonts (Bebas Neue, Cormorant Garamond, Outfit) are loaded from Google Fonts at runtime.

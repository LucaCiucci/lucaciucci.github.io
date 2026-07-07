# Site Standards

Checklist for keeping this site well-behaved, SEO-friendly, and accessible.

## Every page should have

- [ ] `<title>` — ends with `| Luca Ciucci` (handled automatically by `MainLayout`)
- [ ] `meta description` — concise, descriptive
- [ ] `og:title`, `og:description`, `og:image`
- [ ] `og:type` — `"article"` for blog posts and project pages, `"website"` otherwise
- [ ] Canonical URL
- [ ] Alt text on all images (use `alt=""` for decorative ones)
- [ ] Proper heading hierarchy (`h1` → `h2` → `h3`, no skips)

## Layouts

```
MainLayout (nav, meta, theme, pagefind search)
  └── Article (generic: back link, eyebrow, title, subtitle, tags, content)
        ├── ProjectArticle (project-specific defaults)
        └── BlogPage (blog defaults + TL;DR Callout)
```

- `Article` sets `og:type="article"` automatically
- `ProjectArticle` passes `description` as `subtitle` (deduplication is handled)
- `BlogPage` expects `date` as a `Date` object, formats it for the eyebrow

## Content collections

### Projects (`src/content/projects/`)
```ts
title: string
description: string        // shown as subtitle + meta description
date?: string              // ISO date string
tags?: string[]
status?: "complete" | "archive" | "external" | "active"
image?: string
imageAlt?: string
```

### Blog posts (`src/pages/blog/YYYY/MM/DD.mdx`)
```yaml
layout: $layouts/BlogPage.astro
title: string
subtitle?: string          # shown under the title
date: YYYY-MM-DD           # Date object
description: string        # meta description + TL;DR Callout
tags?: string[]            # displayed as pills
image?: string             # shown in OG cards
imageAlt?: string
```

## Infrastructure

- [ ] `npx astro build` passes with no errors before deploying
- [ ] Sitemap regenerates automatically (`@astrojs/sitemap`)
- [ ] OG images are SVGs → auto-rasterized to PNG for social platforms
- [ ] Analytics: Umami, loads async, production only
- [ ] Search: Pagefind, included in all pages via `MainLayout`
- [ ] `robots.txt` at `/robots.txt` points to sitemap

## Future improvements

- [ ] JSON-LD structured data (schema.org `Person`, `Article`, `WebSite`)
- [ ] RSS feed for blog

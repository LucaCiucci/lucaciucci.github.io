# lucaciucci.github.io

Personal website built with Astro and MDX. The CV page shares its data with the
Typst PDF generator in the `deps/CV` submodule.

## Requirements

- Node.js 22.12 or newer
- npm
- Typst
- GNU Make
- ImageMagick

Initialize the CV submodule after cloning:

```sh
git submodule update --init --recursive
npm install
```

## Development

```sh
npm run dev
```

## Production Build

```sh
npm run build
```

The build first generates the CV PDF and optimized CV images through
`make -C deps/CV`, then builds the static Astro site into `dist/`.

Regenerate the local Pagefind search index with:

```sh
npm run search:dev
```

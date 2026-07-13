// @ts-check
import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';
import yaml from '@rollup/plugin-yaml';
import sitemap from '@astrojs/sitemap';

import icon from 'astro-icon';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import { unified } from '@astrojs/markdown-remark';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';

const processor = unified({
  rehypePlugins: [
    rehypeSlug,
    [
      rehypeAutolinkHeadings,
      {
        behavior: 'wrap',
        properties: {
          className: ['heading-anchor'],
        },
      },
    ],
  ],
});

// https://astro.build/config
export default defineConfig({
  site: 'https://lucaciucci99.com',
  integrations: [mdx(), icon(), sitemap()],
  markdown: {
    processor,
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  vite: {
    plugins: [yaml()],
    resolve: {
      alias: {
        '$layouts': '/src/layouts',
      },
    },
  },
});
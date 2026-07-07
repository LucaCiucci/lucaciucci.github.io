import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';

export const collections = {
  projects: defineCollection({
    loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/projects' }),
    schema: z.object({
      title: z.string(),
      description: z.string(),
      date: z.string().optional(),
      tags: z.array(z.string()).default([]),
      status: z.enum(['complete', 'archive', 'external', 'active']).optional(),
      image: z.string().optional(),
      imageAlt: z.string().optional(),
    }),
  }),
  blog_posts: defineCollection({
    //loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/blog_posts' }),
    loader: glob({ pattern: '**/20*/**/[^_]*.{md,mdx}', base: './src/pages/blog' }),
    schema: z.object({
      title: z.string(),
      subtitle: z.string().optional(),
      description: z.string().optional(),
      date: z.date().optional(),
      tags: z.array(z.string()).default([]),
    }),
  }),
};

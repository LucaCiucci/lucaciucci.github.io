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
};

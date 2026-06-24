import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

export const collections = {
  projects: defineCollection({
    loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/projects' }),
    schema: z.object({
      title: z.string(),
      description: z.string(),
      date: z.string().optional(),
      tags: z.array(z.string()).default([]),
      status: z.enum(['complete', 'archive', 'external']).optional(),
      image: z.string().optional(),
      imageAlt: z.string().optional(),
    }),
  }),
};

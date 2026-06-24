import { getCollection, type CollectionEntry } from 'astro:content';

type YamlProject = {
  title?: string;
  href?: string;
  description?: string;
  date?: string;
  tags?: string[];
  featured?: number;
  status?: string;
};

type MergedProject = {
  title: string;
  description: string;
  href?: string;
  date?: string;
  tags: string[];
  featured?: number;
  status?: string;
  image?: string;
  imageAlt?: string;
};

export async function mergeProjects(yamlProjects: YamlProject[]): Promise<MergedProject[]> {
  const collectionProjects = await getCollection('projects');

  return yamlProjects.map((yamlEntry) => {
    if (!yamlEntry.href) return yamlEntry as MergedProject;

    const slug = yamlEntry.href.replace('/projects/', '');
    const colEntry = collectionProjects.find((c) => c.id === slug);

    if (colEntry) {
      return {
        title: colEntry.data.title,
        description: colEntry.data.description,
        href: yamlEntry.href,
        date: colEntry.data.date,
        tags: colEntry.data.tags,
        featured: yamlEntry.featured,
        status: colEntry.data.status,
        image: colEntry.data.image,
        imageAlt: colEntry.data.imageAlt,
      };
    }
    return yamlEntry as MergedProject;
  });
}

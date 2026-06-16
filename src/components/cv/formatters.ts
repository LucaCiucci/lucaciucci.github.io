export function formatMonth(date: Date | string): string {
  if (typeof date === 'string') return date;

  return date.toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
  });
}

export function formatPublicationDate(date: Date | string): string {
  if (date instanceof Date) {
    return date.toLocaleDateString('en-GB', { year: 'numeric', month: 'short' });
  }

  const match = date.match(/^(\d{4})(?:-(\d{2}))?/);
  if (!match) return date;

  const parsed = new Date(Number(match[1]), Number(match[2] ?? 1) - 1);
  return parsed.toLocaleDateString('en-GB', {
    year: 'numeric',
    month: match[2] ? 'short' : undefined,
  });
}

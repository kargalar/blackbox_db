// Supabase migration service stub - to be implemented
export async function getAverageRatingsForContentIds(ids: string[]): Promise<Record<string, number>> {
  // TODO: Fetch from Supabase RPC/view
  return Object.fromEntries(ids.map((id) => [id, Math.round(Math.random() * 80) / 10]));
}

import siteConfig from '../config/site';

/**
 * Format number as Indian Rupee (e.g. ₹1,499)
 */
export function formatINR(amount: number): string {
  return `${siteConfig.currencySymbol}${amount.toLocaleString('en-IN')}`;
}

/**
 * Format condition badge color classes
 */
export function getConditionBadgeClass(condition: string): string {
  switch (condition) {
    case 'Like New':
      return 'bg-emerald-950 text-emerald-300 border-emerald-800';
    case 'Good':
      return 'bg-amber-950 text-amber-300 border-amber-800';
    case 'Fair':
      return 'bg-stone-800 text-stone-300 border-stone-700';
    default:
      return 'bg-brand-muted text-brand-dark border-brand-border';
  }
}

/**
 * Format human-readable date
 */
export function formatDate(dateString: string): string {
  try {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-IN', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  } catch {
    return dateString;
  }
}

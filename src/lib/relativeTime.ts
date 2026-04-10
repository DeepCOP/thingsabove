const TIME_UNITS = [
  { maxSeconds: 60, secondsPerUnit: 1, label: 's' },
  { maxSeconds: 60 * 60, secondsPerUnit: 60, label: 'm' },
  { maxSeconds: 60 * 60 * 24, secondsPerUnit: 60 * 60, label: 'h' },
  { maxSeconds: 60 * 60 * 24 * 7, secondsPerUnit: 60 * 60 * 24, label: 'd' },
  { maxSeconds: 60 * 60 * 24 * 30, secondsPerUnit: 60 * 60 * 24 * 7, label: 'w' },
  { maxSeconds: 60 * 60 * 24 * 365, secondsPerUnit: 60 * 60 * 24 * 30, label: 'mo' },
] as const;

export function formatRelativeTime(value: string | Date) {
  const date = value instanceof Date ? value : new Date(value);

  if (Number.isNaN(date.getTime())) {
    return '';
  }

  const diffInSeconds = Math.round((Date.now() - date.getTime()) / 1000);
  const isPast = diffInSeconds >= 0;
  const absoluteSeconds = Math.abs(diffInSeconds);

  if (absoluteSeconds < 10) {
    return isPast ? 'just now' : 'soon';
  }

  for (const unit of TIME_UNITS) {
    if (absoluteSeconds < unit.maxSeconds) {
      const valueInUnit = Math.max(1, Math.round(absoluteSeconds / unit.secondsPerUnit));
      return isPast ? `${valueInUnit}${unit.label} ago` : `in ${valueInUnit}${unit.label}`;
    }
  }

  const years = Math.max(1, Math.round(absoluteSeconds / (60 * 60 * 24 * 365)));
  return isPast ? `${years}y ago` : `in ${years}y`;
}

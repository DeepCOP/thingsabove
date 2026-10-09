import dayjs, { type Dayjs } from 'dayjs';
import 'dayjs/locale/es';
import 'dayjs/locale/pt';
import 'dayjs/locale/zh-cn';
import 'dayjs/locale/zh-tw';

export const getDayjsLocale = (language?: string) => {
  if (language?.startsWith('es')) return 'es';
  if (language?.startsWith('pt')) return 'pt';
  if (language?.startsWith('zh-Hant')) return 'zh-tw';
  if (language?.startsWith('zh')) return 'zh-cn';
  return 'en';
};

export const formatShortDate = (date: Dayjs, language?: string) => {
  const format = language?.startsWith('zh')
    ? 'M月D日'
    : language?.startsWith('es') || language?.startsWith('pt')
      ? 'D MMM'
      : 'MMM DD';
  return date.locale(getDayjsLocale(language)).format(format);
};

export const formatLongDate = (date: Dayjs, language?: string) => {
  const format = language?.startsWith('zh')
    ? 'YYYY年M月D日'
    : language?.startsWith('es') || language?.startsWith('pt')
      ? 'D [de] MMMM [de] YYYY'
      : 'MMMM DD, YYYY';
  return date.locale(getDayjsLocale(language)).format(format);
};

export type { Dayjs };
export default dayjs;

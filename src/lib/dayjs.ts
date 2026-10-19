import dayjs, { type Dayjs } from 'dayjs';
import 'dayjs/locale/es';
import 'dayjs/locale/fr';
import 'dayjs/locale/hi';
import 'dayjs/locale/id';
import 'dayjs/locale/ko';
import 'dayjs/locale/pt';
import 'dayjs/locale/sw';
import 'dayjs/locale/tl-ph';
import 'dayjs/locale/zh-cn';
import 'dayjs/locale/zh-tw';

export const getDayjsLocale = (language?: string) => {
  if (language?.startsWith('es')) return 'es';
  if (language?.startsWith('fil') || language?.startsWith('tl')) return 'tl-ph';
  if (language?.startsWith('fr')) return 'fr';
  if (language?.startsWith('hi')) return 'hi';
  if (language?.startsWith('id')) return 'id';
  if (language?.startsWith('ko')) return 'ko';
  if (language?.startsWith('pt')) return 'pt';
  if (language?.startsWith('sw')) return 'sw';
  if (language?.startsWith('zh-Hant')) return 'zh-tw';
  if (language?.startsWith('zh')) return 'zh-cn';
  return 'en';
};

export const formatShortDate = (date: Dayjs, language?: string) => {
  const locale = getDayjsLocale(language);
  const format =
    locale === 'zh-cn' || locale === 'zh-tw'
      ? 'M月D日'
      : locale === 'ko'
        ? 'M월 D일'
        : ['es', 'fr', 'hi', 'id', 'pt', 'sw'].includes(locale)
          ? 'D MMM'
          : locale === 'tl-ph'
            ? 'MMM D'
            : 'MMM DD';
  return date.locale(locale).format(format);
};

export const formatLongDate = (date: Dayjs, language?: string) => {
  const locale = getDayjsLocale(language);
  const format =
    locale === 'zh-cn' || locale === 'zh-tw'
      ? 'YYYY年M月D日'
      : locale === 'ko'
        ? 'YYYY년 M월 D일'
        : locale === 'es' || locale === 'pt'
          ? 'D [de] MMMM [de] YYYY'
          : ['fr', 'hi', 'id', 'sw'].includes(locale)
            ? 'D MMMM YYYY'
            : locale === 'tl-ph'
              ? 'MMMM D, YYYY'
              : 'MMMM DD, YYYY';
  return date.locale(locale).format(format);
};

export type { Dayjs };
export default dayjs;

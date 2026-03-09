import { ProfileWithChurch, SignUpProfileInput, UpdateProfileInput } from './types/types';

const MIN_NAME_LENGTH = 2;
const MAX_NAME_LENGTH = 50;
const MIN_YEAR = 1900;
const CURRENT_YEAR = new Date().getFullYear();

export type ProfileDetailsFormValues = {
  firstName: string;
  lastName: string;
  isBeliever: boolean | null;
  yearBelieved: string;
  isBaptized: boolean | null;
  yearBaptized: string;
  attendsChurchRegularly: boolean | null;
  churchName: string;
  churchAddress: string;
  churchWebsiteUrl: string;
};

export type ProfileDetailsFormErrors = Partial<Record<keyof ProfileDetailsFormValues, string>>;

const emptyToNull = (value: string) => {
  const trimmed = value.trim();
  return trimmed ? trimmed : null;
};

const parseOptionalYear = (value: string) => {
  const trimmed = value.trim();
  if (!trimmed) return null;

  const year = Number(trimmed);
  return Number.isInteger(year) ? year : null;
};

export const normalizeWebsiteUrl = (value: string) => {
  const trimmed = value.trim();
  if (!trimmed) return '';

  if (/^https?:\/\//i.test(trimmed)) {
    return trimmed;
  }

  return `https://${trimmed}`;
};

const isValidWebsiteUrl = (value: string) => {
  if (!value.trim()) return true;

  try {
    const url = new URL(normalizeWebsiteUrl(value));
    return Boolean(url.hostname);
  } catch {
    return false;
  }
};

const isValidYear = (year: number | null) => {
  return year !== null && year >= MIN_YEAR && year <= CURRENT_YEAR;
};

export const buildProfileDetailsFormValues = (
  profile?: ProfileWithChurch | null,
): ProfileDetailsFormValues => ({
  firstName: profile?.first_name ?? '',
  lastName: profile?.last_name ?? '',
  isBeliever: profile?.is_believer ?? null,
  yearBelieved: profile?.year_believed ? String(profile.year_believed) : '',
  isBaptized: profile?.is_baptized ?? null,
  yearBaptized: profile?.year_baptized ? String(profile.year_baptized) : '',
  attendsChurchRegularly: profile?.attends_church_regularly ?? null,
  churchName: profile?.church?.name ?? '',
  churchAddress: profile?.church?.address ?? '',
  churchWebsiteUrl: profile?.church?.website_url ?? '',
});

export const getYearsFollowingJesus = (value: string | number | null | undefined) => {
  const year = typeof value === 'number' ? value : parseOptionalYear(value ?? '');
  if (!isValidYear(year) || year === null) return null;

  const years = CURRENT_YEAR - year;
  return years >= 0 ? years : null;
};

export const validateProfileDetailsForm = (
  values: ProfileDetailsFormValues,
  {
    requireName = true,
    requireChoices = true,
  }: { requireName?: boolean; requireChoices?: boolean } = {},
): ProfileDetailsFormErrors => {
  const errors: ProfileDetailsFormErrors = {};
  const yearBelieved = parseOptionalYear(values.yearBelieved);
  const yearBaptized = parseOptionalYear(values.yearBaptized);

  if (requireName) {
    const firstName = values.firstName.trim();
    const lastName = values.lastName.trim();

    if (firstName.length < MIN_NAME_LENGTH || firstName.length > MAX_NAME_LENGTH) {
      errors.firstName = `First name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} characters.`;
    }

    if (lastName.length < MIN_NAME_LENGTH || lastName.length > MAX_NAME_LENGTH) {
      errors.lastName = `Last name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} characters.`;
    }
  }

  if (requireChoices && values.isBeliever === null) {
    errors.isBeliever = 'Choose whether you believe in Jesus.';
  }

  if (values.isBeliever === true) {
    if (!isValidYear(yearBelieved)) {
      errors.yearBelieved = `Enter a valid year between ${MIN_YEAR} and ${CURRENT_YEAR}.`;
    }

    if (requireChoices && values.isBaptized === null) {
      errors.isBaptized = 'Choose whether you have been baptized.';
    }

    if (values.isBaptized === true) {
      if (!isValidYear(yearBaptized)) {
        errors.yearBaptized = `Enter a valid year between ${MIN_YEAR} and ${CURRENT_YEAR}.`;
      } else if (yearBelieved !== null && yearBaptized !== null && yearBaptized < yearBelieved) {
        errors.yearBaptized = 'Year baptized cannot be earlier than year believed.';
      }
    }
  }

  if (requireChoices && values.attendsChurchRegularly === null) {
    errors.attendsChurchRegularly = 'Choose whether you meet at a church regularly.';
  }

  if (values.attendsChurchRegularly === true) {
    if (!values.churchName.trim()) {
      errors.churchName = 'Enter your church name.';
    }

    if (!isValidWebsiteUrl(values.churchWebsiteUrl)) {
      errors.churchWebsiteUrl = 'Enter a valid church website URL.';
    }
  }

  return errors;
};

export const hasProfileDetailsErrors = (errors: ProfileDetailsFormErrors) =>
  Object.values(errors).some(Boolean);

export const toUpdateProfileInput = (values: ProfileDetailsFormValues): UpdateProfileInput => {
  const normalizedWebsiteUrl = normalizeWebsiteUrl(values.churchWebsiteUrl);

  return {
    first_name: values.firstName.trim() || undefined,
    last_name: values.lastName.trim() || undefined,
    is_believer: values.isBeliever,
    year_believed: values.isBeliever ? parseOptionalYear(values.yearBelieved) : null,
    is_baptized: values.isBeliever ? values.isBaptized : null,
    year_baptized:
      values.isBeliever && values.isBaptized ? parseOptionalYear(values.yearBaptized) : null,
    attends_church_regularly: values.attendsChurchRegularly,
    church_name: values.attendsChurchRegularly ? emptyToNull(values.churchName) : null,
    church_address: values.attendsChurchRegularly ? emptyToNull(values.churchAddress) : null,
    church_website_url: values.attendsChurchRegularly ? emptyToNull(normalizedWebsiteUrl) : null,
    clear_church: values.attendsChurchRegularly !== true || !values.churchName.trim(),
  };
};

export const toSignUpProfileInput = (
  email: string,
  password: string,
  values: ProfileDetailsFormValues,
): SignUpProfileInput => {
  const profileInput = toUpdateProfileInput(values);

  return {
    email,
    password,
    firstName: values.firstName.trim(),
    lastName: values.lastName.trim(),
    isBeliever: values.isBeliever === true,
    yearBelieved: profileInput.year_believed ?? null,
    isBaptized: profileInput.is_baptized ?? null,
    yearBaptized: profileInput.year_baptized ?? null,
    attendsChurchRegularly: values.attendsChurchRegularly === true,
    churchName: profileInput.church_name ?? null,
    churchAddress: profileInput.church_address ?? null,
    churchWebsiteUrl: profileInput.church_website_url ?? null,
  };
};

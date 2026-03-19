import {
  ProfileWithChurch,
  SignUpAboutDetailsInput,
  SignUpProfileInput,
  UpdateProfileInput,
} from './types/types';

export const MIN_NAME_LENGTH = 2;
export const MAX_NAME_LENGTH = 50;
export const MAX_BIO_LENGTH = 280;
export const MAX_CHURCH_NAME_LENGTH = 100;
export const MAX_CHURCH_ADDRESS_LENGTH = 200;
export const MAX_CHURCH_WEBSITE_URL_LENGTH = 255;
const MIN_YEAR = 1900;
const CURRENT_YEAR = new Date().getFullYear();

export type ProfileDetailsFormValues = {
  firstName: string;
  lastName: string;
  bio: string;
  yearBelieved: string;
  yearBaptized: string;
  churchId: string | null;
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
  bio: profile?.bio ?? '',
  yearBelieved: profile?.year_believed ? String(profile.year_believed) : '',
  yearBaptized: profile?.year_baptized ? String(profile.year_baptized) : '',
  churchId: profile?.church?.id ?? null,
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
  { requireName = true }: { requireName?: boolean } = {},
): ProfileDetailsFormErrors => {
  const errors: ProfileDetailsFormErrors = {};
  const yearBelieved = parseOptionalYear(values.yearBelieved);
  const yearBaptized = parseOptionalYear(values.yearBaptized);
  const churchName = values.churchName.trim();
  const churchAddress = values.churchAddress.trim();
  const churchWebsiteUrl = values.churchWebsiteUrl.trim();
  const hasYearBelievedInput = Boolean(values.yearBelieved.trim());
  const hasYearBaptizedInput = Boolean(values.yearBaptized.trim());

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

  if (values.bio.trim().length > MAX_BIO_LENGTH) {
    errors.bio = `Bio or favorite verse must be ${MAX_BIO_LENGTH} characters or fewer.`;
  }

  if (hasYearBelievedInput && !isValidYear(yearBelieved)) {
    errors.yearBelieved = `Enter a valid year between ${MIN_YEAR} and ${CURRENT_YEAR}.`;
  }

  if (hasYearBaptizedInput && !isValidYear(yearBaptized)) {
    errors.yearBaptized = `Enter a valid year between ${MIN_YEAR} and ${CURRENT_YEAR}.`;
  }

  if (yearBelieved !== null && yearBaptized !== null && yearBaptized < yearBelieved) {
    errors.yearBaptized = 'Year baptized cannot be earlier than year believed.';
  }

  const hasChurchId = Boolean(values.churchId);
  const hasChurchName = Boolean(churchName);
  const hasChurchDetails =
    hasChurchId || hasChurchName || Boolean(churchAddress) || Boolean(churchWebsiteUrl);

  if (hasChurchDetails && !hasChurchName && !hasChurchId) {
    errors.churchName = 'Enter your church name.';
  }

  if (churchName.length > MAX_CHURCH_NAME_LENGTH) {
    errors.churchName = `Church name must be ${MAX_CHURCH_NAME_LENGTH} characters or fewer.`;
  }

  if (churchAddress.length > MAX_CHURCH_ADDRESS_LENGTH) {
    errors.churchAddress = `Church address must be ${MAX_CHURCH_ADDRESS_LENGTH} characters or fewer.`;
  }

  if (churchWebsiteUrl.length > MAX_CHURCH_WEBSITE_URL_LENGTH) {
    errors.churchWebsiteUrl = `Church website URL must be ${MAX_CHURCH_WEBSITE_URL_LENGTH} characters or fewer.`;
  } else if (churchWebsiteUrl && !isValidWebsiteUrl(values.churchWebsiteUrl)) {
    errors.churchWebsiteUrl = 'Enter a valid church website URL.';
  }

  return errors;
};

export const hasProfileDetailsErrors = (errors: ProfileDetailsFormErrors) =>
  Object.values(errors).some(Boolean);

export const toUpdateProfileInput = (values: ProfileDetailsFormValues): UpdateProfileInput => {
  const normalizedWebsiteUrl = normalizeWebsiteUrl(values.churchWebsiteUrl);
  const yearBelieved = parseOptionalYear(values.yearBelieved);
  const yearBaptized = parseOptionalYear(values.yearBaptized);
  const hasChurchId = Boolean(values.churchId);
  const hasChurchName = Boolean(values.churchName.trim());
  const hasChurchDetails =
    hasChurchId ||
    hasChurchName ||
    Boolean(values.churchAddress.trim()) ||
    Boolean(values.churchWebsiteUrl.trim());

  return {
    first_name: values.firstName.trim() || undefined,
    last_name: values.lastName.trim() || undefined,
    bio: values.bio.trim() || undefined,
    year_believed: yearBelieved,
    year_baptized: yearBaptized,
    church_id: hasChurchId ? values.churchId : null,
    church_name: !hasChurchId && hasChurchName ? emptyToNull(values.churchName) : null,
    church_address: !hasChurchId && hasChurchName ? emptyToNull(values.churchAddress) : null,
    church_website_url: !hasChurchId && hasChurchName ? emptyToNull(normalizedWebsiteUrl) : null,
    clear_church: !hasChurchDetails,
  };
};

export const toSignUpAboutDetailsInput = (
  values: ProfileDetailsFormValues,
): Omit<SignUpAboutDetailsInput, 'user_id' | 'email'> => {
  const normalizedWebsiteUrl = normalizeWebsiteUrl(values.churchWebsiteUrl);
  const yearBelieved = parseOptionalYear(values.yearBelieved);
  const yearBaptized = parseOptionalYear(values.yearBaptized);
  const hasChurchId = Boolean(values.churchId);
  const hasChurchName = Boolean(values.churchName.trim());
  const hasChurchDetails =
    hasChurchId ||
    hasChurchName ||
    Boolean(values.churchAddress.trim()) ||
    Boolean(values.churchWebsiteUrl.trim());

  return {
    year_believed: yearBelieved,
    year_baptized: yearBaptized,
    church_id: hasChurchId ? values.churchId : null,
    church_name: !hasChurchId && hasChurchName ? emptyToNull(values.churchName) : null,
    church_address: !hasChurchId && hasChurchName ? emptyToNull(values.churchAddress) : null,
    church_website_url: !hasChurchId && hasChurchName ? emptyToNull(normalizedWebsiteUrl) : null,
    clear_church: !hasChurchDetails,
  };
};

export const toSignUpProfileInput = (
  email: string,
  password: string,
  values: ProfileDetailsFormValues,
): SignUpProfileInput => {
  const normalizedWebsiteUrl = normalizeWebsiteUrl(values.churchWebsiteUrl);
  const yearBelieved = parseOptionalYear(values.yearBelieved);
  const yearBaptized = parseOptionalYear(values.yearBaptized);
  const hasChurchName = Boolean(values.churchName.trim());

  return {
    email,
    password,
    firstName: values.firstName.trim(),
    lastName: values.lastName.trim(),
    yearBelieved,
    yearBaptized,
    churchName: hasChurchName ? emptyToNull(values.churchName) : null,
    churchAddress: hasChurchName ? emptyToNull(values.churchAddress) : null,
    churchWebsiteUrl: hasChurchName ? emptyToNull(normalizedWebsiteUrl) : null,
  };
};

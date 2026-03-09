import {
  ProfileDetailsFormErrors,
  ProfileDetailsFormValues,
  getYearsFollowingJesus,
} from '@/src/profileDetails';
import { Input } from '@rneui/themed';
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native';

type BooleanChoiceProps = {
  label: string;
  trueLabel?: string;
  falseLabel?: string;
  value: boolean | null;
  disabled?: boolean;
  error?: string;
  onChange: (value: boolean) => void;
};

function BooleanChoice({
  label,
  trueLabel = 'Yes',
  falseLabel = 'No',
  value,
  disabled,
  error,
  onChange,
}: BooleanChoiceProps) {
  return (
    <View className="mb-4 px-2">
      <Text className="mb-2 text-base font-medium text-gray-900 dark:text-white">{label}</Text>
      <View className="flex-row gap-3">
        <TouchableOpacity
          disabled={disabled}
          onPress={() => onChange(true)}
          className={`flex-1 rounded-xl border px-4 py-3 ${
            value === true
              ? 'border-black bg-black dark:border-white dark:bg-white'
              : 'border-gray-300 bg-white dark:border-neutral-700 dark:bg-neutral-900'
          }`}>
          <Text
            className={`text-center font-medium ${
              value === true ? 'text-white dark:text-black' : 'text-gray-800 dark:text-gray-200'
            }`}>
            {trueLabel}
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          disabled={disabled}
          onPress={() => onChange(false)}
          className={`flex-1 rounded-xl border px-4 py-3 ${
            value === false
              ? 'border-black bg-black dark:border-white dark:bg-white'
              : 'border-gray-300 bg-white dark:border-neutral-700 dark:bg-neutral-900'
          }`}>
          <Text
            className={`text-center font-medium ${
              value === false ? 'text-white dark:text-black' : 'text-gray-800 dark:text-gray-200'
            }`}>
            {falseLabel}
          </Text>
        </TouchableOpacity>
      </View>

      {error ? <Text className="mt-2 px-1 text-sm text-red-600">{error}</Text> : null}
    </View>
  );
}

export default function ProfileDetailsForm({
  values,
  errors,
  onChange,
  showNameFields = true,
  disabled = false,
}: {
  values: ProfileDetailsFormValues;
  errors?: ProfileDetailsFormErrors;
  onChange: (patch: Partial<ProfileDetailsFormValues>) => void;
  showNameFields?: boolean;
  disabled?: boolean;
}) {
  const colorScheme = useColorScheme();
  const yearsFollowingJesus = getYearsFollowingJesus(values.yearBelieved);
  const textColor = colorScheme === 'dark' ? '#F5F5F5' : '#424242';

  return (
    <View>
      {showNameFields ? (
        <>
          <Input
            label="First Name"
            value={values.firstName}
            onChangeText={(firstName) => onChange({ firstName })}
            editable={!disabled}
            autoCapitalize="words"
            maxLength={50}
            errorMessage={errors?.firstName}
            style={{ color: textColor }}
            placeholderTextColor={textColor}
          />
          <Input
            label="Last Name"
            value={values.lastName}
            onChangeText={(lastName) => onChange({ lastName })}
            editable={!disabled}
            autoCapitalize="words"
            maxLength={50}
            errorMessage={errors?.lastName}
            style={{ color: textColor }}
            placeholderTextColor={textColor}
          />
        </>
      ) : null}

      <View className="px-2">
        <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">
          Faith Journey
        </Text>
      </View>

      <BooleanChoice
        label="Do you believe in Jesus?"
        trueLabel="Yes"
        falseLabel="Not yet"
        value={values.isBeliever}
        disabled={disabled}
        error={errors?.isBeliever}
        onChange={(isBeliever) =>
          onChange(
            isBeliever
              ? { isBeliever: true }
              : {
                  isBeliever: false,
                  yearBelieved: '',
                  isBaptized: null,
                  yearBaptized: '',
                },
          )
        }
      />

      {values.isBeliever === true ? (
        <>
          <Input
            label="Year You Believed"
            value={values.yearBelieved}
            onChangeText={(yearBelieved) => onChange({ yearBelieved })}
            editable={!disabled}
            keyboardType="number-pad"
            maxLength={4}
            errorMessage={errors?.yearBelieved}
            style={{ color: textColor }}
            placeholder="2020"
            placeholderTextColor={textColor}
          />

          {yearsFollowingJesus !== null ? (
            <Text className="-mt-6 mb-4 px-3 text-sm text-gray-600 dark:text-gray-400">
              {yearsFollowingJesus} year{yearsFollowingJesus === 1 ? '' : 's'} following Jesus
            </Text>
          ) : null}

          <BooleanChoice
            label="Have you been baptized?"
            value={values.isBaptized}
            disabled={disabled}
            error={errors?.isBaptized}
            onChange={(isBaptized) =>
              onChange(isBaptized ? { isBaptized: true } : { isBaptized: false, yearBaptized: '' })
            }
          />

          {values.isBaptized === true ? (
            <Input
              label="Year You Were Baptized"
              value={values.yearBaptized}
              onChangeText={(yearBaptized) => onChange({ yearBaptized })}
              editable={!disabled}
              keyboardType="number-pad"
              maxLength={4}
              errorMessage={errors?.yearBaptized}
              style={{ color: textColor }}
              placeholder="2021"
              placeholderTextColor={textColor}
            />
          ) : null}
        </>
      ) : null}

      <View className="px-2 pt-2">
        <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">Church</Text>
      </View>

      <BooleanChoice
        label="Do you meet at a church regularly?"
        value={values.attendsChurchRegularly}
        disabled={disabled}
        error={errors?.attendsChurchRegularly}
        onChange={(attendsChurchRegularly) =>
          onChange(
            attendsChurchRegularly
              ? { attendsChurchRegularly: true }
              : {
                  attendsChurchRegularly: false,
                  churchName: '',
                  churchAddress: '',
                  churchWebsiteUrl: '',
                },
          )
        }
      />

      {values.attendsChurchRegularly === true ? (
        <>
          <Input
            label="Church Name"
            value={values.churchName}
            onChangeText={(churchName) => onChange({ churchName })}
            editable={!disabled}
            autoCapitalize="words"
            errorMessage={errors?.churchName}
            style={{ color: textColor }}
            placeholderTextColor={textColor}
          />
          <Input
            label="Church Address"
            value={values.churchAddress}
            onChangeText={(churchAddress) => onChange({ churchAddress })}
            editable={!disabled}
            autoCapitalize="words"
            errorMessage={errors?.churchAddress}
            style={{ color: textColor }}
            placeholderTextColor={textColor}
          />
          <Input
            label="Church Website URL"
            value={values.churchWebsiteUrl}
            onChangeText={(churchWebsiteUrl) => onChange({ churchWebsiteUrl })}
            editable={!disabled}
            autoCapitalize="none"
            autoCorrect={false}
            keyboardType="url"
            errorMessage={errors?.churchWebsiteUrl}
            style={{ color: textColor }}
            placeholder="https://example.org"
            placeholderTextColor={textColor}
          />
        </>
      ) : null}
    </View>
  );
}

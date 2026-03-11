import { ProfileDetailsFormValues, buildProfileDetailsFormValues } from '@/src/profileDetails';
import { create } from 'zustand';

type SignUpDetailsState = {
  details: ProfileDetailsFormValues;
  setDetails: (patch: Partial<ProfileDetailsFormValues>) => void;
  resetDetails: () => void;
};

export const useSignUpDetailsStore = create<SignUpDetailsState>((set) => ({
  details: buildProfileDetailsFormValues(),
  setDetails: (patch) =>
    set((state) => ({
      details: { ...state.details, ...patch },
    })),
  resetDetails: () => set({ details: buildProfileDetailsFormValues() }),
}));

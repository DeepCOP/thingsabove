// /context/BibleContext.ts
import { useAppStore } from '@/store/useAppStore';
import { createContext, ReactNode, useContext } from 'react';
import asv from '../assets/versions/asv.json';
import kjv from '../assets/versions/kjv.json';
const BibleContext = createContext<any>(null);

export type BibleJSON = {
  [bookName: string]: {
    [chapter: string]: {
      [verse: string]: string; // or { title: string, 1: "...", 2: "..." }
    };
  };
};

export function BibleProvider({ children }: { children: ReactNode }) {
  const { version, setVersion } = useAppStore();

  const bible = version === 'KJV' ? kjv : asv;

  return (
    <BibleContext.Provider value={{ bible, version, setVersion }}>{children}</BibleContext.Provider>
  );
}

export const useBible = () => useContext(BibleContext);

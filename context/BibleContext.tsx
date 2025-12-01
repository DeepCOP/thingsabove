// /context/BibleContext.ts
import { createContext, ReactNode, useContext, useState } from 'react';
import asv from '../assets/bibles/asv.json';
import kjv from '../assets/bibles/kjv.json';
const BibleContext = createContext<any>(null);

export type BibleJSON = {
  [bookName: string]: {
    [chapter: string]: {
      [verse: string]: string; // or { title: string, 1: "...", 2: "..." }
    };
  };
};

export function BibleProvider({ children }: { children: ReactNode }) {
  const [version, setVersion] = useState('KJV');

  const bible = version === 'KJV' ? kjv : asv;

  return (
    <BibleContext.Provider value={{ bible, version, setVersion }}>{children}</BibleContext.Provider>
  );
}

export const useBible = () => useContext(BibleContext);

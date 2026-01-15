// /context/BibleContext.ts
import { useAppStore } from '@/src/state/useAppStore';
import { createContext, ReactNode, useContext } from 'react';
import asv from '../../assets/versions/ASV.json';
import kjv from '../../assets/versions/KJV.json';
import BookNames from '../../assets/versions/bookNames.json';

export type BibleJSON = {
  translation: string;
  books: [
    {
      name: string;
      chapters: [
        {
          chapter: number;
          verses: [
            {
              verse: number;
              text: string;
            },
          ];
        },
      ];
    },
  ];
};

type BibleContextType = {
  bible: BibleJSON;
  version: 'KJV' | 'ASV';
  setVersion: (v: 'KJV' | 'ASV') => void;
  bookNames: string[];
};
const BibleContext = createContext<BibleContextType>({
  bible: kjv as BibleJSON,
  version: 'KJV',
  setVersion: () => {},
  bookNames: BookNames,
});

export function BibleProvider({ children }: { children: ReactNode }) {
  const { version, setVersion } = useAppStore();

  const bible: BibleJSON = (version === 'KJV' ? kjv : asv) as BibleJSON;
  const bookNames: string[] = BookNames;
  return (
    <BibleContext.Provider value={{ bible, version, setVersion, bookNames }}>
      {children}
    </BibleContext.Provider>
  );
}

export const useBible = () => useContext(BibleContext);

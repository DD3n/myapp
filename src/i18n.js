import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

// Import translation files
import noTranslation from './locales/no.json';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      no: { translation: noTranslation }
    },
    lng: 'no',
    fallbackLng: 'no',
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;

import React from 'react';
import { Container, Typography, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

// Information page explaining the principles of direct democracy
const Information = () => {
  const { t } = useTranslation();
  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('infoTitle')}
      </Typography>
      <Paper sx={{ padding: 2 }}>
        <Typography variant="body1">
          Direkte demokrati handler om at borgerne skal ha reell innflytelse på politiske beslutninger. Plattformen lar deg stemme på aktuelle forslag, se resultater i sanntid, og delta i diskusjoner.
        </Typography>
        <Typography variant="body1" sx={{ marginTop: 2 }}>
          Systemet er designet med sikkerhet, skalerbarhet og brukervennlighet i fokus, og støtter flerspråklig utvidelse etter hvert.
        </Typography>
      </Paper>
    </Container>
  );
};

export default Information;

import React from 'react';
import { Container, Typography, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

// User Dashboard page to show voting history and active proposals
const Dashboard = () => {
  const { t } = useTranslation();
  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('dashboardTitle')}
      </Typography>
      {/* Replace the below with dynamic content from Firestore */}
      <Paper sx={{ padding: 2, marginBottom: 2 }}>
        <Typography variant="body1">
          Her vises din stemmegivningshistorikk og aktive forslag.
        </Typography>
      </Paper>
    </Container>
  );
};

export default Dashboard;

import React from 'react';
import { Card, CardContent, Typography, Divider, List, ListItem, ListItemText } from '@mui/material';
import { useTranslation } from 'react-i18next';

// Dummy static data for topics and proposals (only a sample subset is shown)
const topics = [
  {
    category: "Styring og administrasjon",
    proposals: [
      "Grunnlovsendringer og juridiske reformer",
      "Regjeringsstruktur (monarki vs. republikk)"
    ]
  },
  {
    category: "Miljø og klima",
    proposals: [
      "Mål for utslippsreduksjon",
      "Prosjekter for fornybar energi"
    ]
  },
  {
    category: "Økonomi og finans",
    proposals: [
      "Inntektsskatt",
      "Bedriftsskatt"
    ]
  }
];

// Card component displaying an interactive overview of topics
const TopicsOverviewCard = () => {
  const { t } = useTranslation();
  return (
    <Card sx={{ marginBottom: 2 }}>
      <CardContent>
        <Typography variant="h5" gutterBottom>
          {t('topicsOverview')}
        </Typography>
        <List>
          {topics.map((topic, index) => (
            <div key={index}>
              <Typography variant="subtitle1" sx={{ marginTop: 1 }}>{topic.category}</Typography>
              <Divider />
              {topic.proposals.map((proposal, idx) => (
                <ListItem key={idx} disablePadding>
                  <ListItemText primary={proposal} />
                </ListItem>
              ))}
            </div>
          ))}
        </List>
      </CardContent>
    </Card>
  );
};

export default TopicsOverviewCard;

import React from 'react';
import { Card, CardContent, Typography, Button, CardActions } from '@mui/material';
import VotingChart from './VotingChart';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';

// Dummy data for trending proposals (ensure each proposal has a unique id matching Firestore documents)
const proposals = [
  {
    id: "proposal1",
    title: "Norge bør bli med i EU. Ja eller Nei?",
    votes: { yes: 120, no: 80, blank: 10 },
    userVote: null
  },
  {
    id: "proposal2",
    title: "Norge stanse innvandringen fra ikke-vestlige land. Ja eller Nei?",
    votes: { yes: 95, no: 110, blank: 5 },
    userVote: null
  }
];

const TrendingVotesCard = () => {
  const { t } = useTranslation();
  return (
    <Card sx={{ marginBottom: 2 }}>
      <CardContent>
        <Typography variant="h5" gutterBottom>
          {t('trendingVotes')}
        </Typography>
        {proposals.map((proposal) => (
          <div key={proposal.id} style={{ marginBottom: '1rem' }}>
            <Typography variant="subtitle1">{proposal.title}</Typography>
            <VotingChart data={proposal.votes} />
          </div>
        ))}
      </CardContent>
      <CardActions>
        {proposals.map((proposal) => (
          <Button
            key={proposal.id}
            size="small"
            variant="contained"
            component={Link}
            to={\`/vote/\${proposal.id}\`}
            sx={{ marginRight: 1 }}
          >
            {t('voteNow')}
          </Button>
        ))}
      </CardActions>
    </Card>
  );
};

export default TrendingVotesCard;

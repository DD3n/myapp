#!/bin/bash
# This script integrates the voting process into the project.
# It creates a new Vote.js page, updates App.js to include the new route,
# and modifies TrendingVotesCard.js to link to the Vote page.
# Finally, it commits and pushes the changes to GitHub.
# Ensure your Git credentials are already configured.

set -e

echo "Writing src/pages/Vote.js..."
cat << 'EOF' > src/pages/Vote.js
import React, { useState, useEffect } from 'react';
import { Container, Typography, TextField, Button, Box } from '@mui/material';
import VotingChart from '../components/VotingChart';
import { useParams } from 'react-router-dom';
import { db } from '../firebase';
import { doc, getDoc, updateDoc, increment } from 'firebase/firestore';

const Vote = () => {
  const { id } = useParams(); // The proposal id from the route
  const [proposal, setProposal] = useState(null);
  const [votePoints, setVotePoints] = useState(0);
  const [remainingVotes, setRemainingVotes] = useState(1000);
  const [error, setError] = useState('');

  useEffect(() => {
    // Fetch proposal data from Firestore
    const fetchProposal = async () => {
      try {
        const docRef = doc(db, "proposals", id);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
          setProposal(docSnap.data());
        } else {
          setError("Proposal not found.");
        }
      } catch (err) {
        setError("Error fetching proposal: " + err.message);
      }
    };
    fetchProposal();
  }, [id]);

  const handleVote = async (voteType) => {
    if (votePoints <= 0) {
      setError("Please enter a valid number of vote points.");
      return;
    }
    if (votePoints > remainingVotes) {
      setError("Not enough vote points available.");
      return;
    }
    try {
      const docRef = doc(db, "proposals", id);
      await updateDoc(docRef, {
        // Use Firestore's atomic increment to update vote counts
        [\`votes.\${voteType}\`]: increment(votePoints)
      });
      // Deduct vote points locally (in a real app, you'd update the user's balance in Firestore)
      setRemainingVotes(remainingVotes - votePoints);
      setVotePoints(0);
      setError("");
      // Optionally, refresh proposal data or show a success message.
    } catch (err) {
      setError("Error casting vote: " + err.message);
    }
  };

  if (error) return <Typography color="error" sx={{ marginTop: 2 }}>{error}</Typography>;
  if (!proposal) return <Typography sx={{ marginTop: 2 }}>Loading proposal...</Typography>;

  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4">{proposal.title}</Typography>
      <Box sx={{ marginTop: 2 }}>
        <VotingChart data={proposal.votes} />
      </Box>
      <Box sx={{ marginTop: 2 }}>
        <TextField
          label="Tildel stemmepoeng"
          type="number"
          value={votePoints}
          onChange={(e) => setVotePoints(parseInt(e.target.value) || 0)}
        />
        <Typography variant="body2" sx={{ marginTop: 1 }}>
          Gjenstående stemmepoeng: {remainingVotes}
        </Typography>
      </Box>
      <Box sx={{ marginTop: 2 }}>
        <Button variant="contained" color="primary" onClick={() => handleVote('yes')} sx={{ marginRight: 1 }}>
          Stem Ja
        </Button>
        <Button variant="contained" color="secondary" onClick={() => handleVote('no')} sx={{ marginRight: 1 }}>
          Stem Nei
        </Button>
        <Button variant="contained" onClick={() => handleVote('blank')}>
          Stem Blank
        </Button>
      </Box>
    </Container>
  );
};

export default Vote;
EOF

echo "Updating src/App.js to include the Vote route..."
cat << 'EOF' > src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Login from './pages/Login';
import Registration from './pages/Registration';
import Dashboard from './pages/Dashboard';
import Suggestion from './pages/Suggestion';
import Information from './pages/Information';
import AdminDashboard from './pages/AdminDashboard';
import Vote from './pages/Vote';
import ErrorBoundary from './components/ErrorBoundary';

function App() {
  return (
    <ErrorBoundary>
      <Router>
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Registration />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/suggestion" element={<Suggestion />} />
          <Route path="/info" element={<Information />} />
          <Route path="/admin" element={<AdminDashboard />} />
          <Route path="/vote/:id" element={<Vote />} />
        </Routes>
      </Router>
    </ErrorBoundary>
  );
}

export default App;
EOF

echo "Updating src/components/TrendingVotesCard.js to link to Vote page..."
cat << 'EOF' > src/components/TrendingVotesCard.js
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
EOF

echo "Initializing git repository if needed..."
if [ ! -d .git ]; then
  git init
  git remote add origin https://github.com/DD3n/myapp.git
fi

echo "Adding updated files to git..."
git add .

echo "Committing updated files..."
git commit -m "Integrate voting process: add Vote page and update routes and TrendingVotesCard"

echo "Pushing changes to GitHub repository at https://github.com/DD3n/myapp..."
git push -u origin main

echo "Voting process integration has been pushed successfully!"

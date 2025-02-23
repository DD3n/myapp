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

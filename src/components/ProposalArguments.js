import React, { useState } from 'react';
import { Card, CardContent, TextField, Button, Typography, IconButton } from '@mui/material';
import ThumbUpIcon from '@mui/icons-material/ThumbUp';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';

// Component for users to submit arguments (max 50 words, max 5 per proposal)
// and vote (thumbs up/down) on each argument.
const ProposalArguments = () => {
  const [argumentsList, setArgumentsList] = useState([]);
  const [inputValue, setInputValue] = useState("");

  // Handle submission ensuring maximum 50 words and max 5 arguments
  const handleSubmit = (e) => {
    e.preventDefault();
    const wordCount = inputValue.trim().split(/\s+/).length;
    if (wordCount > 50) {
      alert("Maksimum 50 ord per innlegg.");
      return;
    }
    if (argumentsList.length >= 5) {
      alert("Du kan ikke legge til mer enn 5 innlegg.");
      return;
    }
    const newArg = { text: inputValue, up: 0, down: 0 };
    setArgumentsList([...argumentsList, newArg]);
    setInputValue("");
  };

  // Simple functions to update up/down counts
  const handleUpvote = (index) => {
    const newList = [...argumentsList];
    newList[index].up += 1;
    setArgumentsList(newList);
  };

  const handleDownvote = (index) => {
    const newList = [...argumentsList];
    newList[index].down += 1;
    setArgumentsList(newList);
  };

  return (
    <Card sx={{ marginTop: 2 }}>
      <CardContent>
        <Typography variant="h6">Argumenter for og imot</Typography>
        {argumentsList.map((arg, index) => (
          <div key={index} style={{ marginBottom: '1rem', borderBottom: '1px solid #ccc', paddingBottom: '0.5rem' }}>
            <Typography variant="body1">{arg.text}</Typography>
            <div>
              <IconButton onClick={() => handleUpvote(index)} size="small">
                <ThumbUpIcon fontSize="small" />
              </IconButton>
              <IconButton onClick={() => handleDownvote(index)} size="small">
                <ThumbDownIcon fontSize="small" />
              </IconButton>
              <Typography variant="caption">
                Netto: {arg.up - arg.down}
              </Typography>
            </div>
          </div>
        ))}
        <form onSubmit={handleSubmit}>
          <TextField
            label="Skriv ditt argument (maks 50 ord)"
            variant="outlined"
            fullWidth
            margin="normal"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
          />
          <Button type="submit" variant="contained">Legg til</Button>
        </form>
      </CardContent>
    </Card>
  );
};

export default ProposalArguments;

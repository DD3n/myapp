#!/bin/bash
# This script updates the project with Firebase Authentication integration for registration.
# It writes the new Registration.js file, updates App.js and Navbar.js,
# commits all changes, and pushes the updated code to GitHub at https://github.com/DD3n/myapp.
# Ensure your Git credentials are already set up.

set -e

echo "Writing src/pages/Registration.js..."
cat << 'EOF' > src/pages/Registration.js
import React, { useState } from 'react';
import { Container, Typography, TextField, Button } from '@mui/material';
import { useTranslation } from 'react-i18next';
import { auth } from '../firebase';
import { createUserWithEmailAndPassword, sendEmailVerification, updateProfile } from 'firebase/auth';

const Registration = () => {
  const { t } = useTranslation();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const handleRegistration = async (e) => {
    e.preventDefault();
    setError("");
    setMessage("");
    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      await updateProfile(userCredential.user, { displayName });
      await sendEmailVerification(userCredential.user);
      setMessage("Registration successful. Please verify your email.");
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <Container maxWidth="sm" sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>Registrer deg</Typography>
      <form onSubmit={handleRegistration}>
        <TextField
          label="Navn"
          variant="outlined"
          fullWidth
          margin="normal"
          required
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
        />
        <TextField
          label="E-post"
          variant="outlined"
          fullWidth
          margin="normal"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <TextField
          label="Passord"
          variant="outlined"
          type="password"
          fullWidth
          margin="normal"
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        {error && <Typography color="error" variant="body2">{error}</Typography>}
        {message && <Typography color="primary" variant="body2">{message}</Typography>}
        <Button type="submit" variant="contained" color="primary" fullWidth sx={{ marginTop: 2 }}>
          Registrer
        </Button>
      </form>
    </Container>
  );
};

export default Registration;
EOF

echo "Updating src/App.js to include Registration route..."
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
        </Routes>
      </Router>
    </ErrorBoundary>
  );
}

export default App;
EOF

echo "Updating src/components/Navbar.js to include Registration link..."
cat << 'EOF' > src/components/Navbar.js
import React from 'react';
import { Link } from 'react-router-dom';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import { useTranslation } from 'react-i18next';

const Navbar = () => {
  const { t } = useTranslation();
  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          {t('appTitle')}
        </Typography>
        <Button color="inherit" component={Link} to="/">{t('home')}</Button>
        <Button color="inherit" component={Link} to="/login">{t('login')}</Button>
        <Button color="inherit" component={Link} to="/register">Registrer deg</Button>
        <Button color="inherit" component={Link} to="/dashboard">{t('dashboard')}</Button>
        <Button color="inherit" component={Link} to="/suggestion">{t('suggestion')}</Button>
        <Button color="inherit" component={Link} to="/info">{t('information')}</Button>
        <Button color="inherit" component={Link} to="/admin">{t('admin')}</Button>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
EOF

echo "Initializing git repository if needed..."
if [ ! -d .git ]; then
  git init
  git remote add origin https://github.com/DD3n/myapp.git
fi

echo "Adding updated files to git..."
git add .

echo "Committing updated files..."
git commit -m "Integrate Firebase Authentication: add Registration page and update routes/navbar"

echo "Pushing changes to GitHub repository at https://github.com/DD3n/myapp..."
git push -u origin main

echo "User registration and login integration has been pushed successfully!"

#!/bin/bash
# This script creates the complete updated DirectDemocracy Org codebase with improvements:
# - Sensitive Firebase config moved to environment variables (.env file)
# - ESLint and Prettier configuration files added
# - An ErrorBoundary component for robust error handling is implemented
# - Updated README with setup instructions
# The script then initializes a Git repository (if not already done), commits all changes,
# and pushes the code to your GitHub repository at https://github.com/DD3n/myapp.
#
# Ensure that your Git credentials are already set up (SSH keys or PAT).

set -e

echo "Creating directory structure..."
mkdir -p public src src/components src/pages src/locales

echo "Writing package.json..."
cat << 'EOF' > package.json
{
  "name": "directdemocracy-org",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "firebase": "^9.22.0",
    "react-router-dom": "^6.3.0",
    "@mui/material": "^5.10.0",
    "@emotion/react": "^11.10.0",
    "@emotion/styled": "^11.10.0",
    "chart.js": "^4.2.1",
    "react-chartjs-2": "^5.2.0",
    "i18next": "^22.0.0",
    "react-i18next": "^12.2.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "lint": "eslint ./src --ext .js,.jsx",
    "format": "prettier --write \"src/**/*.{js,jsx,json,css,md}\""
  }
}
EOF

echo "Writing firebase.json..."
cat << 'EOF' > firebase.json
{
  "hosting": {
    "public": "build",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF

echo "Writing .firebaserc..."
cat << 'EOF' > .firebaserc
{
  "projects": {
    "default": "d3-project-id"  // Replace with your actual Firebase project ID
  }
}
EOF

echo "Writing .env file..."
cat << 'EOF' > .env
REACT_APP_FIREBASE_API_KEY=YOUR_API_KEY
REACT_APP_FIREBASE_AUTH_DOMAIN=YOUR_PROJECT_ID.firebaseapp.com
REACT_APP_FIREBASE_PROJECT_ID=YOUR_PROJECT_ID
REACT_APP_FIREBASE_STORAGE_BUCKET=YOUR_PROJECT_ID.appspot.com
REACT_APP_FIREBASE_MESSAGING_SENDER_ID=YOUR_SENDER_ID
REACT_APP_FIREBASE_APP_ID=YOUR_APP_ID
EOF

echo "Writing .eslintrc.js..."
cat << 'EOF' > .eslintrc.js
module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: [
    "react-app",
    "eslint:recommended",
    "plugin:react/recommended",
    "prettier"
  ],
  parserOptions: {
    ecmaVersion: 12,
    sourceType: "module"
  },
  plugins: ["react"],
  rules: {
    // Add any custom rules here
  }
};
EOF

echo "Writing .prettierrc..."
cat << 'EOF' > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 80
}
EOF

echo "Writing README.md..."
cat << 'EOF' > README.md
# DirectDemocracy Org

This is the initial codebase for DirectDemocracy Org—a scalable, secure, and modular direct democracy platform built with React and Firebase.

## Features

- Responsive, card-based design
- Secure user registration and login (with plans for future BankID integration)
- Real-time voting components with dynamic charts (Chart.js)
- Multi-language support with i18next (starting with Norwegian)
- Error boundary for robust error handling
- ESLint and Prettier for code quality and consistency

## Setup

1. **Clone the repository:**
   \`\`\`bash
   git clone https://github.com/DD3n/myapp.git
   \`\`\`

2. **Navigate to the project directory:**
   \`\`\`bash
   cd myapp
   \`\`\`

3. **Create a \`.env\` file in the root directory and add your Firebase configuration:**
   \`\`\`
   REACT_APP_FIREBASE_API_KEY=YOUR_API_KEY
   REACT_APP_FIREBASE_AUTH_DOMAIN=YOUR_PROJECT_ID.firebaseapp.com
   REACT_APP_FIREBASE_PROJECT_ID=YOUR_PROJECT_ID
   REACT_APP_FIREBASE_STORAGE_BUCKET=YOUR_PROJECT_ID.appspot.com
   REACT_APP_FIREBASE_MESSAGING_SENDER_ID=YOUR_SENDER_ID
   REACT_APP_FIREBASE_APP_ID=YOUR_APP_ID
   \`\`\`

4. **Install dependencies:**
   \`\`\`bash
   npm install
   \`\`\`

5. **Start the development server:**
   \`\`\`bash
   npm start
   \`\`\`

## Future Enhancements

- Integrate Firebase Authentication with secure email verification and password recovery.
- Implement unit tests using Jest and React Testing Library.
- Expand Firebase security rules and perform regular security audits.
- Additional language support via external JSON/YAML files.
EOF

echo "Writing public/index.html..."
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="no">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>DirectDemocracy Org</title>
  </head>
  <body>
    <noscript>Du må aktivere JavaScript for å bruke denne appen.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

echo "Writing src/index.js..."
cat << 'EOF' > src/index.js
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './i18n'; // Initialize i18next for multi-language support

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

echo "Writing src/App.js..."
cat << 'EOF' > src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Suggestion from './pages/Suggestion';
import Information from './pages/Information';
import AdminDashboard from './pages/AdminDashboard';
import ErrorBoundary from './components/ErrorBoundary';

// Main App component: wraps the app with ErrorBoundary for robust error handling.
function App() {
  return (
    <ErrorBoundary>
      <Router>
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
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

echo "Writing src/firebase.js..."
cat << 'EOF' > src/firebase.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

// Firebase configuration using environment variables for security
const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
EOF

echo "Writing src/i18n.js..."
cat << 'EOF' > src/i18n.js
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
EOF

echo "Writing src/locales/no.json..."
cat << 'EOF' > src/locales/no.json
{
  "appTitle": "DirectDemocracy Org",
  "home": "Hjem",
  "login": "Logg inn",
  "dashboard": "Min side",
  "suggestion": "Forslag",
  "information": "Informasjon",
  "admin": "Admin",
  "welcomeMessage": "Velkommen til DirectDemocracy Org",
  "homeDescription": "Her finner du trending stemmegivninger og en oversikt over temaer.",
  "loginTitle": "Logg inn",
  "email": "E-post",
  "password": "Passord",
  "submit": "Send",
  "trendingVotes": "Trending Stemmegivninger",
  "topicsOverview": "Strukturert Oversikt over Temaer",
  "voteNow": "Stem nå",
  "voteResult": "Stemme-resultat",
  "remainingVotes": "Gjenstående stemmepoeng: {{count}}",
  "dashboardTitle": "Min Stemmegivningshistorikk",
  "suggestionTitle": "Legg til nytt forslag",
  "infoTitle": "Prinsipper for Direkte Demokrati",
  "adminDashboardTitle": "Admin Kontrollpanel"
}
EOF

echo "Writing src/components/Navbar.js..."
cat << 'EOF' > src/components/Navbar.js
import React from 'react';
import { Link } from 'react-router-dom';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import { useTranslation } from 'react-i18next';

// Navigation bar component with links to all key pages
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

echo "Writing src/components/TrendingVotesCard.js..."
cat << 'EOF' > src/components/TrendingVotesCard.js
import React from 'react';
import { Card, CardContent, Typography, Button, CardActions } from '@mui/material';
import VotingChart from './VotingChart';
import { useTranslation } from 'react-i18next';

// Dummy data for trending proposals
const proposals = [
  {
    id: 1,
    title: "Norge bør bli med i EU. Ja eller Nei?",
    votes: { yes: 120, no: 80, blank: 10 },
    userVote: null
  },
  {
    id: 2,
    title: "Norge stanse innvandringen fra ikke-vestlige land. Ja eller Nei?",
    votes: { yes: 95, no: 110, blank: 5 },
    userVote: null
  }
];

// Card component to display trending votes with a dynamic chart
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
        <Button size="small" variant="contained">{t('voteNow')}</Button>
      </CardActions>
    </Card>
  );
};

export default TrendingVotesCard;
EOF

echo "Writing src/components/VotingChart.js..."
cat << 'EOF' > src/components/VotingChart.js
import React from 'react';
import { Bar } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

const VotingChart = ({ data }) => {
  const chartData = {
    labels: ['Ja', 'Nei', 'Blank'],
    datasets: [
      {
        label: 'Stemmer',
        data: [data.yes, data.no, data.blank],
        backgroundColor: ['#4caf50', '#f44336', '#9e9e9e']
      }
    ]
  };

  const options = {
    responsive: true,
    plugins: {
      legend: { position: 'bottom' }
    }
  };

  return <Bar data={chartData} options={options} />;
};

export default VotingChart;
EOF

echo "Writing src/components/TopicsOverviewCard.js..."
cat << 'EOF' > src/components/TopicsOverviewCard.js
import React from 'react';
import { Card, CardContent, Typography, Divider, List, ListItem, ListItemText } from '@mui/material';
import { useTranslation } from 'react-i18next';

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
              <Typography variant="subtitle1" sx={{ marginTop: 1 }}>
                {topic.category}
              </Typography>
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
EOF

echo "Writing src/components/ProposalArguments.js..."
cat << 'EOF' > src/components/ProposalArguments.js
import React, { useState } from 'react';
import { Card, CardContent, TextField, Button, Typography, IconButton } from '@mui/material';
import ThumbUpIcon from '@mui/icons-material/ThumbUp';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';

const ProposalArguments = () => {
  const [argumentsList, setArgumentsList] = useState([]);
  const [inputValue, setInputValue] = useState("");

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
              <Typography variant="caption">Netto: {arg.up - arg.down}</Typography>
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
EOF

echo "Writing src/pages/Home.js..."
cat << 'EOF' > src/pages/Home.js
import React from 'react';
import { Container, Typography } from '@mui/material';
import TrendingVotesCard from '../components/TrendingVotesCard';
import TopicsOverviewCard from '../components/TopicsOverviewCard';
import { useTranslation } from 'react-i18next';

const Home = () => {
  const { t } = useTranslation();
  return (
    <Container sx={{ marginTop: 2 }}>
      <Typography variant="h4" gutterBottom>
        {t('welcomeMessage')}
      </Typography>
      <Typography variant="body1" gutterBottom>
        {t('homeDescription')}
      </Typography>
      <TrendingVotesCard />
      <TopicsOverviewCard />
    </Container>
  );
};

export default Home;
EOF

echo "Writing src/pages/Login.js..."
cat << 'EOF' > src/pages/Login.js
import React from 'react';
import { Container, Typography, TextField, Button } from '@mui/material';
import { useTranslation } from 'react-i18next';

const Login = () => {
  const { t } = useTranslation();

  const handleLogin = (e) => {
    e.preventDefault();
    // TODO: Integrate Firebase Authentication logic
  };

  return (
    <Container maxWidth="sm" sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('loginTitle')}
      </Typography>
      <form onSubmit={handleLogin}>
        <TextField label={t('email')} variant="outlined" fullWidth margin="normal" required />
        <TextField label={t('password')} variant="outlined" type="password" fullWidth margin="normal" required />
        <Button type="submit" variant="contained" color="primary" fullWidth sx={{ marginTop: 2 }}>
          {t('submit')}
        </Button>
      </form>
    </Container>
  );
};

export default Login;
EOF

echo "Writing src/pages/Dashboard.js..."
cat << 'EOF' > src/pages/Dashboard.js
import React from 'react';
import { Container, Typography, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

const Dashboard = () => {
  const { t } = useTranslation();
  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('dashboardTitle')}
      </Typography>
      <Paper sx={{ padding: 2, marginBottom: 2 }}>
        <Typography variant="body1">
          Her vises din stemmegivningshistorikk og aktive forslag.
        </Typography>
      </Paper>
    </Container>
  );
};

export default Dashboard;
EOF

echo "Writing src/pages/Suggestion.js..."
cat << 'EOF' > src/pages/Suggestion.js
import React, { useState } from 'react';
import { Container, Typography, TextField, Button, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

const Suggestion = () => {
  const { t } = useTranslation();
  const [suggestion, setSuggestion] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    // TODO: Integrate with Firestore to save the suggestion and optionally notify admins
    alert("Forslaget er sendt inn!");
    setSuggestion("");
  };

  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('suggestionTitle')}
      </Typography>
      <Paper sx={{ padding: 2 }}>
        <form onSubmit={handleSubmit}>
          <TextField
            label="Ditt forslag"
            variant="outlined"
            fullWidth
            multiline
            rows={4}
            margin="normal"
            value={suggestion}
            onChange={(e) => setSuggestion(e.target.value)}
            required
          />
          <Button type="submit" variant="contained" color="primary">
            Send inn forslag
          </Button>
        </form>
      </Paper>
    </Container>
  );
};

export default Suggestion;
EOF

echo "Writing src/pages/Information.js..."
cat << 'EOF' > src/pages/Information.js
import React from 'react';
import { Container, Typography, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

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
EOF

echo "Writing src/pages/AdminDashboard.js..."
cat << 'EOF' > src/pages/AdminDashboard.js
import React from 'react';
import { Container, Typography, Paper } from '@mui/material';
import { useTranslation } from 'react-i18next';

const AdminDashboard = () => {
  const { t } = useTranslation();
  return (
    <Container sx={{ marginTop: 4 }}>
      <Typography variant="h4" gutterBottom>
        {t('adminDashboardTitle')}
      </Typography>
      <Paper sx={{ padding: 2 }}>
        <Typography variant="body1">
          Dette kontrollpanelet lar administratorer administrere forslag, redigere eksisterende og avslutte stemmegivninger, samt se statistikk over brukeraktivitet.
        </Typography>
      </Paper>
    </Container>
  );
};

export default AdminDashboard;
EOF

echo "Writing src/components/ErrorBoundary.js..."
cat << 'EOF' > src/components/ErrorBoundary.js
import React from 'react';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('ErrorBoundary caught an error', error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <h1>Noe gikk galt. Vennligst prøv igjen senere.</h1>;
    }
    return this.props.children;
  }
}

export default ErrorBoundary;
EOF

echo "Initializing git repository if needed..."
if [ ! -d .git ]; then
  git init
  git remote add origin https://github.com/DD3n/myapp.git
fi

echo "Adding files to git..."
git add .

echo "Committing files..."
git commit -m "Update project with environment variables, ESLint/Prettier, and ErrorBoundary"

echo "Pushing to GitHub repository at https://github.com/DD3n/myapp..."
git push -u origin main

echo "All updated code has been pushed successfully!"

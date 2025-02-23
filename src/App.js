import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Suggestion from './pages/Suggestion';
import Information from './pages/Information';
import AdminDashboard from './pages/AdminDashboard';

// Main App component: sets up routing for all pages
function App() {
  return (
    <Router>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />               {/* Home page with trending votes and topics */}
        <Route path="/login" element={<Login />} />           {/* Login/Registration page */}
        <Route path="/dashboard" element={<Dashboard />} />   {/* User Dashboard */}
        <Route path="/suggestion" element={<Suggestion />} /> {/* New Proposal/Suggestion page */}
        <Route path="/info" element={<Information />} />      {/* Information about direct democracy */}
        <Route path="/admin" element={<AdminDashboard />} />  {/* Admin panel for managing proposals */}
      </Routes>
    </Router>
  );
}

export default App;

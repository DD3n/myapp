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

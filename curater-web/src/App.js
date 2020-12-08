import './App.css';
import Header from './container/header';
import SideBar from './container/sidebar';
import Dashboard from './container/dashboard';

require('dotenv').config()

function App() {
  return (
    <div className="App">
      <Header />
      <div style={{top: "60px", width: "100%", display: "flex"}}>
        <SideBar />
        <Dashboard />
      </div>
    </div>
  );
}

export default App;

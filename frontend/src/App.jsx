import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { Sidebar } from '@/components/sidebar'
import Home from '@/pages/Home'
import TaskRecord from '@/pages/TaskRecord'
import TrendingPage from '@/pages/TrendingPage'
import DataAnalysis from '@/pages/DataAnalysis'
import Settings from '@/pages/Settings'
import './App.css'

function App() {
  return (
    <Router>
      <div className="flex h-screen">
        <Sidebar />
        <main className="flex-1 overflow-y-auto p-4">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/task-record" element={<TaskRecord />} />
            <Route path="/data-analysis" element={<DataAnalysis />} />
            <Route path="/trending" element={<TrendingPage />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="*" element={<Navigate to="/trending" replace />} />
          </Routes>
        </main>
      </div>
    </Router>
  )
}

export default App

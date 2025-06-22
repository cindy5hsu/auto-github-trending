import { useState } from 'react' 
import { useNavigate, useLocation } from 'react-router-dom'
import { Home, ClipboardList, BarChart2, TrendingUp, Settings, Github } from 'lucide-react'

export function Sidebar() {
  const navigate = useNavigate()
  const location = useLocation()
  const [collapseShow, setCollapseShow] = useState({})

  const menuItems = [
    { id: 'home', name: '首页', icon: Home, path: '/' },
    { id: 'task-record', name: '任务记录', icon: ClipboardList, path: '/task-record' },
    { id: 'data-analysis', name: '数据分析', icon: BarChart2, path: '/data-analysis' },
    { id: 'trending', name: 'Trending', icon: TrendingUp, path: '/trending' },
    { id: 'settings', name: '系统设置', icon: Settings, path: '/settings' },
  ]

  return (
    <nav className="flex flex-col h-full bg-gradient-to-b from-slate-800 to-slate-900 text-white w-64 p-4 shadow-lg">
      <div className="flex items-center justify-center mb-8 pt-4">
        <Github className="w-8 h-8 mr-2 text-blue-400" />
        <h1 className="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-purple-500">GitHub Trending</h1>
      </div>
      <div className="space-y-2">
        {menuItems.map((item) => (
          <button
            key={item.id}
            className={`flex items-center space-x-3 w-full px-4 py-3 rounded-lg transition-all duration-200 ${location.pathname === item.path 
              ? 'bg-blue-600 text-white shadow-md' 
              : 'hover:bg-slate-700/50 text-slate-300 hover:text-white'}`}
            onClick={() => navigate(item.path)}
          >
            <item.icon className={`w-5 h-5 ${location.pathname === item.path ? 'text-white' : 'text-slate-400'}`} />
            <span>{item.name}</span>
          </button>
        ))}
      </div>
      <div className="mt-auto mb-4 pt-4 border-t border-slate-700/50 text-center text-xs text-slate-500">
        <p>© 2024 GitHub Trending</p>
        <p>数据抓取项目</p>
      </div>
    </nav>
  )
}

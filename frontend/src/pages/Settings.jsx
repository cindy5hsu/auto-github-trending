import React, { useState } from 'react'
import { Switch, Input, Button } from 'antd'

export function Settings() {
  const [darkMode, setDarkMode] = useState(false)
  const [username, setUsername] = useState('')

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">系统设置</h1>

      <div className="mt-4">
        <label className="block mb-2">深色模式</label>
        <Switch checked={darkMode} onChange={setDarkMode} />
      </div>

      <div className="mt-4">
        <label className="block mb-2">用户名</label>
        <Input value={username} onChange={(e) => setUsername(e.target.value)} placeholder="请输入用户名" />
      </div>

      <Button type="primary" className="mt-4">保存设置</Button>
    </div>
  )
}

export default Settings

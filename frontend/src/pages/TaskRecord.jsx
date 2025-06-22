import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { ClipboardList } from "lucide-react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { taskApi } from "@/services/api";

export default function TaskRecord() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    try {
      setLoading(true);
      const response = await taskApi.getTasks();
      console.log('API Response:', response);
      const { data } = response;
      console.log('Tasks data:', data);
      if (Array.isArray(data)) {
        setTasks(data);
      } else {
        console.error("API返回的數據格式不正確:", data);
        setTasks([]);
      }
    } catch (error) {
      console.error("Error fetching tasks:", error);
      setTasks([]);
    } finally {
      setLoading(false);
    }
  };

  const executeManualTask = async () => {
    try {
      setLoading(true);
      const response = await taskApi.executeManualTask();
      console.log('Manual task execution response:', response);
      // 等待一秒後刷新任務列表，確保後端有足夠時間處理任務
      setTimeout(() => fetchTasks(), 1000);
    } catch (error) {
      console.error("Error executing manual task:", error);
    } finally {
      setLoading(false);
    }
  };

  const executeAutoTask = async () => {
    try {
      setLoading(true);
      const response = await taskApi.executeAutoTask();
      console.log('Auto task execution response:', response);
      // 等待一秒後刷新任務列表，確保後端有足夠時間處理任務
      setTimeout(() => fetchTasks(), 1000);
    } catch (error) {
      console.error("Error executing auto task:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 bg-white shadow-xl rounded-xl border border-gray-100">
      <div className="flex justify-between items-center mb-6 border-b pb-4">
        <h2 className="text-2xl font-bold text-gray-900 flex items-center">
          <ClipboardList className="mr-2 h-6 w-6 text-blue-500" />
          <span>执行记录</span>
        </h2>
        <div className="flex gap-3">
          <Button 
            variant="outline" 
            onClick={executeManualTask} 
            className="px-4 py-2 border-blue-200 hover:bg-blue-50 hover:text-blue-600 transition-all duration-200"
          >
            <span className="mr-2">🔄</span>手动执行任务
          </Button>
          <Button 
            variant="default" 
            onClick={executeAutoTask} 
            className="px-4 py-2 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-md"
          >
            <span className="mr-2">⚡</span>执行自动任务
          </Button>
        </div>
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-16 text-gray-500">
          <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-500 mr-3"></div>
          <span className="text-lg">加載中...</span>
        </div>
      ) : tasks.length === 0 ? (
        <div className="text-center py-16 text-gray-500 bg-gray-50 rounded-xl border border-dashed border-gray-300 transition-all hover:border-blue-300 hover:bg-blue-50">
          <svg className="mx-auto h-16 w-16 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
          </svg>
          <p className="mt-4 text-base font-medium">暫無執行記錄</p>
          <p className="mt-2 text-sm text-gray-500">點擊上方按鈕執行任務</p>
        </div>
      ) : (
        <div className="overflow-x-auto border rounded-xl shadow-sm">
          <Table className="w-full">
            <TableHeader>
              <TableRow className="bg-gradient-to-r from-gray-50 to-gray-100 text-gray-700">
                <TableHead className="p-4 font-semibold">任务名称</TableHead>
                <TableHead className="p-4 font-semibold">类型</TableHead>
                <TableHead className="p-4 font-semibold">状态</TableHead>
                <TableHead className="p-3">创建时间</TableHead>
                <TableHead className="p-3">计划时间</TableHead>
                <TableHead className="p-3">完成时间</TableHead>
                <TableHead className="p-3">错误信息</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {tasks.map((task) => (
                <TableRow key={task.id} className="hover:bg-gray-50">
                  <TableCell className="p-3">{task.name}</TableCell>
                  <TableCell className="p-3">{task.type}</TableCell>
                  <TableCell className="p-3">
                    <span className={`px-2 py-1 rounded text-xs font-medium ${task.status === 'COMPLETED' ? 'bg-green-100 text-green-800' : task.status === 'FAILED' ? 'bg-red-100 text-red-800' : task.status === 'RUNNING' ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800'}`}>
                      {task.status === 'COMPLETED' ? '已完成' : 
                       task.status === 'FAILED' ? '失敗' : 
                       task.status === 'RUNNING' ? '執行中' : '等待中'}
                    </span>
                  </TableCell>
                  <TableCell className="p-3">{new Date(task.createdAt).toLocaleString()}</TableCell>
                  <TableCell className="p-3">{task.scheduledAt ? new Date(task.scheduledAt).toLocaleString() : '-'}</TableCell>
                  <TableCell className="p-3">{task.completedAt ? new Date(task.completedAt).toLocaleString() : '-'}</TableCell>
                  <TableCell className="p-3">{task.errorMessage || '-'}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      )}
    </div>
  );
}
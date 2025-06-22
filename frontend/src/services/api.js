import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8081/api'
});

// 添加请求拦截器，用于调试API请求
api.interceptors.request.use(config => {
  console.log('API Request:', config);
  return config;
});

// 添加响应拦截器，用于调试API响应
api.interceptors.response.use(response => {
  console.log('API Response:', response);
  return response;
}, error => {
  console.error('API Error:', error);
  return Promise.reject(error);
});

export const trendingApi = {
  // 获取每日趋势
  getDailyTrending: (page = 1, size = 50, language = '') => {
    // 处理language参数，确保'all'被转换为空字符串
    const langParam = language === 'all' ? '' : language;
    console.log('Processed language param for daily trending:', { original: language, processed: langParam });
    console.log('API Request params:', { page, size, language: langParam });
    
    return api.get('/trending/daily', { params: { page, size, language: langParam } })
    .then(response => {
      console.log('Daily trending response:', response);
      console.log('Daily trending data count:', response.data ? response.data.length : 0);
      return response;
    })
    .catch(error => {
      console.error('Error fetching daily trending:', error);
      console.error('Error details:', error.response ? error.response.data : 'No response data');
      throw error;
    });
  },

  // 获取每周趋势
  getWeeklyTrending: (page = 1, size = 50, language = '') => {
    // 处理language参数，确保'all'被转换为空字符串
    const langParam = language === 'all' ? '' : language;
    console.log('Processed language param for weekly trending:', { original: language, processed: langParam });
    console.log('API Request params:', { page, size, language: langParam });
    
    return api.get('/trending/weekly', { params: { page, size, language: langParam } })
    .then(response => {
      console.log('Weekly trending response:', response);
      console.log('Weekly trending data count:', response.data ? response.data.length : 0);
      return response;
    })
    .catch(error => {
      console.error('Error fetching weekly trending:', error);
      console.error('Error details:', error.response ? error.response.data : 'No response data');
      throw error;
    });
  },

  // 获取指定语言的趋势
  getTrendingByLanguage: (language) => 
    api.get(`/trending/language/${language}`)
    .then(response => {
      console.log('Language trending response:', response);
      return response;
    })
    .catch(error => {
      console.error('Error fetching language trending:', error);
      throw error;
    }),
    
  // 获取支持的编程语言列表
  getLanguages: () => {
    console.log('Fetching supported languages');
    // 由于后端没有提供语言列表API，这里返回一个静态的语言列表
    return Promise.resolve({
      data: [
        'all',
        'javascript',
        'python',
        'java',
        'go',
        'rust',
        'typescript',
        'c++',
        'c#',
        'php'
      ]
    });
  }
};

export const taskApi = {
  // 获取任务列表（使用执行记录API）
  getTasks: () => 
    api.get('/tasks/execution-records'),

  // 手动执行任务
  executeManualTask: () => 
    api.post('/tasks/execute/manual'),

  // 执行自动任务
  executeAutoTask: () => 
    api.post('/tasks/execute/auto'),

  // 获取执行记录
  getExecutionRecords: () => 
    api.get('/tasks/execution-records')

  // 以下是注释掉的重复方法，避免与trendingApi冲突
  /*
  // 获取每日趋势
  // getDailyTrending: (page = 1, size = 50, language) => 
  //   api.get('/trending/daily', { params: { page, size, language } }),

  // 获取每周趋势
  // getWeeklyTrending: (page = 1, size = 50, language) => 
  //   api.get('/trending/weekly', { params: { page, size, language } })

  // 获取执行记录
  // getExecutionRecords: () => 
  //   api.get('/trending/execution-records')
  */
};
import React, { useState, useEffect } from 'react';
import { Layout, Tabs, Card, Select, List, Avatar, Tag, Tooltip, Spin } from 'antd';
import ReactECharts from 'echarts-for-react';
import * as echarts from 'echarts/core';
import { useDispatch, useSelector } from 'react-redux';
import { fetchDailyTrending, fetchWeeklyTrending } from '../store/trendingSlice';
import { trendingApi } from '../services/api';
import { TrendingUp, Star, GitFork, Code, Github } from 'lucide-react';

const { Header, Content } = Layout;
const { TabPane } = Tabs;
const { Option } = Select;
const { Meta } = Card;

const TrendingPage = () => {
  const dispatch = useDispatch();
  const { dailyData, weeklyData, loading, error } = useSelector(state => state.trending);
  const [activeTab, setActiveTab] = useState('daily');
  const [language, setLanguage] = useState('all');

  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 50;

  useEffect(() => {
    console.log('Fetching data with params:', { activeTab, language, currentPage });
    if (activeTab === 'daily') {
      dispatch(fetchDailyTrending({ page: currentPage, size: pageSize, language }));
    } else {
      dispatch(fetchWeeklyTrending({ page: currentPage, size: pageSize, language }));
    }
  }, [dispatch, activeTab, language, currentPage]);

  // 將currentData定義提前，避免在useEffect中使用未定義的變量
  const currentData = activeTab === 'daily' ? dailyData : weeklyData;
  
  // 添加调试日志，查看API响应
  useEffect(() => {
    if (loading) {
      console.log('Loading trending data...');
    } else if (error) {
      console.error('Error loading trending data:', error);
    } else {
      console.log('Current data loaded:', currentData);
      // 如果数据为空但没有错误，尝试直接调用API
      if (currentData && currentData.length === 0 && !error) {
        console.log('No data in Redux store, trying direct API call');
        const fetchDirectly = async () => {
          try {
            // 確保language參數處理一致
            const langParam = language === 'all' ? '' : language;
            console.log('Direct API call with processed language:', { original: language, processed: langParam });
            console.log('API URL:', `http://localhost:8081/api/trending/${activeTab === 'daily' ? 'daily' : 'weekly'}?page=${currentPage}&size=${pageSize}&language=${langParam}`);
            
            // 檢查後端服務是否可用
            try {
              const checkResponse = await fetch('http://localhost:8081/api/trending/daily');
              console.log('Backend service check response:', checkResponse.status);
              if (!checkResponse.ok) {
                console.error('Backend service is not available, status:', checkResponse.status);
                dispatch({ type: activeTab === 'daily' ? 'trending/fetchDaily/rejected' : 'trending/fetchWeekly/rejected', 
                          error: { message: '後端服務未啟動或不可用，請確保後端服務正在運行' } });
                return;
              }
            } catch (checkErr) {
              console.error('Backend service check failed:', checkErr);
              dispatch({ type: activeTab === 'daily' ? 'trending/fetchDaily/rejected' : 'trending/fetchWeekly/rejected', 
                        error: { message: '無法連接到後端服務，請確保後端服務正在運行' } });
              return;
            }
            
            const api = activeTab === 'daily' ? 
              trendingApi.getDailyTrending(currentPage, pageSize, langParam) : 
              trendingApi.getWeeklyTrending(currentPage, pageSize, langParam);
            const response = await api;
            console.log('Direct API response:', response);
            if (response && response.data && Array.isArray(response.data)) {
              console.log('API returned valid data array with length:', response.data.length);
              if (activeTab === 'daily') {
                dispatch({ type: 'trending/fetchDaily/fulfilled', payload: response.data });
              } else {
                dispatch({ type: 'trending/fetchWeekly/fulfilled', payload: response.data });
              }
            } else {
              console.error('API response format is invalid:', response);
              dispatch({ type: activeTab === 'daily' ? 'trending/fetchDaily/rejected' : 'trending/fetchWeekly/rejected', 
                        error: { message: 'API返回的數據格式不正確' } });
            }
          } catch (err) {
            console.error('Direct API call failed:', err);
            dispatch({ type: activeTab === 'daily' ? 'trending/fetchDaily/rejected' : 'trending/fetchWeekly/rejected', 
                      error: { message: `API調用失敗: ${err.message}` } });
          }
        };
        fetchDirectly();
      }
    }
  }, [loading, error, dailyData, weeklyData, activeTab, language, currentPage, pageSize, dispatch]);
  // 使用實際的數據源作為依賴項，而不是派生的currentData，避免循環依賴
  
  // 添加语言选项列表
  const languageOptions = [
    { value: 'all', label: '所有语言' },
    { value: 'javascript', label: 'JavaScript' },
    { value: 'python', label: 'Python' },
    { value: 'java', label: 'Java' },
    { value: 'go', label: 'Go' },
    { value: 'rust', label: 'Rust' },
    { value: 'typescript', label: 'TypeScript' },
    { value: 'c++', label: 'C++' },
    { value: 'c#', label: 'C#' },
    { value: 'php', label: 'PHP' }
  ];

  const handleTabChange = (key) => {
    setActiveTab(key);
  };

  const handleLanguageChange = (value) => {
    console.log('Language changed to:', value);
    setLanguage(value);
  };

  const getLanguageStats = () => {
    const stats = {};
    currentData.forEach(item => {
      if (item.language) {
        stats[item.language] = (stats[item.language] || 0) + 1;
      }
    });
    return Object.entries(stats).map(([name, value]) => ({ name, value }));
  };

  // 添加调试日志，查看Redux状态
  useEffect(() => {
    console.log('Redux state updated:', { dailyData, weeklyData, loading, error });
    console.log('Current data:', currentData);
  }, [dailyData, weeklyData, loading, error, currentData]);

  return (
    <Layout className="min-h-screen bg-gray-50">
      <Header className="flex items-center bg-gradient-to-r from-blue-600 to-blue-800 shadow-md">
        <div className="flex items-center text-white">
          <TrendingUp className="w-6 h-6 mr-2" />
          <span className="text-xl font-bold">GitHub Trending</span>
        </div>
      </Header>
      <Content className="p-6">
        <Card className="mb-6 shadow-md rounded-lg overflow-hidden border-0">
          <div className="flex flex-col md:flex-row md:justify-between md:items-center mb-4 gap-4">
            <Tabs 
              activeKey={activeTab} 
              onChange={handleTabChange}
              className="font-medium"
              type="card"
            >
              <TabPane tab={<span className="px-2">日榜</span>} key="daily" />
              <TabPane tab={<span className="px-2">周榜</span>} key="weekly" />
            </Tabs>

            <Select
              value={language}
              style={{ width: 200 }}
              onChange={handleLanguageChange}
              className="self-end md:self-auto"
              placeholder="选择编程语言"
            >
              {languageOptions.map(option => (
                <Option key={option.value} value={option.value}>{option.label}</Option>
              ))}
            </Select>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200">
              <p className="flex items-center">
                <span className="mr-2">⚠️</span>
                {error}
              </p>
              <p className="mt-2 text-sm">请检查网络连接或稍后再试</p>
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <Card title="项目语言分布" className="shadow-sm" bordered={false}>
              <Spin spinning={loading}>
                <ReactECharts
                  option={{
                    tooltip: {
                      trigger: 'item',
                      formatter: '{a} <br/>{b}: {c} ({d}%)'
                    },
                    legend: {
                      orient: 'vertical',
                      right: 10,
                      top: 'center',
                      type: 'scroll'
                    },
                    series: [{
                      name: '语言分布',
                      type: 'pie',
                      radius: ['40%', '70%'],
                      avoidLabelOverlap: true,
                      itemStyle: {
                        borderRadius: 10,
                        borderColor: '#fff',
                        borderWidth: 2
                      },
                      label: {
                        show: false,
                        position: 'center'
                      },
                      emphasis: {
                        label: {
                          show: true,
                          fontSize: '18',
                          fontWeight: 'bold'
                        }
                      },
                      labelLine: {
                        show: false
                      },
                      data: getLanguageStats()
                    }]
                  }}
                  style={{ height: '350px' }}
                />
              </Spin>
            </Card>

            <Card title="热门项目统计" className="shadow-sm" bordered={false}>
              <Spin spinning={loading}>
                <ReactECharts
                  option={{
                    tooltip: {
                      trigger: 'axis',
                      axisPointer: {
                        type: 'shadow'
                      }
                    },
                    grid: {
                      left: '3%',
                      right: '4%',
                      bottom: '3%',
                      containLabel: true
                    },
                    xAxis: [
                      {
                        type: 'category',
                        data: currentData.slice(0, 10).map(item => item.name),
                        axisTick: {
                          alignWithLabel: true
                        },
                        axisLabel: {
                          rotate: 45,
                          interval: 0
                        }
                      }
                    ],
                    yAxis: [
                      {
                        type: 'value',
                        name: 'Stars'
                      }
                    ],
                    series: [
                      {
                        name: 'Stars',
                        type: 'bar',
                        barWidth: '60%',
                        data: currentData.slice(0, 10).map(item => item.starsCount || 0),
                        itemStyle: {
                          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#83bff6' },
                            { offset: 0.5, color: '#188df0' },
                            { offset: 1, color: '#188df0' }
                          ])
                        }
                      }
                    ]
                  }}
                  style={{ height: '350px' }}
                />
              </Spin>
            </Card>
          </div>
        </Card>

        <Card 
          title={
            <div className="flex items-center">
              <Github className="w-5 h-5 mr-2 text-blue-600" />
              <span>热门项目列表</span>
            </div>
          } 
          className="shadow-md rounded-lg border-0"
          loading={loading}
        >
          <List
            dataSource={currentData}
            locale={{
              emptyText: (
                <div className="py-8 text-center">
                  <p className="text-gray-500 mb-2">暂无数据</p>
                  <p className="text-sm text-gray-400">请尝试更换语言或时间范围</p>
                </div>
              )
            }}
            pagination={{
              current: currentPage,
              pageSize: pageSize,
              total: currentData.length,
              onChange: (page) => setCurrentPage(page),
              showSizeChanger: false
            }}
            loading={{
              spinning: loading,
              tip: '正在加载数据...',
              size: 'large'
            }}
            renderItem={item => (
              <List.Item>
                <Card 
                  hoverable 
                  className="w-full transition-all duration-300 hover:shadow-md border-0 shadow-sm"
                >
                  <Meta
                    avatar={<Avatar src={`https://github.com/${item.author}.png`} />}
                    title={
                      <a 
                        href={item.repositoryUrl} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="text-blue-600 hover:text-blue-800 transition-colors duration-200"
                      >
                        {item.author}/{item.name}
                      </a>
                    }
                    description={
                      <Tooltip title={item.description}>
                        <p className="line-clamp-2 text-gray-600">{item.description}</p>
                      </Tooltip>
                    }
                  />
                  <div className="flex flex-wrap items-center mt-4 text-sm text-gray-600 gap-4">
                    <Tooltip title="Stars">
                      <div className="flex items-center">
                        <Star className="w-4 h-4 mr-1 text-yellow-500" />
                        <span>{item.starsCount ? item.starsCount.toLocaleString() : '0'}</span>
                      </div>
                    </Tooltip>
                    
                    <Tooltip title="Forks">
                      <div className="flex items-center">
                        <GitFork className="w-4 h-4 mr-1 text-gray-500" />
                        <span>{item.forksCount ? item.forksCount.toLocaleString() : '-'}</span>
                      </div>
                    </Tooltip>
                    
                    {item.language && (
                      <Tooltip title="Programming Language">
                        <Tag color="blue" className="flex items-center m-0">
                          <Code className="w-3 h-3 mr-1" />
                          {item.language}
                        </Tag>
                      </Tooltip>
                    )}
                    
                    <Tooltip title="Last Updated">
                      <div className="flex items-center">
                        <span className="text-xs text-gray-500">{item.updatedAt}</span>
                      </div>
                    </Tooltip>
                  </div>
                </Card>
              </List.Item>
            )}
          />
        </Card>
      </Content>
    </Layout>
  );
};

export default TrendingPage;
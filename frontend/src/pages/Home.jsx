import React, { useState, useEffect } from 'react'
import { Layout, Card, Tabs, Select, List, Spin, Alert } from 'antd'
import ReactECharts from 'echarts-for-react'
import { trendingApi } from '../services/api'

const { Header, Content } = Layout
const { TabPane } = Tabs
const { Option } = Select
const { Meta } = Card

const Home = () => {
  const [data, setData] = useState([])
  const [viewType, setViewType] = useState('daily')
  const [language, setLanguage] = useState('all')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true)
      setError(null)
      try {
        // 根据选择的视图类型调用不同的API
        const apiMethod = viewType === 'daily' ? 
          trendingApi.getDailyTrending : 
          trendingApi.getWeeklyTrending;
        
        const response = await apiMethod(1, 50, language);
        console.log(`Home ${viewType} API response:`, response);
        
        if (response && response.data) {
          if (Array.isArray(response.data)) {
            setData(response.data);
            console.log(`Home ${viewType} data loaded:`, response.data);
          } else {
            console.error('API返回的数据格式不正确:', response.data);
            setError('数据格式不正确');
            setData([]);
          }
        } else {
          console.error('API返回的数据为空');
          setError('获取数据失败，返回数据为空');
          setData([]);
        }
      } catch (err) {
        setError('获取数据失败，请稍后再试');
        console.error('Error fetching data:', err);
        setData([]);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [viewType, language])

  const handleTabChange = (key) => {
    setViewType(key)
  }

  const handleLanguageChange = (value) => {
    setLanguage(value)
  }

  const getLanguageStats = () => {
    const stats = {}
    data.forEach(item => {
      if (item.language) {
        stats[item.language] = (stats[item.language] || 0) + 1
      }
    })
    return Object.entries(stats).map(([name, value]) => ({ name, value }))
  }

  return (
    <Layout>
      <Header style={{ color: '#fff' }}>GitHub Trending 首页</Header>
      <Content style={{ padding: '24px' }}>
        <Tabs activeKey={viewType} onChange={handleTabChange}>
          <TabPane tab="日榜" key="daily" />
          <TabPane tab="周榜" key="weekly" />
        </Tabs>

        <div style={{ marginBottom: 16 }}>
          <Select
            value={language}
            style={{ width: 200 }}
            onChange={handleLanguageChange}
          >
            <Option value="all">所有语言</Option>
            <Option value="javascript">JavaScript</Option>
            <Option value="python">Python</Option>
            <Option value="java">Java</Option>
          </Select>
        </div>

        {data.length > 0 && (
          <div style={{ marginBottom: 24 }}>
            <ReactECharts
              option={{
                title: {
                  text: '项目语言分布'
                },
                tooltip: {
                  trigger: 'item',
                  formatter: '{a} <br/>{b}: {c} ({d}%)'
                },
                series: [{
                  name: '语言分布',
                  type: 'pie',
                  radius: '60%',
                  data: getLanguageStats()
                }]
              }}
            />
          </div>
        )}

        {error && <Alert message={error} type="error" style={{ marginBottom: 16 }} />}

        <Spin spinning={loading}>
          <Card title="项目列表">
            <List
              dataSource={data}
              renderItem={item => (
                <List.Item>
                  <Card style={{ width: '100%' }}>
                    <Meta
                      title={<a href={item.url} target="_blank" rel="noopener noreferrer">{item.name}</a>}
                      description={item.description}
                    />
                    <div style={{ marginTop: 16 }}>
                      <span style={{ marginRight: 16 }}>⭐ {item.stars}</span>
                      {item.forks && <span style={{ marginRight: 16 }}>🍴 {item.forks}</span>}
                      {item.updatedAt && <span style={{ marginRight: 16 }}>📅 {item.updatedAt}</span>}
                      {item.language && <span>🔤 {item.language}</span>}
                    </div>
                  </Card>
                </List.Item>
              )}
            />
          </Card>
        </Spin>
      </Content>
    </Layout>
  )
}

export default Home

import React, { useState, useEffect } from 'react'
import { Table, Select, Card, Row, Col, Spin, Tooltip, Tag, Avatar } from 'antd'
import ReactECharts from 'echarts-for-react'
import * as echarts from 'echarts/core'
import { trendingApi } from '../services/api'
import { BarChart2, Star, GitFork, Code, Github } from 'lucide-react'

export function DataAnalysis() {
  const [data, setData] = useState([])
  const [language, setLanguage] = useState('all')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [language])

  const fetchData = async () => {
    setLoading(true)
    try {
      const response = await trendingApi.getDailyTrending(1, 50, language)
      console.log('DataAnalysis API response:', response)
      if (response && response.data) {
        if (Array.isArray(response.data)) {
          setData(response.data)
        } else {
          console.error('API返回的数据格式不正确:', response.data)
          setData([])
        }
      } else {
        console.error('API返回的数据为空')
        setData([])
      }
    } catch (error) {
      console.error('获取数据失败:', error)
      setData([])
    } finally {
      setLoading(false)
    }
  }

  const columns = [
    { title: '项目名称', dataIndex: 'name', key: 'name', 
      render: (text, record) => (
        <a href={record.repositoryUrl} target="_blank" rel="noopener noreferrer">{text}</a>
      )
    },
    { title: 'Stars', dataIndex: 'starsCount', key: 'starsCount', sorter: (a, b) => a.starsCount - b.starsCount },
    { title: 'Forks', dataIndex: 'forksCount', key: 'forksCount', sorter: (a, b) => a.forksCount - b.forksCount },
    { title: '语言', dataIndex: 'language', key: 'language' },
    { title: '更新时间', dataIndex: 'updatedAt', key: 'updatedAt' },
  ]

  const getLanguageStats = () => {
    const stats = {}
    data.forEach(item => {
      if (item.language) {
        stats[item.language] = (stats[item.language] || 0) + 1
      }
    })
    return Object.entries(stats).map(([name, value]) => ({ name, value }))
  }

  const getStarsDistribution = () => {
    const distribution = data.map(item => item.starsCount).sort((a, b) => a - b)
    return {
      xAxis: { type: 'value', name: 'Stars' },
      yAxis: { type: 'value', name: '项目数量' },
      series: [{
        type: 'bar',
        data: distribution,
        barWidth: '99%'
      }]
    }
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">数据分析</h1>

      <Row gutter={[16, 16]} className="mb-6">
        <Col span={12}>
          <Card title="语言分布" loading={loading}>
            <ReactECharts
              option={{
                tooltip: { trigger: 'item' },
                series: [{
                  type: 'pie',
                  radius: '70%',
                  data: getLanguageStats(),
                  emphasis: {
                    itemStyle: {
                      shadowBlur: 10,
                      shadowOffsetX: 0,
                      shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                  }
                }]
              }}
            />
          </Card>
        </Col>
        <Col span={12}>
          <Card title="Stars 分布" loading={loading}>
            <ReactECharts option={getStarsDistribution()} />
          </Card>
        </Col>
      </Row>

      <Card title="项目列表" className="mb-6">
        <div className="mb-4">
          <Select value={language} onChange={setLanguage} style={{ width: 200 }}>
            <Select.Option value="all">所有语言</Select.Option>
            <Select.Option value="JavaScript">JavaScript</Select.Option>
            <Select.Option value="Python">Python</Select.Option>
            <Select.Option value="Java">Java</Select.Option>
            <Select.Option value="TypeScript">TypeScript</Select.Option>
            <Select.Option value="Go">Go</Select.Option>
          </Select>
        </div>
        <Table 
          dataSource={data} 
          columns={columns} 
          rowKey="id" 
          loading={loading}
          pagination={{ 
            pageSize: 10,
            showSizeChanger: true,
            showTotal: (total) => `共 ${total} 条数据`
          }}
        />
      </Card>
    </div>
  )
}

export default DataAnalysis

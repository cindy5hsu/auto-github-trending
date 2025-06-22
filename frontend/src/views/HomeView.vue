<template>
  <a-layout-content>
    <a-row :gutter="[16, 16]">
      <a-col :span="24">
        <a-space>
          <a-select v-model:value="selectedPeriod" style="width: 120px">
            <a-select-option value="daily">日榜</a-select-option>
            <a-select-option value="weekly">周榜</a-select-option>
          </a-select>
          <a-select v-model:value="selectedLanguage" style="width: 200px" placeholder="选择语言">
            <a-select-option v-for="lang in languages" :key="lang" :value="lang">{{ lang }}</a-select-option>
          </a-select>
          <a-button type="primary" @click="fetchData">筛选</a-button>
        </a-space>
      </a-col>
      <a-col :span="24">
        <a-table :dataSource="repositories" :columns="columns" :pagination="false">
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'name'">
            <a-card>
              <a-card-meta :title="record.name" :description="record.description">
                <template #avatar>
                  <a-avatar :src="record.avatarUrl" />
                </template>
              </a-card-meta>
              <template #extra>
                <a-space>
                  <span>{{ record.starsCount }} stars</span>
                  <span>{{ record.forksCount }} forks</span>
                </a-space>
              </template>
            </a-card>
            </template>
          </template>
        </a-table>
      </a-col>
    </a-row>
  </a-layout-content>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { message } from 'ant-design-vue';

const selectedPeriod = ref('daily');
const selectedLanguage = ref('');
const languages = ref([]);
const repositories = ref([]);

const columns = [
  {
    title: '项目名称',
    dataIndex: 'name',
    key: 'name',
  },
  {
    title: '语言',
    dataIndex: 'language',
    key: 'language',
  },
  {
    title: '星标数',
    dataIndex: 'starsCount',
    key: 'starsCount',
    sorter: true,
  },
  {
    title: 'Fork数',
    dataIndex: 'forksCount',
    key: 'forksCount',
    sorter: true,
  },
];

const fetchData = async () => {
  try {
    const apiMethod = selectedPeriod.value === 'daily' 
      ? trendingApi.getDailyTrending 
      : trendingApi.getWeeklyTrending;
    const { data } = await apiMethod(1, 50, selectedLanguage.value);
    repositories.value = data;
  } catch (error) {
    message.error('获取数据失败');
  }
};

onMounted(() => {
  fetchData();
  fetchLanguages();
});

const fetchLanguages = async () => {
  try {
    const { data } = await trendingApi.getLanguages();
    languages.value = data;
  } catch (error) {
    message.error('获取语言列表失败');
  }
};
</script>

<style scoped>
.ant-card {
  margin-bottom: 16px;
}
</style>
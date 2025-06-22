import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { trendingApi } from '../services/api';

export const fetchDailyTrending = createAsyncThunk(
  'trending/fetchDaily',
  async ({ page, size, language }) => {
    console.log('Fetching daily trending with params:', { page, size, language });
    // 確保language參數處理一致
    const langParam = language === 'all' ? '' : language;
    console.log('Processed language param for Redux thunk:', { original: language, processed: langParam });
    try {
      const response = await trendingApi.getDailyTrending(page, size, langParam);
      console.log('Daily trending API response:', response);
      if (!response.data || !Array.isArray(response.data)) {
        console.error('Invalid API response format:', response.data);
        return [];
      }
      return response.data;
    } catch (error) {
      console.error('Error fetching daily trending:', error);
      throw error;
    }
  }
);

export const fetchWeeklyTrending = createAsyncThunk(
  'trending/fetchWeekly',
  async ({ page, size, language }) => {
    console.log('Fetching weekly trending with params:', { page, size, language });
    // 確保language參數處理一致
    const langParam = language === 'all' ? '' : language;
    console.log('Processed language param for Redux thunk:', { original: language, processed: langParam });
    try {
      const response = await trendingApi.getWeeklyTrending(page, size, langParam);
      console.log('Weekly trending API response:', response);
      if (!response.data || !Array.isArray(response.data)) {
        console.error('Invalid API response format:', response.data);
        return [];
      }
      return response.data;
    } catch (error) {
      console.error('Error fetching weekly trending:', error);
      throw error;
    }
  }
);

const trendingSlice = createSlice({
  name: 'trending',
  initialState: {
    dailyData: [],
    weeklyData: [],
    executionRecords: [],
    loading: false,
    error: null
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchDailyTrending.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchDailyTrending.fulfilled, (state, action) => {
        state.loading = false;
        state.dailyData = action.payload;
      })
      .addCase(fetchDailyTrending.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message;
      })
      .addCase(fetchWeeklyTrending.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchWeeklyTrending.fulfilled, (state, action) => {
        state.loading = false;
        state.weeklyData = action.payload;
      })
      .addCase(fetchWeeklyTrending.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message;
      });
  }
});

export default trendingSlice.reducer;
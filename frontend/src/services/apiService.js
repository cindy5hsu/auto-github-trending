export const fetchTrendingData = async (viewType, language, page = 1, size = 50) => {
  try {
    // 處理language參數，確保'all'被轉換為空字符串
    const langParam = language === 'all' ? '' : language;
    console.log('Fetching trending data with params:', { viewType, language: langParam, page, size });
    
    const response = await fetch(`http://localhost:8081/api/trending/${viewType}?language=${langParam}&page=${page}&size=${size}`);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return await response.json();
  } catch (error) {
    console.error('Error fetching trending data:', error);
    return [];
  }
};

export const fetchProjectDetails = async (id, page = 1, size = 50) => {
  try {
    console.log('Fetching project details with params:', { id, page, size });
    
    const response = await fetch(`http://localhost:8081/api/projects/${id}?page=${page}&size=${size}`);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return await response.json();
  } catch (error) {
    console.error('Error fetching project details:', error);
    return null;
  }
};
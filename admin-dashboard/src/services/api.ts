import axios from 'axios';

const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api';

export const getImageUrl = (url?: string): string => {
  if (!url) return '';
  if (url.startsWith('http')) return url;
  let cleanUrl = url;
  if (cleanUrl.startsWith('/storage/')) cleanUrl = cleanUrl.replace('/storage/', '');
  if (cleanUrl.startsWith('storage/')) cleanUrl = cleanUrl.replace('storage/', '');
  if (cleanUrl.startsWith('/')) cleanUrl = cleanUrl.substring(1);
  return `${baseURL.replace('/api', '/storage')}/${cleanUrl}`;
};
const api = axios.create({
  baseURL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response) => response.data,
  (error) => {
    // Optionally handle global unauthorized errors
    if (error.response?.status === 401) {
      localStorage.removeItem('admin_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;

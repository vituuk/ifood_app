import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { Toaster } from "@/components/ui/sonner"

import DashboardLayout from '@/layouts/DashboardLayout'
import Login from '@/pages/Login'
import DashboardHome from '@/pages/DashboardHome'
import FoodsManager from '@/pages/FoodsManager'
import CategoriesManager from '@/pages/CategoriesManager'
import OrdersManager from '@/pages/OrdersManager'
import UsersManager from '@/pages/UsersManager'

const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const token = localStorage.getItem('admin_token')
  if (!token) {
    return <Navigate to="/login" replace />
  }
  return <>{children}</>
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        
        <Route path="/" element={<ProtectedRoute><DashboardLayout /></ProtectedRoute>}>
          <Route index element={<DashboardHome />} />
          <Route path="foods" element={<FoodsManager />} />
          <Route path="categories" element={<CategoriesManager />} />
          <Route path="orders" element={<OrdersManager />} />
          <Route path="users" element={<UsersManager />} />
        </Route>
      </Routes>
      <Toaster />
    </Router>
  )
}

export default App

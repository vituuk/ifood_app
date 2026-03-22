import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card"
import { Users, Pizza, ShoppingBag, DollarSign } from "lucide-react"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import api from '@/services/api'

export default function DashboardHome() {
  const [stats, setStats] = useState({
    revenue: 0,
    orders: 0,
    foods: 0,
    users: 0,
  })
  const [chartData, setChartData] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [ordersRes, foodsRes, usersRes]: any = await Promise.all([
          api.get('/orders').catch(() => ({ success: false })),
          api.get('/foods?per_page=1000').catch(() => ({ success: false })),
          api.get('/get-data').catch(() => ({ success: false }))
        ])
        
        let revenue = 0
        let orderCount = 0
        if (ordersRes.success && Array.isArray(ordersRes.data)) {
          orderCount = ordersRes.data.length
          revenue = ordersRes.data.reduce((sum: number, order: any) => sum + Number(order.total_amount || 0), 0)
          
          // Generate Chart Data from orders
          const groupedOrders = ordersRes.data.reduce((acc: any, order: any) => {
            const date = new Date(order.created_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
            acc[date] = (acc[date] || 0) + Number(order.total_amount || 0)
            return acc
          }, {})
          
          const formattedChartData = Object.keys(groupedOrders).map(date => ({
            date,
            revenue: groupedOrders[date]
          }))
          setChartData(formattedChartData)
        }
        
        let foodCount = 0
        if (foodsRes.success) {
          foodCount = foodsRes.data?.data?.length || foodsRes.data?.length || 0
        }
        
        let userCount = 0
        if (usersRes.success && Array.isArray(usersRes.data)) {
          userCount = usersRes.data.length
        }

        setStats({
          revenue,
          orders: orderCount,
          foods: foodCount,
          users: userCount,
        })
      } catch (e) {
        console.error("Error fetching stats", e)
      } finally {
        setLoading(false)
      }
    }
    fetchStats()
  }, [])

  return (
    <div className="space-y-6">
      <h2 className="text-3xl font-bold tracking-tight">Dashboard Overview</h2>
      
      {loading ? (
        <div className="text-muted-foreground animate-pulse">Loading statistics...</div>
      ) : (
      <>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card className="shadow-sm hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">${stats.revenue.toFixed(2)}</div>
              <p className="text-xs text-muted-foreground">Across all time</p>
            </CardContent>
          </Card>
          <Card className="shadow-sm hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Orders</CardTitle>
              <ShoppingBag className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.orders}</div>
              <p className="text-xs text-muted-foreground">Across all time</p>
            </CardContent>
          </Card>
          <Card className="shadow-sm hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Foods Listed</CardTitle>
              <Pizza className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.foods}</div>
              <p className="text-xs text-muted-foreground">Available menu items</p>
            </CardContent>
          </Card>
          <Card className="shadow-sm hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Registered Users</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.users}</div>
              <p className="text-xs text-muted-foreground">Platform accounts</p>
            </CardContent>
          </Card>
        </div>

        {/* Chart Section */}
        <Card className="mt-8 shadow-sm">
          <CardHeader>
            <CardTitle>Revenue Overview</CardTitle>
            <CardDescription>Daily revenue aggregated from customer orders.</CardDescription>
          </CardHeader>
          <CardContent>
            {chartData.length > 0 ? (
              <div className="h-[350px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                    <XAxis dataKey="date" tickLine={false} axisLine={false} tick={{ fontSize: 12 }} dy={10} />
                    <YAxis 
                      tickFormatter={(value) => `$${value}`} 
                      tickLine={false} 
                      axisLine={false} 
                      tick={{ fontSize: 12 }} 
                    />
                    <Tooltip 
                      cursor={{ fill: 'rgba(0,0,0,0.05)' }}
                      formatter={(value: any) => [`$${Number(value).toFixed(2)}`, 'Revenue']}
                      contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}
                    />
                    <Bar 
                      dataKey="revenue" 
                      fill="hsl(var(--primary))" 
                      radius={[4, 4, 0, 0]} 
                      barSize={40} 
                    />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            ) : (
              <div className="h-[350px] flex items-center justify-center text-muted-foreground">
                No revenue data available yet.
              </div>
            )}
          </CardContent>
        </Card>
      </>
      )}
    </div>
  )
}

import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Edit, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import api from '@/services/api'
import { toast } from 'sonner'

export default function OrdersManager() {
  const [orders, setOrders] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  const fetchOrders = async () => {
    try {
      setLoading(true)
      const res: any = await api.get('/orders')
      if (res.success) {
        setOrders(res.data)
      }
    } catch (e) {
      toast.error("Failed to load orders")
    } finally {
      setLoading(false)
    }
  }

  const deleteOrder = async (id: number) => {
    if (!window.confirm('Are you sure you want to delete this order?')) return;
    try {
      const res: any = await api.delete(`/orders/${id}`);
      if (res.success) {
        toast.success('Order deleted successfully');
        fetchOrders();
      } else {
        toast.error(res.message || 'Failed to delete order');
      }
    } catch (e) {
      toast.error('An error occurred while deleting the order');
    }
  };

  const updateOrderStatus = async (id: number, currentStatus: string) => {
    const newStatus = window.prompt(
      'Enter new status (pending, confirmed, preparing, delivering, delivered, cancelled):', 
      currentStatus
    );
    if (!newStatus || newStatus === currentStatus) return;
    
    try {
      const res: any = await api.put(`/orders/${id}`, { status: newStatus.toLowerCase().trim() });
      if (res.success) {
        toast.success('Order status updated');
        fetchOrders();
      } else {
        toast.error(res.message || 'Failed to update order status');
      }
    } catch (e) {
      toast.error('An error occurred while updating the order status');
    }
  };

  useEffect(() => {
    fetchOrders()
  }, [])

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <h2 className="text-3xl font-bold tracking-tight">Manage Orders</h2>
      </div>
      
      <Card>
        <CardHeader className="py-2" />
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Order ID</TableHead>
                  <TableHead>Customer</TableHead>
                  <TableHead>Total Amount</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Date</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={6} className="text-center py-10">Loading...</TableCell></TableRow>
                ) : orders.length === 0 ? (
                  <TableRow><TableCell colSpan={6} className="text-center py-10">No orders found</TableCell></TableRow>
                ) : (
                  orders.map((order) => (
                    <TableRow key={order.id}>
                      <TableCell className="font-medium">#{order.order_number}</TableCell>
                      <TableCell>{order.user?.name || 'Guest'}</TableCell>
                      <TableCell>${Number(order.total_amount).toFixed(2)}</TableCell>
                      <TableCell>
                        <span className="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
                          {order.status || 'Pending'}
                        </span>
                      </TableCell>
                      <TableCell>{new Date(order.created_at).toLocaleDateString()}</TableCell>
                      <TableCell className="text-right">
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-blue-500"
                          onClick={() => updateOrderStatus(order.id, order.status)}
                        >
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-red-500"
                          onClick={() => deleteOrder(order.id)}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

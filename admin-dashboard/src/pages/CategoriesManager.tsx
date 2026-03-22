import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Plus, Edit, Trash2 } from 'lucide-react'
import api from '@/services/api'
import { toast } from 'sonner'

export default function CategoriesManager() {
  const [categories, setCategories] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingId, setEditingId] = useState<number | null>(null)
  
  const [name, setName] = useState('')
  const [slug, setSlug] = useState('')
  const [icon, setIcon] = useState('')
  const [status, setStatus] = useState('active')

  const fetchCategories = async () => {
    try {
      setLoading(true)
      const res: any = await api.get(`/categories`)
      if (res.success) {
        setCategories(res.data)
      }
    } catch (e) {
      toast.error("Failed to load categories")
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchCategories()
  }, [])

  const handleOpenDialog = (category?: any) => {
    if (category) {
      setEditingId(category.id)
      setName(category.name)
      setSlug(category.slug)
      setIcon(category.icon || '')
      setStatus(category.status || 'active')
    } else {
      setEditingId(null)
      setName('')
      setSlug('')
      setIcon('')
      setStatus('active')
    }
    setDialogOpen(true)
  }

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const payload = { name, slug, icon, status }
      if (editingId) {
        await api.put(`/categories/${editingId}`, payload)
        toast.success("Category updated")
      } else {
        await api.post(`/categories`, payload)
        toast.success("Category created")
      }
      setDialogOpen(false)
      fetchCategories()
    } catch (err: any) {
      toast.error(err.response?.data?.message || "Error saving category")
    }
  }

  const handleDelete = async (id: number) => {
    if (!confirm("Are you sure you want to delete this category?")) return
    try {
      await api.delete(`/categories/${id}`)
      toast.success("Category deleted")
      fetchCategories()
    } catch (err) {
      toast.error("Error deleting category")
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <h2 className="text-3xl font-bold tracking-tight">Manage Categories</h2>
        <Button className="flex items-center gap-2" onClick={() => handleOpenDialog()}>
          <Plus className="h-4 w-4" /> Add Category
        </Button>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{editingId ? 'Edit Category' : 'Add Category'}</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSave} className="space-y-4">
            <div className="space-y-2">
              <Label>Name</Label>
              <Input required value={name} onChange={e => { setName(e.target.value); if(!editingId) setSlug(e.target.value.toLowerCase().replace(/ /g, '-')) }} />
            </div>
            <div className="space-y-2">
              <Label>Slug</Label>
              <Input required value={slug} onChange={e => setSlug(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Icon (Emoji)</Label>
              <Input value={icon} onChange={e => setIcon(e.target.value)} placeholder="🍔" />
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>Cancel</Button>
              <Button type="submit">Save</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
      
      <Card>
        <CardHeader className="py-2" />
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[80px]">Icon</TableHead>
                  <TableHead>Category Name</TableHead>
                  <TableHead>Items Count</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={5} className="text-center py-10">Loading...</TableCell></TableRow>
                ) : categories.length === 0 ? (
                  <TableRow><TableCell colSpan={5} className="text-center py-10">No categories found</TableCell></TableRow>
                ) : (
                  categories.map((category) => (
                    <TableRow key={category.id}>
                      <TableCell>
                        <div className="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-xl">
                          {category.icon || '🏷️'}
                        </div>
                      </TableCell>
                      <TableCell className="font-medium text-lg">{category.name}</TableCell>
                      <TableCell>{category.foods_count ?? 0} items</TableCell>
                      <TableCell>
                        <span className={`px-2 py-1 rounded-full text-xs font-semibold ${
                          category.status === 'active' 
                            ? 'bg-green-100 text-green-700' 
                            : 'bg-gray-100 text-gray-700'
                        }`}>
                          {category.status || 'Active'}
                        </span>
                      </TableCell>
                      <TableCell className="text-right">
                        <Button variant="ghost" size="icon" className="text-blue-500 hover:text-blue-700 hover:bg-blue-50" onClick={() => handleOpenDialog(category)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon" className="text-red-500 hover:text-red-700 hover:bg-red-50" onClick={() => handleDelete(category.id)}>
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

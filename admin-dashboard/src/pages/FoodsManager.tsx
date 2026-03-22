import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Plus, Search, Edit, Trash2 } from 'lucide-react'
import api, { getImageUrl } from '@/services/api'
import { toast } from 'sonner'

export default function FoodsManager() {
  const [foods, setFoods] = useState<any[]>([])
  const [categories, setCategories] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingId, setEditingId] = useState<number | null>(null)
  
  // Form State
  const [name, setName] = useState('')
  const [slug, setSlug] = useState('')
  const [description, setDescription] = useState('')
  const [price, setPrice] = useState('0')
  const [image, setImage] = useState('')
  const [categoryId, setCategoryId] = useState('')
  const [prepTime, setPrepTime] = useState('15')
  
  const fetchFoods = async () => {
    try {
      setLoading(true)
      const res: any = await api.get(`/foods?search=${search}&per_page=100`)
      if (res.success) {
        setFoods(res.data.data || res.data)
      }
    } catch (e) {
      toast.error("Failed to load foods")
    } finally {
      setLoading(false)
    }
  }

  const fetchCategories = async () => {
    try {
      const res: any = await api.get(`/categories`)
      if (res.success) setCategories(res.data)
    } catch (e) {}
  }

  useEffect(() => {
    fetchFoods()
    fetchCategories()
  }, [])

  const handleOpenDialog = (food?: any) => {
    if (food) {
      setEditingId(food.id)
      setName(food.name)
      setSlug(food.slug)
      setDescription(food.description)
      setPrice(food.price.toString())
      setImage(food.image || food.imageUrl || '')
      setCategoryId(food.category_id.toString())
      setPrepTime(food.prep_time?.toString() || '15')
    } else {
      setEditingId(null)
      setName('')
      setSlug('')
      setDescription('')
      setPrice('0')
      setImage('')
      setCategoryId(categories.length > 0 ? categories[0].id.toString() : '')
      setPrepTime('15')
    }
    setDialogOpen(true)
  }

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const payload = { 
        name, slug, description, price: Number(price), image, category_id: Number(categoryId), prep_time: Number(prepTime) 
      }
      if (editingId) {
        await api.put(`/foods/${editingId}`, payload)
        toast.success("Food updated")
      } else {
        await api.post(`/foods`, payload)
        toast.success("Food created")
      }
      setDialogOpen(false)
      fetchFoods()
    } catch (err: any) {
      toast.error(err.response?.data?.message || "Error saving food")
    }
  }

  const handleDelete = async (id: number) => {
    if (!confirm("Are you sure you want to delete this food?")) return
    try {
      await api.delete(`/foods/${id}`)
      toast.success("Food deleted")
      fetchFoods()
    } catch (err) {
      toast.error("Error deleting food")
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <h2 className="text-3xl font-bold tracking-tight">Manage Foods</h2>
        <Button className="flex items-center gap-2" onClick={() => handleOpenDialog()}>
          <Plus className="h-4 w-4" /> Add Food
        </Button>
      </div>
      
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="max-w-xl">
          <DialogHeader>
            <DialogTitle>{editingId ? 'Edit Food' : 'Add Food'}</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSave} className="space-y-4 max-h-[70vh] overflow-y-auto px-1">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Name</Label>
                <Input required value={name} onChange={e => { setName(e.target.value); if(!editingId) setSlug(e.target.value.toLowerCase().replace(/ /g, '-')) }} />
              </div>
              <div className="space-y-2">
                <Label>Slug</Label>
                <Input required value={slug} onChange={e => setSlug(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>Price ($)</Label>
                <Input type="number" step="0.01" required value={price} onChange={e => setPrice(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>Category</Label>
                <select className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" value={categoryId} onChange={e => setCategoryId(e.target.value)}>
                  {categories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>
              <div className="space-y-2">
                <Label>Prep Time (mins)</Label>
                <Input type="number" required value={prepTime} onChange={e => setPrepTime(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>Image URL</Label>
                <Input required value={image} onChange={e => setImage(e.target.value)} />
              </div>
              <div className="col-span-2 space-y-2">
                <Label>Description</Label>
                <Input required value={description} onChange={e => setDescription(e.target.value)} />
              </div>
            </div>
            <DialogFooter className="mt-4">
              <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>Cancel</Button>
              <Button type="submit">Save Food</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
      
      <Card>
        <CardHeader className="py-4">
          <div className="flex flex-wrap gap-2 justify-between">
            <div className="flex gap-2 w-full max-w-sm">
              <Input 
                placeholder="Search by name..." 
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && fetchFoods()}
              />
              <Button variant="secondary" onClick={fetchFoods}>
                <Search className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-[80px]">Image</TableHead>
                  <TableHead>Food Name</TableHead>
                  <TableHead>Category</TableHead>
                  <TableHead>Price</TableHead>
                  <TableHead>Rating</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow><TableCell colSpan={6} className="text-center py-10">Loading...</TableCell></TableRow>
                ) : foods.length === 0 ? (
                  <TableRow><TableCell colSpan={6} className="text-center py-10">No foods found</TableCell></TableRow>
                ) : (
                  foods.map((food) => (
                    <TableRow key={food.id}>
                      <TableCell>
                        <img 
                          src={getImageUrl(food.image || food.imageUrl)} 
                          alt={food.name} 
                          className="w-12 h-12 rounded object-cover shadow-sm bg-gray-100" 
                        />
                      </TableCell>
                      <TableCell className="font-medium">{food.name}</TableCell>
                      <TableCell>
                        <span className="bg-primary/10 text-primary text-xs px-2 py-1 rounded-full font-medium">
                          {food.category?.name || 'Uncategorized'}
                        </span>
                      </TableCell>
                      <TableCell>${Number(food.price).toFixed(2)}</TableCell>
                      <TableCell>{food.rating} ⭐</TableCell>
                      <TableCell className="text-right">
                        <Button variant="ghost" size="icon" className="text-blue-500 hover:text-blue-700 hover:bg-blue-50" onClick={() => handleOpenDialog(food)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="icon" className="text-red-500 hover:text-red-700 hover:bg-red-50" onClick={() => handleDelete(food.id)}>
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

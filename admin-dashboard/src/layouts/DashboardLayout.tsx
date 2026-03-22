import { Link, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { 
  LayoutDashboard, 
  Pizza, 
  Settings, 
  Tags, 
  Users, 
  LogOut, 
  Menu
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'
import { 
  DropdownMenu, 
  DropdownMenuContent, 
  DropdownMenuItem, 
  DropdownMenuLabel, 
  DropdownMenuSeparator, 
  DropdownMenuTrigger 
} from '@/components/ui/dropdown-menu'
import { toast } from 'sonner'
import api from '@/services/api'

const navItems = [
  { name: 'Dashboard', href: '/', icon: LayoutDashboard },
  { name: 'Foods', href: '/foods', icon: Pizza },
  { name: 'Categories', href: '/categories', icon: Tags },
  { name: 'Orders', href: '/orders', icon: Settings },
  { name: 'Users', href: '/users', icon: Users },
]

export default function DashboardLayout() {
  const location = useLocation()
  const navigate = useNavigate()

  const handleLogout = async () => {
    try {
      await api.post('/logout')
    } catch (e) {
      // ignore
    } finally {
      localStorage.removeItem('admin_token')
      localStorage.removeItem('admin_user')
      toast.success("Logged out")
      navigate('/login')
    }
  }

  // Parse admin user from local storage
  const adminUserStr = localStorage.getItem('admin_user')
  const user = adminUserStr ? JSON.parse(adminUserStr) : { name: 'Admin', email: 'admin@example.com' }
  const userInitials = user.name ? user.name.slice(0, 2).toUpperCase() : 'AD'

  const NavLinks = () => (
    <nav className="space-y-2 mt-6 flex-1 px-4">
      {navItems.map((item) => {
        const isActive = location.pathname === item.href
        return (
          <Link
            key={item.href}
            to={item.href}
            className={`flex items-center gap-3 px-3 py-2 rounded-lg transition-all ${
              isActive 
                ? 'bg-primary text-primary-foreground font-medium shadow-md' 
                : 'text-muted-foreground hover:text-foreground hover:bg-muted'
            }`}
          >
            <item.icon className="h-5 w-5" />
            {item.name}
          </Link>
        )
      })}
    </nav>
  )

  return (
    <div className="flex min-h-screen bg-slate-50/50">
      {/* Desktop Sidebar */}
      <aside className="hidden border-r bg-white w-64 md:flex flex-col">
        <div className="h-14 flex items-center border-b px-6 font-semibold text-lg tracking-tight text-primary">
          iFood Admin
        </div>
        <NavLinks />
        <div className="p-4 border-t">
          <Button variant="ghost" className="w-full justify-start text-red-500 hover:text-red-600 hover:bg-red-50" onClick={handleLogout}>
            <LogOut className="mr-2 h-4 w-4" />
            Logout
          </Button>
        </div>
      </aside>

      {/* Main Content */}
      <div className="flex-1 flex flex-col">
        <header className="h-14 flex items-center px-4 border-b bg-white gap-4 lg:px-6">
          <Sheet>
            <SheetTrigger asChild>
              <Button variant="outline" size="icon" className="md:hidden">
                <Menu className="h-5 w-5" />
                <span className="sr-only">Toggle navigation</span>
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="w-64 p-0 flex flex-col">
              <div className="h-14 flex items-center border-b px-6 font-semibold text-lg tracking-tight text-primary">
                iFood Admin
              </div>
              <NavLinks />
              <div className="p-4 border-t">
                <Button variant="ghost" className="w-full justify-start text-red-500" onClick={handleLogout}>
                  <LogOut className="mr-2 h-4 w-4" />
                  Logout
                </Button>
              </div>
            </SheetContent>
          </Sheet>
          <div className="w-full flex justify-between items-center">
            <h1 className="font-semibold text-lg hidden md:block">
              {navItems.find(item => item.href === location.pathname)?.name || 'Admin'}
            </h1>
            <div className="flex items-center gap-4 ml-auto">
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" className="relative h-10 w-10 rounded-full border bg-primary/10 hover:bg-primary/20 transition-colors">
                    <span className="text-primary font-bold">{userInitials}</span>
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent className="w-56" align="end" forceMount>
                  <DropdownMenuLabel className="font-normal">
                    <div className="flex flex-col space-y-1">
                      <p className="text-sm font-medium leading-none">{user.name}</p>
                      <p className="text-xs leading-none text-muted-foreground">
                        {user.email}
                      </p>
                    </div>
                  </DropdownMenuLabel>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem className="text-red-500 cursor-pointer focus:bg-red-50 focus:text-red-600" onClick={handleLogout}>
                    <LogOut className="mr-2 h-4 w-4" />
                    <span>Log out</span>
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </div>
        </header>
        <main className="flex-1 p-4 md:p-6 overflow-auto">
          <Outlet />
        </main>
      </div>
    </div>
  )
}

import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/pages/HomePage.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: HomePage,
    meta: {
      title: '首页'
    }
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/pages/AboutPage.vue'),
    meta: {
      title: '关于'
    }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 路由守卫示例
router.beforeEach((to, from, next) => {
  // 设置页面标题
  const title = to.meta.title as string || import.meta.env.VITE_APP_TITLE
  document.title = `${title} - ${import.meta.env.VITE_APP_TITLE}`
  next()
})

export default router

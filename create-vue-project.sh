#!/bin/bash

# 创建 Vue3 + Vite + TypeScript + Element Plus + Supabase + Font Awesome 项目脚手架
# 使用 Biome 作为代码格式化工具

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "需要安装 $1 但未找到"
        exit 1
    fi
}

# 检查必要命令
check_command node
check_command npm

# 获取项目名称
if [ -z "$1" ]; then
    echo -n "请输入项目名称: "
    read PROJECT_NAME
else
    PROJECT_NAME="$1"
fi

if [ -z "$PROJECT_NAME" ]; then
    print_error "项目名称不能为空"
    exit 1
fi

# 创建项目目录
print_step "创建项目: $PROJECT_NAME"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 1. 使用 Vite 创建 Vue + TypeScript 项目
print_step "使用 Vite 创建 Vue + TypeScript 项目"
#yarn create vite . -- --template vue-ts

# 安装基础依赖
print_step "安装基础依赖"
yarn

# 2. 安装 Vue 相关依赖
print_step "安装 Vue 相关依赖"
yarn add pinia pinia-plugin-persistedstate vue-router@4

# 3. 安装 Element Plus
print_step "安装 Element Plus"
yarn add element-plus @element-plus/icons-vue

# 4. 安装 Supabase
print_step "安装 Supabase"
yarn add @supabase/supabase-js

# 5. 安装 Font Awesome
print_step "安装 Font Awesome"
yarn add @fortawesome/fontawesome-svg-core \
            @fortawesome/free-solid-svg-icons \
            @fortawesome/free-regular-svg-icons \
            @fortawesome/free-brands-svg-icons \
            @fortawesome/vue-fontawesome@latest-3

# 6. 安装开发依赖
print_step "安装开发依赖"
yarn add -D \
    @types/node \
    sass \
    unplugin-vue-components \
    unplugin-auto-import \
    @supabase/ssr

# 7. 安装 Biome (替代 ESLint + Prettier)
print_step "安装 Biome"
yarn add -D @biomejs/biome

# 8. 创建项目结构
print_step "创建项目目录结构"
mkdir -p src/{components,composables,layouts,pages,router,store,utils,assets,plugins,services,styles/element}
mkdir -p public

# 9. 创建配置文件
print_step "创建配置文件"

# 创建 vite.config.ts
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    AutoImport({
      resolvers: [ElementPlusResolver()],
      imports: ['vue', 'vue-router', 'vuex'],
      dts: 'src/auto-imports.d.ts',
    }),
    Components({
      resolvers: [ElementPlusResolver()],
      dts: 'src/components.d.ts',
    })
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `@use "@/styles/element/index.scss" as *;`
      }
    }
  },
  server: {
    port: 3000,
    host: true,
    open: true
  }
})
EOF

# 创建 Biome 配置文件
cat > biome.json << 'EOF'
{
  "$schema": "https://biomejs.dev/schemas/1.5.3/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "useExhaustiveDependencies": "off"
      },
      "style": {
        "useImportType": "off"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "formatWithErrors": false,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100,
    "lineEnding": "lf"
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "trailingComma": "es5",
      "semicolons": "asNeeded"
    }
  }
}
EOF

# 创建 TypeScript 配置文件
cat > tsconfig.json << 'EOF'
{
  "extends": "@vue/tsconfig/tsconfig.dom.json",
  "include": [
    "env.d.ts",
    "src/**/*",
    "src/**/*.ts",
    "src/**/*.tsx",
    "src/**/*.vue",
    "auto-imports.d.ts",
    "components.d.ts"
  ],
  "exclude": ["src/**/__tests__/*"],
  "compilerOptions": {
    "composite": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },
    "types": ["element-plus/global", "node"]
  },
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# 创建环境变量示例
cat > .env.example << 'EOF'
# Supabase
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# App
VITE_APP_TITLE=My Vue App
VITE_APP_DESCRIPTION=A modern Vue 3 application
EOF

# 创建 .env.local
cp .env.example .env.local

# 10. 创建样式文件
print_step "创建样式文件"

# 创建 Element Plus 主题文件
cat > src/styles/element/index.scss << 'EOF'
// 定制 Element Plus 主题
// https://element-plus.org/zh-CN/guide/theming.html

// 只需要重写你需要的样式
@forward 'element-plus/theme-chalk/src/common/var.scss' with (
  $colors: (
    'primary': (
      'base': #409eff,
    ),
  ),
);

// 导入所有样式
@use "element-plus/theme-chalk/src/index.scss" as *;
EOF

# 创建全局样式
cat > src/styles/main.scss << 'EOF'
@import './element/index.scss';

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  width: 100%;
  height: 100%;
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB',
    'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#app {
  width: 100%;
  height: 100%;
}

// 自定义滚动条
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
EOF

# 11. 创建核心文件
print_step "创建核心文件"

#创建数据库连接
cat > src/services/supabase.ts << 'EOF'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
EOF

#创建Auth服务
cat > src/services/auth.service.ts << 'EOF'
import { supabase } from './supabase'
import type { User, Session } from '@supabase/supabase-js'

export enum UserRole {
  SUPER_ADMIN = 'super_admin',
  TENANT_ADMIN = 'tenant_admin',
  AGENT = 'agent',
  CUSTOMER = 'customer',
  VIEWER = 'viewer'
}

export interface AuthUser {
  id: string
  email: string
  role: UserRole
  tenant_id?: string
  full_name?: string
  avatar_url?: string
}

export class AuthService {
  // 登录
  async signIn(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })

    if (error) throw error
    return data
  }

  // 注册
  async signUp(email: string, password: string, userData: { full_name: string; phone?: string }) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData,
      },
    })

    if (error) throw error
    return data
  }

  // 登出
  async signOut() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
  }

  // 获取当前用户
  async getCurrentUser(): Promise<AuthUser | null> {
    const { data: { session }, error } = await supabase.auth.getSession()
    if (error || !session) return null

    // 从users表获取用户详细信息
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('id', session.user.id)
      .single()

    if (userError) {
      console.error('Failed to fetch user details:', userError)
      return null
    }

    return {
      id: session.user.id,
      email: session.user.email!,
      role: userData.role as UserRole,
      tenant_id: userData.tenant_id,
      full_name: userData.full_name,
      avatar_url: userData.avatar_url,
    }
  }

  // 监听认证状态变化
  onAuthStateChange(callback: (event: 'SIGNED_IN' | 'SIGNED_OUT' | 'USER_UPDATED', session: Session | null) => void) {
    return supabase.auth.onAuthStateChange((event, session) => {
      callback(event as 'SIGNED_IN' | 'SIGNED_OUT' | 'USER_UPDATED', session)
    })
  }

  // 重置密码
  async resetPassword(email: string) {
    const { error } = await supabase.auth.resetPasswordForEmail(email)
    if (error) throw error
  }

  // 更新密码
  async updatePassword(newPassword: string) {
    const { error } = await supabase.auth.updateUser({
      password: newPassword,
    })
    if (error) throw error
  }

  // 获取会话
  async getSession() {
    const { data, error } = await supabase.auth.getSession()
    if (error) throw error
    return data.session
  }
}

export const authService = new AuthService()
EOF

cat > src/store/auth.ts << 'EOF'
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AuthUser } from '@/services/auth.service'
import { UserRole } from '@/services/auth.service'
import { authService } from '@/services/auth.service'

export const useAuthStore = defineStore('--ticket-system-auth', {
    state: () => {
        const user = ref<AuthUser | null>(null)
        const isLoading = ref(false)
        const error = ref<string | null>(null)

        const isAuthenticated = computed(() => !!user.value)
        const isSuperAdmin = computed(() => user.value?.role === UserRole.SUPER_ADMIN)
        const isTenantAdmin = computed(() => user.value?.role === UserRole.TENANT_ADMIN)
        const isAgent = computed(() => user.value?.role === UserRole.AGENT)
        const isCustomer = computed(() => user.value?.role === UserRole.CUSTOMER)
        const isViewer = computed(() => user.value?.role === UserRole.VIEWER)

        async function loadUser() {
            isLoading.value = true
            try {
                user.value = await authService.getCurrentUser()
                error.value = null
            } catch (err: any) {
                error.value = err.message
                user.value = null
            } finally {
                isLoading.value = false
            }
        }

        async function signIn(email: string, password: string) {
            isLoading.value = true
            try {
                await authService.signIn(email, password)
                await loadUser()
                error.value = null
            } catch (err: any) {
                error.value = err.message
                throw err
            } finally {
                isLoading.value = false
            }
        }

        async function signOut() {
            isLoading.value = true
            try {
                await authService.signOut()
                user.value = null
                error.value = null
            } catch (err: any) {
                error.value = err.message
                throw err
            } finally {
                isLoading.value = false
            }
        }

        // 初始化时加载用户
        loadUser()

        // 监听认证状态变化
        authService.onAuthStateChange(async (event) => {
            if (event === 'SIGNED_OUT') {
                user.value = null
            } else if (event === 'SIGNED_IN' || event === 'USER_UPDATED') {
                await loadUser()
            }
        })

        return {
            user,
            isLoading,
            error,
            isAuthenticated,
            isSuperAdmin,
            isTenantAdmin,
            isAgent,
            isCustomer,
            isViewer,
            signIn,
            signOut,
            loadUser,
        }
    },
    persist: true
})
EOF

# 创建 Font Awesome 配置
cat > src/plugins/fontawesome.ts << 'EOF'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import {
  faUser,
  faHome,
  faCog,
  faBell,
  faSearch,
  faBars,
  faTimes,
  faEdit,
  faTrash,
  faSave,
  faPlus,
  faMinus,
  faDownload,
  faUpload,
  faCheck,
  faExclamationTriangle
} from '@fortawesome/free-solid-svg-icons'

import {
  faGithub,
  faTwitter,
  faFacebook,
  faLinkedin
} from '@fortawesome/free-brands-svg-icons'

// 添加使用的图标
library.add(
  faUser,
  faHome,
  faCog,
  faBell,
  faSearch,
  faBars,
  faTimes,
  faEdit,
  faTrash,
  faSave,
  faPlus,
  faMinus,
  faDownload,
  faUpload,
  faCheck,
  faExclamationTriangle,
  faGithub,
  faTwitter,
  faFacebook,
  faLinkedin
)

export { FontAwesomeIcon }
EOF

# 创建 Supabase 客户端
cat > src/utils/supabase.ts << 'EOF'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('请配置 Supabase 环境变量')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
EOF

# 创建路由配置
cat > src/router/index.ts << 'EOF'
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
EOF

# 创建 Vuex store
cat > src/store/index.ts << 'EOF'
import { createStore } from 'vuex'

export interface State {
  user: {
    id: string | null
    email: string | null
    name: string | null
  } | null
  theme: 'light' | 'dark'
}

export default createStore<State>({
  state: {
    user: null,
    theme: 'light'
  },
  mutations: {
    setUser(state, user) {
      state.user = user
    },
    clearUser(state) {
      state.user = null
    },
    toggleTheme(state) {
      state.theme = state.theme === 'light' ? 'dark' : 'light'
      document.documentElement.setAttribute('data-theme', state.theme)
    }
  },
  actions: {
    async login({ commit }, credentials) {
      // 这里可以调用 Supabase 登录 API
      console.log('登录', credentials)
    },
    async logout({ commit }) {
      commit('clearUser')
    }
  },
  getters: {
    isAuthenticated: (state) => !!state.user,
    currentUser: (state) => state.user,
    currentTheme: (state) => state.theme
  }
})
EOF

# 12. 创建页面和组件
print_step "创建页面和组件"

# 创建主页
cat > src/pages/HomePage.vue << 'EOF'
<template>
  <div class="home-page">
    <el-container>
      <el-header height="64px" class="header">
        <div class="header-content">
          <h1>{{ appTitle }}</h1>
          <div class="header-actions">
            <el-button type="primary" @click="handleLogin">
              <font-awesome-icon :icon="['fas', 'user']" />
              登录
            </el-button>
            <el-switch
              v-model="isDark"
              @change="toggleTheme"
              inline-prompt
              :active-icon="Moon"
              :inactive-icon="Sunny"
            />
          </div>
        </div>
      </el-header>

      <el-main>
        <div class="welcome-section">
          <el-card class="welcome-card">
            <template #header>
              <div class="card-header">
                <h2>欢迎使用 Vue 3 + Element Plus</h2>
              </div>
            </template>

            <div class="tech-stack">
              <el-tag
                v-for="tech in techStack"
                :key="tech.name"
                :type="tech.type"
                size="large"
                class="tech-tag"
              >
                <font-awesome-icon :icon="tech.icon" class="tag-icon" />
                {{ tech.name }}
              </el-tag>
            </div>

            <el-divider />

            <div class="features">
              <h3>项目特性</h3>
              <ul class="feature-list">
                <li v-for="feature in features" :key="feature">
                  <font-awesome-icon :icon="['fas', 'check']" class="feature-icon" />
                  {{ feature }}
                </li>
              </ul>
            </div>

            <el-divider />

            <div class="quick-start">
              <h3>快速开始</h3>
              <el-steps :active="2" align-center class="demo-steps">
                <el-step title="安装依赖" description="yarn add" />
                <el-step title="环境配置" description="配置 .env 文件" />
                <el-step title="启动项目" description="npm run dev" />
              </el-steps>

              <div class="action-buttons">
                <el-button type="primary" size="large" @click="handleGetStarted">
                  开始使用
                </el-button>
                <el-button size="large" @click="handleViewDocs">
                  查看文档
                </el-button>
              </div>
            </div>
          </el-card>

          <div class="dashboard-grid">
            <el-row :gutter="20">
              <el-col :xs="24" :sm="12" :md="8">
                <el-card shadow="hover" class="dashboard-card">
                  <template #header>
                    <div class="card-header">
                      <font-awesome-icon :icon="['fas', 'chart-line']" />
                      <span>统计数据</span>
                    </div>
                  </template>
                  <div class="card-content">
                    <p>这里是您的统计数据展示区域</p>
                  </div>
                </el-card>
              </el-col>

              <el-col :xs="24" :sm="12" :md="8">
                <el-card shadow="hover" class="dashboard-card">
                  <template #header>
                    <div class="card-header">
                      <font-awesome-icon :icon="['fas', 'users']" />
                      <span>用户管理</span>
                    </div>
                  </template>
                  <div class="card-content">
                    <p>管理您的用户和权限</p>
                  </div>
                </el-card>
              </el-col>

              <el-col :xs="24" :sm="24" :md="8">
                <el-card shadow="hover" class="dashboard-card">
                  <template #header>
                    <div class="card-header">
                      <font-awesome-icon :icon="['fas', 'cog']" />
                      <span>系统设置</span>
                    </div>
                  </template>
                  <div class="card-content">
                    <p>配置系统参数和选项</p>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </div>
      </el-main>

      <el-footer height="60px" class="footer">
        <div class="footer-content">
          <p>© 2024 {{ appTitle }}. All rights reserved.</p>
          <div class="footer-links">
            <a href="#" class="footer-link">
              <font-awesome-icon :icon="['fab', 'github']" />
            </a>
            <a href="#" class="footer-link">
              <font-awesome-icon :icon="['fab', 'twitter']" />
            </a>
            <a href="#" class="footer-link">
              <font-awesome-icon :icon="['fab', 'linkedin']" />
            </a>
          </div>
        </div>
      </el-footer>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import { Sunny, Moon } from '@element-plus/icons-vue'
import type { State } from '@/store'

const store = useStore<State>()
const isDark = ref(false)

const appTitle = import.meta.env.VITE_APP_TITLE || 'Vue 3 应用'

const techStack = [
  { name: 'Vue 3', type: 'success', icon: ['fab', 'vuejs'] },
  { name: 'TypeScript', type: '', icon: ['fas', 'code'] },
  { name: 'Vite', type: 'warning', icon: ['fas', 'bolt'] },
  { name: 'Element Plus', type: 'primary', icon: ['fas', 'cube'] },
  { name: 'Supabase', type: 'info', icon: ['fas', 'database'] },
  { name: 'Font Awesome', type: 'danger', icon: ['fas', 'icons'] }
]

const features = [
  '现代化的 Vue 3 开发体验',
  'TypeScript 类型安全',
  'Element Plus UI 组件库',
  'Supabase 后端即服务',
  'Biome 代码格式化',
  '响应式设计',
  '暗色/亮色主题切换'
]

const toggleTheme = () => {
  store.commit('toggleTheme')
}

const handleLogin = () => {
  console.log('登录点击')
}

const handleGetStarted = () => {
  console.log('开始使用')
}

const handleViewDocs = () => {
  window.open('https://github.com/vuejs/vue-next', '_blank')
}
</script>

<style scoped lang="scss">
.home-page {
  min-height: 100vh;
  background-color: var(--el-bg-color-page);
}

.header {
  background-color: var(--el-color-primary);
  color: white;
  box-shadow: var(--el-box-shadow-light);

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 100%;
    padding: 0 24px;

    h1 {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 600;
    }

    .header-actions {
      display: flex;
      gap: 16px;
      align-items: center;
    }
  }
}

.welcome-section {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;

  .welcome-card {
    margin-bottom: 24px;

    .card-header {
      h2 {
        margin: 0;
        color: var(--el-text-color-primary);
      }
    }

    .tech-stack {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 20px;

      .tech-tag {
        padding: 8px 16px;
        font-size: 14px;

        .tag-icon {
          margin-right: 6px;
        }
      }
    }

    .features {
      margin: 20px 0;

      .feature-list {
        list-style: none;
        padding: 0;
        margin: 16px 0;

        li {
          display: flex;
          align-items: center;
          margin-bottom: 12px;
          font-size: 15px;
          color: var(--el-text-color-regular);

          .feature-icon {
            color: var(--el-color-success);
            margin-right: 12px;
            font-size: 14px;
          }
        }
      }
    }

    .quick-start {
      .demo-steps {
        margin: 24px 0;
      }

      .action-buttons {
        display: flex;
        justify-content: center;
        gap: 16px;
        margin-top: 24px;
      }
    }
  }

  .dashboard-grid {
    margin-top: 24px;

    .dashboard-card {
      height: 100%;
      transition: transform 0.3s ease;

      &:hover {
        transform: translateY(-4px);
      }

      .card-header {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;

        svg {
          font-size: 18px;
          color: var(--el-color-primary);
        }
      }

      .card-content {
        color: var(--el-text-color-secondary);
        line-height: 1.6;
      }
    }
  }
}

.footer {
  background-color: var(--el-bg-color);
  border-top: 1px solid var(--el-border-color);
  color: var(--el-text-color-secondary);

  .footer-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 100%;
    padding: 0 24px;

    .footer-links {
      display: flex;
      gap: 16px;

      .footer-link {
        color: inherit;
        text-decoration: none;
        transition: color 0.3s;
        font-size: 18px;

        &:hover {
          color: var(--el-color-primary);
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 12px;
    padding: 12px !important;

    h1 {
      font-size: 1.2rem !important;
    }
  }

  .tech-stack {
    justify-content: center !important;
  }

  .footer-content {
    flex-direction: column;
    gap: 12px;
    text-align: center;
    padding: 12px !important;
  }
}
</style>
EOF

# 创建关于页面
cat > src/pages/AboutPage.vue << 'EOF'
<template>
  <div class="about-page">
    <el-container>
      <el-main>
        <div class="about-content">
          <el-card class="about-card">
            <template #header>
              <div class="card-header">
                <h2>关于此项目</h2>
              </div>
            </template>

            <div class="project-info">
              <el-descriptions title="项目信息" :column="2" border>
                <el-descriptions-item label="项目名称">
                  {{ appTitle }}
                </el-descriptions-item>
                <el-descriptions-item label="版本">1.0.0</el-descriptions-item>
                <el-descriptions-item label="框架">Vue 3</el-descriptions-item>
                <el-descriptions-item label="构建工具">Vite</el-descriptions-item>
                <el-descriptions-item label="UI 框架">Element Plus</el-descriptions-item>
                <el-descriptions-item label="代码格式化">Biome</el-descriptions-item>
              </el-descriptions>
            </div>

            <div class="team-section">
              <h3>开发团队</h3>
              <el-row :gutter="20">
                <el-col :xs="24" :sm="12" :md="8" v-for="member in team" :key="member.id">
                  <el-card class="team-card" shadow="hover">
                    <div class="team-member">
                      <el-avatar :size="80" :src="member.avatar" />
                      <h4>{{ member.name }}</h4>
                      <p class="role">{{ member.role }}</p>
                      <p class="bio">{{ member.bio }}</p>
                      <div class="social-links">
                        <a v-for="link in member.social" :key="link.icon" :href="link.url" target="_blank">
                          <font-awesome-icon :icon="['fab', link.icon]" />
                        </a>
                      </div>
                    </div>
                  </el-card>
                </el-col>
              </el-row>
            </div>

            <div class="tech-stack-section">
              <h3>技术栈</h3>
              <el-timeline>
                <el-timeline-item
                  v-for="tech in technologies"
                  :key="tech.name"
                  :timestamp="tech.year"
                  placement="top"
                >
                  <el-card>
                    <h4>{{ tech.name }}</h4>
                    <p>{{ tech.description }}</p>
                    <el-tag :type="tech.type">{{ tech.category }}</el-tag>
                  </el-card>
                </el-timeline-item>
              </el-timeline>
            </div>

            <div class="cta-section">
              <el-button type="primary" size="large" @click="goHome">
                <font-awesome-icon :icon="['fas', 'home']" />
                返回首页
              </el-button>
              <el-button type="success" size="large" @click="viewSource">
                <font-awesome-icon :icon="['fab', 'github']" />
                查看源码
              </el-button>
            </div>
          </el-card>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()
const appTitle = import.meta.env.VITE_APP_TITLE || 'Vue 3 应用'

const team = [
  {
    id: 1,
    name: '张三',
    role: '前端开发工程师',
    bio: '专注于 Vue 和 TypeScript 开发',
    avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
    social: [
      { icon: 'github', url: 'https://github.com' },
      { icon: 'twitter', url: 'https://twitter.com' }
    ]
  },
  {
    id: 2,
    name: '李四',
    role: 'UI/UX 设计师',
    bio: '负责产品设计和用户体验',
    avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
    social: [
      { icon: 'dribbble', url: 'https://dribbble.com' },
      { icon: 'behance', url: 'https://behance.net' }
    ]
  }
]

const technologies = [
  {
    name: 'Vue 3',
    year: '2020',
    description: '渐进式 JavaScript 框架',
    category: '前端框架',
    type: 'success'
  },
  {
    name: 'TypeScript',
    year: '2012',
    description: 'JavaScript 的超集，添加了静态类型',
    category: '编程语言',
    type: ''
  },
  {
    name: 'Vite',
    year: '2020',
    description: '下一代前端构建工具',
    category: '构建工具',
    type: 'warning'
  },
  {
    name: 'Element Plus',
    year: '2021',
    description: '基于 Vue 3 的组件库',
    category: 'UI 框架',
    type: 'primary'
  },
  {
    name: 'Supabase',
    year: '2020',
    description: '开源的 Firebase 替代品',
    category: '后端服务',
    type: 'info'
  }
]

const goHome = () => {
  router.push('/')
}

const viewSource = () => {
  window.open('https://github.com', '_blank')
}
</script>

<style scoped lang="scss">
.about-page {
  min-height: 100vh;
  background-color: var(--el-bg-color-page);
}

.about-content {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;

  .about-card {
    .card-header {
      h2 {
        margin: 0;
        color: var(--el-text-color-primary);
      }
    }

    .project-info {
      margin-bottom: 32px;
    }

    .team-section {
      margin: 32px 0;

      h3 {
        margin-bottom: 24px;
        color: var(--el-text-color-primary);
      }

      .team-card {
        margin-bottom: 20px;
        transition: transform 0.3s ease;

        &:hover {
          transform: translateY(-4px);
        }

        .team-member {
          text-align: center;
          padding: 20px;

          h4 {
            margin: 16px 0 8px;
            color: var(--el-text-color-primary);
          }

          .role {
            color: var(--el-color-primary);
            font-weight: 500;
            margin-bottom: 8px;
          }

          .bio {
            color: var(--el-text-color-secondary);
            line-height: 1.6;
            margin-bottom: 16px;
          }

          .social-links {
            display: flex;
            justify-content: center;
            gap: 16px;

            a {
              color: var(--el-text-color-secondary);
              font-size: 18px;
              transition: color 0.3s;

              &:hover {
                color: var(--el-color-primary);
              }
            }
          }
        }
      }
    }

    .tech-stack-section {
      margin: 32px 0;

      h3 {
        margin-bottom: 24px;
        color: var(--el-text-color-primary);
      }
    }

    .cta-section {
      display: flex;
      justify-content: center;
      gap: 16px;
      margin-top: 32px;
      padding-top: 24px;
      border-top: 1px solid var(--el-border-color);
    }
  }
}

@media (max-width: 768px) {
  .about-content {
    padding: 16px;

    .team-section {
      .el-col {
        margin-bottom: 16px;
      }
    }

    .cta-section {
      flex-direction: column;
    }
  }
}
</style>
EOF

# 创建 App.vue
cat > src/App.vue << 'EOF'
<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useStore } from 'vuex'
import type { State } from '@/store'

const store = useStore<State>()

// 初始化主题
onMounted(() => {
  const savedTheme = localStorage.getItem('theme') as 'light' | 'dark' | null
  if (savedTheme) {
    store.commit('toggleTheme')
  }
})
</script>

<style lang="scss">
@import '@/styles/main.scss';

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

// 全局样式
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.page-transition {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
EOF

# 创建 main.ts
cat > src/main.ts << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import { FontAwesomeIcon } from './plugins/fontawesome'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

// 导入样式
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'

const app = createApp(App)

// 注册全局组件
app.component('FontAwesomeIcon', FontAwesomeIcon)

// 将 pinia 实例挂载到应用
const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)
app.use(pinia)

// 使用插件
app.use(ElementPlus)
app.use(router)
app.use(store)

app.mount('#app')
EOF

# 13. 更新 package.json 脚本
print_step "更新 package.json 脚本"

# 创建临时 package.json 文件
cat > package.tmp.json << 'EOF'
{
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc && vite build",
    "preview": "vite preview",
    "type-check": "vue-tsc --noEmit",
    "format": "biome format --write ./src",
    "lint": "biome lint ./src",
    "format:check": "biome format ./src",
    "lint:fix": "biome lint --apply ./src",
    "prepare": "husky install",
    "postinstall": "echo '请配置 .env 文件中的 Supabase 环境变量'"
  },
  "dependencies": {
    "@element-plus/icons-vue": "^2.3.0",
    "@fortawesome/fontawesome-svg-core": "^6.5.1",
    "@fortawesome/free-brands-svg-icons": "^6.5.1",
    "@fortawesome/free-regular-svg-icons": "^6.5.1",
    "@fortawesome/free-solid-svg-icons": "^6.5.1",
    "@fortawesome/vue-fontawesome": "^3.0.6",
    "@supabase/supabase-js": "^2.39.0",
    "element-plus": "^2.4.4",
    "vue": "^3.4.21",
    "vue-router": "^4.2.5",
    "vuex": "^4.1.0"
  },
  "devDependencies": {
    "@biomejs/biome": "^1.5.3",
    "@supabase/ssr": "^0.0.5",
    "@types/node": "^20.11.20",
    "@vitejs/plugin-vue": "^5.0.4",
    "@vue/tsconfig": "^0.5.0",
    "sass": "^1.70.0",
    "typescript": "~5.3.3",
    "unplugin-auto-import": "^0.17.5",
    "unplugin-vue-components": "^0.26.0",
    "vite": "^5.1.0",
    "vue-tsc": "^1.8.27"
  }
}
EOF

# 合并 package.json 文件
jq -s '.[0] * .[1]' package.json package.tmp.json > package.json.tmp && mv package.json.tmp package.json
rm package.tmp.json

# 14. 创建 README.md
cat > README.md << EOF
# $PROJECT_NAME

一个现代化的 Vue 3 + TypeScript + Element Plus + Supabase 项目脚手架。

## ✨ 特性

- ⚡ **Vite** - 极速的开发体验
- 🎨 **Vue 3** - 渐进式 JavaScript 框架
- 📘 **TypeScript** - 类型安全的 JavaScript
- 🎯 **Element Plus** - 基于 Vue 3 的组件库
- 🗄️ **Supabase** - 开源的 Firebase 替代品
- 🎨 **Font Awesome** - 矢量图标库
- 🧹 **Biome** - 现代化的代码格式化工具
- 🎭 **暗色/亮色主题** - 支持主题切换
- 📱 **响应式设计** - 移动端友好

## 🚀 快速开始

### 环境要求

- Node.js >= 16
- npm >= 7 或 yarn >= 1.22 或 pnpm >= 7

### 安装依赖

\`\`\`bash
yarn add
# 或
yarn install
# 或
pyarn add
\`\`\`

### 环境配置

1. 复制环境变量文件：

\`\`\`bash
cp .env.example .env.local
\`\`\`

2. 在 \`.env.local\` 中配置以下变量：

\`\`\`env
# Supabase 配置（从 supabase.com 获取）
VITE_SUPABASE_URL=your_project_url
VITE_SUPABASE_ANON_KEY=your_anon_key

# 应用配置
VITE_APP_TITLE=My Vue App
VITE_APP_DESCRIPTION=A modern Vue 3 application
\`\`\`

### 启动开发服务器

\`\`\`bash
npm run dev
# 或
yarn dev
# 或
pnpm dev
\`\`\`

打开浏览器访问 \`http://localhost:3000\`

## 📁 项目结构

\`\`\`
$PROJECT_NAME/
├── src/
│   ├── assets/          # 静态资源
│   ├── components/      # 组件
│   ├── composables/     # Vue 组合式函数
│   ├── layouts/         # 布局组件
│   ├── pages/           # 页面组件
│   ├── router/          # 路由配置
│   ├── store/           # Vuex 状态管理
│   ├── styles/          # 样式文件
│   ├── utils/           # 工具函数
│   ├── App.vue          # 根组件
│   └── main.ts          # 应用入口
├── public/              # 公共资源
├── .env.example         # 环境变量示例
├── biome.json          # Biome 配置
├── index.html          # HTML 模板
├── package.json        # 依赖配置
├── tsconfig.json       # TypeScript 配置
└── vite.config.ts      # Vite 配置
\`\`\`

## 🛠️ 可用脚本

- \`npm run dev\` - 启动开发服务器
- \`npm run build\` - 构建生产版本
- \`npm run preview\` - 预览生产构建
- \`npm run type-check\` - 类型检查
- \`npm run format\` - 格式化代码
- \`npm run lint\` - 代码检查
- \`npm run lint:fix\` - 自动修复代码问题
- \`npm run format:check\` - 检查代码格式

## 🎨 UI 组件

本项目使用 **Element Plus** 作为 UI 组件库，所有组件都已配置为按需导入。

### 使用示例

\`\`\`vue
<template>
  <el-button type="primary" @click="handleClick">
    点击我
  </el-button>
</template>
\`\`\`

## 🗄️ Supabase 集成

### 初始化客户端

\`\`\`typescript
import { supabase } from '@/utils/supabase'

// 查询示例
const { data, error } = await supabase
  .from('todos')
  .select('*')
  .eq('completed', false)
\`\`\`

### 数据库类型

在 \`src/utils/supabase.ts\` 中定义数据库类型，以获得完整的 TypeScript 支持。

## 🎭 主题系统

项目支持暗色/亮色主题切换：

\`\`\`typescript
// 切换主题
store.commit('toggleTheme')
\`\`\`

## 🔧 代码质量

### Biome 配置

项目使用 **Biome** 替代 ESLint 和 Prettier：

- 格式化规则：单引号、2空格缩进、100字符行宽
- 代码检查：启用推荐规则
- 自动修复：支持大部分规则自动修复

### Git Hooks

建议配置 Git Hooks 以确保代码质量：

\`\`\`bash
npx husky install
npx husky add .husky/pre-commit "npm run lint"
npx husky add .husky/pre-push "npm run type-check"
\`\`\`

## 📱 响应式设计

项目已配置响应式断点：

- xs: < 768px (手机)
- sm: ≥ 768px (平板)
- md: ≥ 992px (桌面)
- lg: ≥ 1200px (大桌面)

## 🔄 图标系统

使用 **Font Awesome** 作为图标库：

\`\`\`vue
<template>
  <font-awesome-icon :icon="['fas', 'user']" />
  <font-awesome-icon :icon="['fab', 'github']" />
</template>
\`\`\`

## 📖 学习资源

- [Vue 3 文档](https://vuejs.org/)
- [Vite 文档](https://vitejs.dev/)
- [Element Plus 文档](https://element-plus.org/)
- [Supabase 文档](https://supabase.com/docs)
- [TypeScript 文档](https://www.typescriptlang.org/)
- [Biome 文档](https://biomejs.dev/)

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (\`git checkout -b feature/AmazingFeature\`)
3. 提交更改 (\`git commit -m 'Add some AmazingFeature'\`)
4. 推送分支 (\`git push origin feature/AmazingFeature\`)
5. 打开 Pull Request

## 📄 许可证

MIT
EOF

# 15. 创建 .gitignore
cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release

# Dependency directories
node_modules/
jspm_packages/

# Snowpack dependency directory (https://snowpack.dev/)
web_modules/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.local
.env.*.local

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and not Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*

# IDE
.vscode/*
!.vscode/extensions.json
.idea
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Biome
biome.json

# Vite
dist
dist-ssr
*.local

# Temporary folders
tmp
temp
EOF

# 16. 创建示例组件
print_step "创建示例组件"

# 创建示例组件
cat > src/components/HelloWorld.vue << 'EOF'
<template>
  <div class="hello-world">
    <el-card class="demo-card">
      <template #header>
        <div class="card-header">
          <h3>{{ title }}</h3>
        </div>
      </template>

      <p class="description">{{ description }}</p>

      <el-divider />

      <div class="features">
        <h4>特性演示</h4>
        <el-space wrap>
          <el-button type="primary" @click="showMessage">
            <font-awesome-icon :icon="['fas', 'bell']" />
            消息提示
          </el-button>
          <el-button type="success" @click="showSuccess">
            <font-awesome-icon :icon="['fas', 'check']" />
            成功提示
          </el-button>
          <el-button type="warning" @click="showWarning">
            <font-awesome-icon :icon="['fas', 'exclamation-triangle']" />
            警告提示
          </el-button>
          <el-button type="danger" @click="showError">
            <font-awesome-icon :icon="['fas', 'times']" />
            错误提示
          </el-button>
        </el-space>
      </div>

      <el-divider />

      <div class="form-demo">
        <h4>表单演示</h4>
        <el-form :model="form" label-width="80px" class="demo-form">
          <el-form-item label="用户名">
            <el-input v-model="form.username" placeholder="请输入用户名">
              <template #prefix>
                <font-awesome-icon :icon="['fas', 'user']" />
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="邮箱">
            <el-input v-model="form.email" placeholder="请输入邮箱">
              <template #prefix>
                <font-awesome-icon :icon="['fas', 'envelope']" />
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="角色">
            <el-select v-model="form.role" placeholder="请选择角色">
              <el-option label="管理员" value="admin" />
              <el-option label="编辑" value="editor" />
              <el-option label="查看者" value="viewer" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitForm">提交</el-button>
            <el-button @click="resetForm">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <el-divider />

      <div class="table-demo">
        <h4>表格演示</h4>
        <el-table :data="tableData" stripe style="width: 100%">
          <el-table-column prop="date" label="日期" width="180" />
          <el-table-column prop="name" label="姓名" width="180" />
          <el-table-column prop="address" label="地址" />
          <el-table-column label="操作" width="120">
            <template #default="{ row }">
              <el-button size="small" @click="handleEdit(row)">
                <font-awesome-icon :icon="['fas', 'edit']" />
              </el-button>
              <el-button size="small" type="danger" @click="handleDelete(row)">
                <font-awesome-icon :icon="['fas', 'trash']" />
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

interface FormData {
  username: string
  email: string
  role: string
}

interface TableData {
  date: string
  name: string
  address: string
}

const props = defineProps({
  title: {
    type: String,
    default: 'Hello World Component'
  },
  description: {
    type: String,
    default: '这是一个示例组件，展示了 Element Plus 组件的使用方式'
  }
})

const form = ref<FormData>({
  username: '',
  email: '',
  role: ''
})

const tableData = ref<TableData[]>([
  {
    date: '2024-01-01',
    name: '张三',
    address: '上海市浦东新区'
  },
  {
    date: '2024-01-02',
    name: '李四',
    address: '北京市海淀区'
  },
  {
    date: '2024-01-03',
    name: '王五',
    address: '深圳市南山区'
  }
])

const showMessage = () => {
  ElMessage('这是一个普通提示')
}

const showSuccess = () => {
  ElMessage.success('这是一个成功提示')
}

const showWarning = () => {
  ElMessage.warning('这是一个警告提示')
}

const showError = () => {
  ElMessage.error('这是一个错误提示')
}

const submitForm = () => {
  if (!form.value.username || !form.value.email) {
    ElMessage.warning('请填写完整信息')
    return
  }
  
  ElMessage.success(`提交成功！用户名: ${form.value.username}, 邮箱: ${form.value.email}`)
}

const resetForm = () => {
  form.value = {
    username: '',
    email: '',
    role: ''
  }
}

const handleEdit = (row: TableData) => {
  ElMessageBox.confirm(`确定要编辑 ${row.name} 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    ElMessage.success(`开始编辑 ${row.name}`)
  }).catch(() => {
    ElMessage.info('取消编辑')
  })
}

const handleDelete = (row: TableData) => {
  ElMessageBox.confirm(`确定要删除 ${row.name} 吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'error'
  }).then(() => {
    const index = tableData.value.findIndex(item => item.name === row.name)
    if (index > -1) {
      tableData.value.splice(index, 1)
      ElMessage.success('删除成功')
    }
  }).catch(() => {
    ElMessage.info('取消删除')
  })
}
</script>

<style scoped lang="scss">
.hello-world {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;

  .demo-card {
    .card-header {
      h3 {
        margin: 0;
        color: var(--el-text-color-primary);
      }
    }

    .description {
      color: var(--el-text-color-regular);
      line-height: 1.6;
      margin-bottom: 20px;
    }

    .features {
      margin-bottom: 20px;

      h4 {
        margin-bottom: 16px;
        color: var(--el-text-color-primary);
      }
    }

    .form-demo {
      margin-bottom: 20px;

      h4 {
        margin-bottom: 16px;
        color: var(--el-text-color-primary);
      }

      .demo-form {
        max-width: 500px;
      }
    }

    .table-demo {
      h4 {
        margin-bottom: 16px;
        color: var(--el-text-color-primary);
      }
    }
  }
}
</style>
EOF

# 17. 创建 TypeScript 声明文件
cat > env.d.ts << 'EOF'
/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  readonly VITE_SUPABASE_ANON_KEY: string
  readonly VITE_APP_TITLE: string
  readonly VITE_APP_DESCRIPTION: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
EOF

# 18. 安装 jq (如果不存在) 并清理
print_step "安装 jq 并清理"

if ! command -v jq &> /dev/null; then
  print_warning "jq 未安装，正在安装..."
  if command -v brew &> /dev/null; then
    brew install jq
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y jq
  elif command -v yum &> /dev/null; then
    sudo yum install -y jq
  else
    print_error "无法安装 jq，请手动安装: https://stedolan.github.io/jq/download/"
    print_warning "跳过 package.json 合并步骤"
  fi
fi

# 19. 清理并完成
print_step "安装依赖..."
yarn add

print_step "项目创建完成！🎉"
echo ""
echo -e "${GREEN}✅ 项目创建成功！${NC}"
echo ""
echo "📁 项目目录: $(pwd)"
echo ""
echo "🚀 启动项目:"
echo "  cd $PROJECT_NAME"
echo "  npm run dev"
echo ""
echo "📋 后续步骤:"
echo "  1. 复制 .env.example 为 .env.local"
echo "  2. 配置 Supabase 环境变量"
echo "  3. 运行 npm run dev 启动开发服务器"
echo "  4. 访问 http://localhost:3000"
echo ""
echo "🛠️  代码质量工具:"
echo "  npm run format    # 格式化代码"
echo "  npm run lint      # 代码检查"
echo "  npm run type-check # TypeScript 类型检查"
echo ""
echo "📚 查看 README.md 获取更多信息"
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
                <el-step title="启动项目" description="yarn dev" />
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

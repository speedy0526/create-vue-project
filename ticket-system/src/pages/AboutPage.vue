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

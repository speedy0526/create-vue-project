# ticket-manager

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

```bash
yarn add
# 或
yarn install
# 或
pyarn add
```

### 环境配置

1. 复制环境变量文件：

```bash
cp .env.example .env.local
```

2. 在 `.env.local` 中配置以下变量：

```env
# Supabase 配置（从 supabase.com 获取）
VITE_SUPABASE_URL=your_project_url
VITE_SUPABASE_ANON_KEY=your_anon_key

# 应用配置
VITE_APP_TITLE=My Vue App
VITE_APP_DESCRIPTION=A modern Vue 3 application
```

### 启动开发服务器

```bash
yarn dev
# 或
yarn dev
# 或
pnpm dev
```

打开浏览器访问 `http://localhost:3000`

## 📁 项目结构

```
ticket-manager/
├── src/
│   ├── assets/          # 静态资源
│   ├── components/      # 组件
│   ├── composables/     # Vue 组合式函数
│   ├── layouts/         # 布局组件
│   ├── views/           # 页面组件
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
```

## 🛠️ 可用脚本

- `yarn dev` - 启动开发服务器
- `yarn build` - 构建生产版本
- `yarn preview` - 预览生产构建
- `yarn type-check` - 类型检查
- `yarn format` - 格式化代码
- `yarn lint` - 代码检查
- `yarn lint:fix` - 自动修复代码问题
- `yarn format:check` - 检查代码格式

## 🎨 UI 组件

本项目使用 **Element Plus** 作为 UI 组件库，所有组件都已配置为按需导入。

### 使用示例

```vue
<template>
  <el-button type="primary" @click="handleClick">
    点击我
  </el-button>
</template>
```

## 🗄️ Supabase 集成

### 初始化客户端

```typescript
import { supabase } from '@/utils/supabase'

// 查询示例
const { data, error } = await supabase
  .from('todos')
  .select('*')
  .eq('completed', false)
```

### 数据库类型

在 `src/utils/supabase.ts` 中定义数据库类型，以获得完整的 TypeScript 支持。

## 🎭 主题系统

项目支持暗色/亮色主题切换：

```typescript
// 切换主题
store.commit('toggleTheme')
```

## 🔧 代码质量

### Biome 配置

项目使用 **Biome** 替代 ESLint 和 Prettier：

- 格式化规则：单引号、2空格缩进、100字符行宽
- 代码检查：启用推荐规则
- 自动修复：支持大部分规则自动修复


## 📱 响应式设计

项目已配置响应式断点：

- xs: < 768px (手机)
- sm: ≥ 768px (平板)
- md: ≥ 992px (桌面)
- lg: ≥ 1200px (大桌面)

## 🔄 图标系统

使用 **Font Awesome** 作为图标库：

```vue
<template>
  <font-awesome-icon :icon="['fas', 'user']" />
  <font-awesome-icon :icon="['fab', 'github']" />
</template>
```

## 📖 学习资源

- [Vue 3 文档](https://vuejs.org/)
- [Vite 文档](https://vitejs.dev/)
- [Element Plus 文档](https://element-plus.org/)
- [Supabase 文档](https://supabase.com/docs)
- [TypeScript 文档](https://www.typescriptlang.org/)
- [Biome 文档](https://biomejs.dev/)

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

MIT

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

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('请配置 Supabase 环境变量')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// 类型定义示例（根据你的数据库结构修改）
export type Database = {
  public: {
    Tables: {
      todos: {
        Row: {
          id: string
          title: string
          completed: boolean
          created_at: string
          user_id: string
        }
        Insert: {
          id?: string
          title: string
          completed?: boolean
          created_at?: string
          user_id: string
        }
        Update: {
          id?: string
          title?: string
          completed?: boolean
          created_at?: string
          user_id?: string
        }
      }
    }
  }
}

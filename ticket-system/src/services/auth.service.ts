import { supabase } from '@/utils/supabase'
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
